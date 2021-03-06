library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity s7_Acrade is
    Port ( sysClk : in STD_LOGIC;                --12Mhz System clock
           LEDclk : buffer STD_LOGIC;            --30hz clock
           payout_clk : buffer STD_LOGIC;        --2Hz payout clock
           payout_LED : out STD_LOGIC;
           LED_OFF : out STD_LOGIC_VECTOR (2 downto 0);        --Shuts RGB led off
           coin_in, player_stop : in STD_LOGIC;  --Buttons
           reset : inout STD_LOGIC;    
           seg: inout std_logic_vector(6 downto 0); --Seven segment display select 
           disp: out STD_LOGIC_VECTOR (6 downto 0);                          --display          
           Clm0, Clm1, Clm2, Clm3, Clm4, Clm5, Clm6, Clm7 : inout STD_LOGIC; --LED array          
           Rw0, Rw1, Rw2, Rw3 : inout STD_LOGIC);                            --LED array
           
    signal pause, pause_delay : STD_LOGIC := '0';                                        --latch signal
    signal dbnc1, dbnc2, dbnc3, dbnc4, dbnc5, dbnc6 : STD_LOGIC;
    signal coin_in_dbnc, player_stop_dbnc : STD_LOGIC; 
    signal cred_data: std_logic_vector(3 downto 0);
    signal seg_sel: std_logic_vector(6 downto 0); --Seven segment display select
    signal fastClk, genClk : STD_LOGIC;          --1kHz, 100Hz. 100Hz inverted signal clock
    signal payout : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";
    signal big_win : STD_LOGIC_VECTOR (11 downto 0) := "000011111010";
    signal payout_ones, payout_tens, payout_hundreds : STD_LOGIC_VECTOR (3 downto 0);   --BCD output for payout
    signal win_ones, win_tens, win_hundreds : STD_LOGIC_VECTOR (3 downto 0);   --BCD output for big_win
    signal payout_thousands, win_thousands : STD_LOGIC_VECTOR (3 downto 0);   --BCD output for payout/win, NOT USED
    
--signal reset : STD_LOGIC;                                        --Reset condition   
end s7_Acrade;

architecture Behavioral of s7_Acrade is

begin

process (sysClk)

variable LEDcnt: integer range 0 to 399999;  -- Turns 12Mhz to 30Hz
variable gencnt: integer range 0 to 119999;  -- Turns 12Mhz to 100Hz
variable genIcnt: integer range 0 to 399999;  -- Turns 12Mhz to 30Hz
variable fastcnt: integer range 0 to 29999;  -- Turns 12Mhz to 400Hz
variable payout_bcd : STD_LOGIC_VECTOR (11 downto 0);
variable big_win_bcd : STD_LOGIC_VECTOR (11 downto 0);
variable payout_clk_cnt : integer range 0 to 5999999;
variable bcd, win_bcd : UNSIGNED (15 downto 0) := (others => '0'); -- variable to store the output BCD number

	begin
LED_OFF <= "111";
	
--CLOCKS	
	--CREATES 30HZ CLOCK for LEDs
		if pause='1' then                     --Stops 30Hz clock
            LEDclk<='0';
            LEDcnt:=0;
		elsif rising_edge(sysClk) then
	        LEDcnt:=LEDcnt+1;
		if (LEDcnt=199999) then
			LEDclk<='1';
		elsif (LEDcnt=399999) then
			LEDclk<='0';
			LEDcnt:=0;
end if;
end if;
    --CREATES 100HZ CLOCK for debounce
		if rising_edge(sysClk) then
	        gencnt:=gencnt+1;
		if (gencnt=59999) then
			genClk<='1';
		elsif (gencnt=119999) then
			genClk<='0';
			gencnt:=0;
end if;
end if;

    --CREATES 400HZ CLOCK for 7-seg display
		if rising_edge(sysClk) then
	        fastcnt:=fastcnt+1;
		if (fastcnt=14999) then
			fastClk<='1';
		elsif (fastcnt=29999) then
			fastClk<='0';
			fastcnt:=0;
end if;
end if;

--CREDITS IN + STOP CODE   
if rising_edge(genClk) then                              --debounce for coin_in button
    dbnc1 <= coin_in; dbnc2 <= dbnc1; dbnc3 <= dbnc2;
end if;
coin_in_dbnc <= dbnc1 and dbnc2 and not dbnc3;           --single pulse, debounced

if payout_clk = '1' then
    dbnc4 <= '0'; dbnc5 <= '0'; dbnc6 <= '0';
elsif rising_edge(genClk) then                              --debounce for player_stop button
    dbnc4 <= player_stop; dbnc5 <= dbnc4; dbnc6 <= dbnc5;
end if;

if cred_data = "0000"  then                          --Credits need to be added before latch happens
    player_stop_dbnc <= '0';                         --Locks debounce output to 0 if credits are at 0
else
    player_stop_dbnc <= dbnc4 and dbnc5 and not dbnc6;    --single pulse, debounced
end if;

pause <= player_stop_dbnc or (pause and not reset);       --Stops 30Hz clock by latching shift register 


if rising_edge(genclk) then
            if coin_in_dbnc = '1' then
                cred_data <= cred_data + "0001";   -- counting credits up                          
            elsif player_stop_dbnc = '1' then      
                cred_data <= cred_data - "0001";   -- counting credits down
            end if;
        end if;

--LED ARRAY
if reset = '1' then                                                --Resets shift register
    Clm0 <= '1'; Clm1 <= '0'; Clm2 <= '0'; Clm3 <= '0'; 
    Clm4 <= '0'; Clm5 <= '0'; Clm6 <= '0'; Clm7 <= '0'; 
elsif rising_edge (LEDclk) then                                     --Shift register, X
    Clm1 <= Clm0; Clm2 <= Clm1; Clm3 <= Clm2; Clm4 <= Clm3; 
    Clm5 <= Clm4; Clm6 <= Clm5; Clm7 <= Clm6; Clm0 <= Clm7;  
end if;

if reset = '1' then                                                 --Resets shift register
    Rw0 <= '0'; Rw1 <= '1'; Rw2 <= '1'; Rw3 <= '1';
elsif rising_edge (LEDclk) and Clm7 = '1' then                      --Shift Register Y
    Rw1 <= Rw0; Rw2 <= Rw1; Rw3 <= Rw2; Rw0 <= Rw3;
end if;     

--SHIFT ADD 3 ALGORITHM CODE for payout
bcd := (others => '0');
payout_bcd(11 downto 0) := payout;     -- read input into payout_bcd variable

    for i in 0 to 11 loop
    
      if bcd(3 downto 0) > 4 then 
         bcd(3 downto 0) := bcd(3 downto 0) + 3;
      end if;
      
      if bcd(7 downto 4) > 4 then 
        bcd(7 downto 4) := bcd(7 downto 4) + 3;
      end if;
    
      if bcd(11 downto 8) > 4 then  
        bcd(11 downto 8) := bcd(11 downto 8) + 3;
      end if;

      bcd := bcd(14 downto 0) & payout_bcd(11);	      -- shift bcd left by 1 bit, copy MSB of payout_bcd into LSB of bcd
      payout_bcd := payout_bcd(10 downto 0) & '0';	  -- shift payout_bcd left by 1 bit
    
    end loop;
 
    -- set outputs for payout
    payout_ones <= STD_LOGIC_VECTOR(bcd(3 downto 0));
    payout_tens <= STD_LOGIC_VECTOR(bcd(7 downto 4));
    payout_hundreds <= STD_LOGIC_VECTOR(bcd(11 downto 8));
    payout_thousands <= STD_LOGIC_VECTOR(bcd(15 downto 12));
    
--SHIFT ADD 3 ALGORITHM CODE for big_win
    win_bcd := (others => '0');
    big_win_bcd(11 downto 0) := big_win;     -- read input into win_bcd variable
    
        for i in 0 to 11 loop
        
          if win_bcd(3 downto 0) > 4 then 
             win_bcd(3 downto 0) := win_bcd(3 downto 0) + 3;
          end if;
          
          if win_bcd(7 downto 4) > 4 then 
            win_bcd(7 downto 4) := win_bcd(7 downto 4) + 3;
          end if;
        
          if win_bcd(11 downto 8) > 4 then  
            win_bcd(11 downto 8) := win_bcd(11 downto 8) + 3;
          end if;
    
          win_bcd := win_bcd(14 downto 0) & big_win_bcd(11);  -- shift bcd left by 1 bit, copy MSB of win_bcd into LSB of bcd
          big_win_bcd := big_win_bcd(10 downto 0) & '0';      -- shift win_bcd left by 1 bit
        
        end loop;
     
        -- set outputs for payout
        win_ones <= STD_LOGIC_VECTOR(win_bcd(3 downto 0));
        win_tens <= STD_LOGIC_VECTOR(win_bcd(7 downto 4));
        win_hundreds <= STD_LOGIC_VECTOR(win_bcd(11 downto 8));
        win_thousands <= STD_LOGIC_VECTOR(win_bcd(15 downto 12));    

--WIN CONDITIONS CODE AND PAYOUTS



  if pause = '0' then
    payout_clk <= '0';
    payout_clk_cnt := 5870000;           --Leaves payout_clk at '0' for ~10ms for debounce
    payout_LED <= '0';                   --LED for payout
  elsif rising_edge(sysClk) then
    payout_clk_cnt := payout_clk_cnt + 1;
    
    
        if (payout_clk_cnt = 1) and payout = "000000000000" then
              pause <= '0';
    
              
--        elsif (payout_clk_cnt = 5999999) and payout > "000000000000" then 
--            payout_clk <= '0';   
            
            
        elsif (payout_clk_cnt = 5999999) and payout = "000000000000" then
              payout_clk <= '1';
              if pause = '1' and (Clm4 = '1' and Rw3 = '0') then					  --win 100+
                    payout <= payout + big_win;
                    big_win <= "000011111010";
              end if;    
              if pause = '1' and ((Clm5 = '1' or Clm3 = '1') and Rw3 = '0') then      --win 10
                    payout <= payout + "000000001010";
                    big_win <= big_win + "000000000101";
              end if;    
              if pause = '1' and ((Clm6 = '1' or Clm2 = '1') and Rw3 = '0') then   --win 9
                    payout <= payout + "000000001001";
                    big_win <= big_win + "000000000101";
              end if;
              if pause = '1' and ((Clm7 = '1' or Clm1 = '1') and Rw3 = '0') then   --win 8
                    payout <= payout + "000000001000";
                    big_win <= big_win + "000000000101";
              end if;    
              if pause = '1' and (Clm0 = '1' and (Rw3 = '0' or Rw2 = '0')) then    --win 7
                    payout <= payout + "000000000111";
                    big_win <= big_win + "000000000101";
              end if;    
              if pause = '1' and ((Clm1 = '1' and Rw2 = '0') or 
                    (Clm7 = '1' and Rw0 = '0')) then                       --win 6
                    payout <= payout + "000000000110";
                    big_win <= big_win + "000000000101";
              end if;    
              if pause = '1' and ((Clm2 = '1' and Rw2 = '0') or 
                    (Clm6 = '1' and Rw0 = '0')) then                       --win 5
                    payout <= payout + "000000000101";
                    big_win <= big_win + "000000000101";
              end if;    
              if pause = '1' and ((Clm3 = '1' and Rw2 = '0') or 
                    (Clm5 = '1' and Rw0 = '0')) then                       --win 4
                    payout <= payout + "000000000100";
                    big_win <= big_win + "000000000101";
              end if;    
              if pause = '1' and (Clm4 = '1' and (Rw0 = '0' or Rw2 = '0')) then    --win 3
                    payout <= payout + "000000000011";
                    big_win <= big_win + "000000000101";
              end if; 
              if pause = '1' and ((Clm3 = '1' and Rw0 = '0') or 
                    (Clm5 = '1' and Rw2 = '0')) then                           --win 2
                    payout <= payout + "000000000010";
                    big_win <= big_win + "000000000101";
              end if;
              if pause = '1' and (Rw1 = '0' or (Rw2 = '0' and (Clm6 = '1' or Clm7 = '1')) 
                 or (Rw0 = '0' and (Clm0 = '1' or Clm1 = '1' or Clm2 = '1'))) then            --win 1
                    payout <= payout + "000000000001";
                    big_win <= big_win + "000000000101";
              end if;     
            payout_clk_cnt := 0;   
      
        elsif (payout_clk_cnt = 1999999) and payout > "000000001010" then
                payout_clk <= '1';                                                  --Payout clock
                payout_LED <= '1';                                                  --LED for payout
                payout <= payout - "000000000001";
                payout_clk_cnt := 0;                                                --Signals payout and countdown  
      
        elsif (payout_clk_cnt = 5999999) and payout > "000000000000" then
            payout_clk <= '1';                                                  --Payout clock
            payout_LED <= '1';                                                  --LED for payout
            payout <= payout - "000000000001";
            payout_clk_cnt := 0;                                                --Signals payout and countdown    
         end if;
  end if;
 

-- DISPLAY CODE     	
	if (reset = '1') then 
          seg_sel <= "0000001"; 
    elsif (rising_edge(fastClk)) then                               --Shift register for 7-seg displays
          seg_sel(1) <= seg_sel(0); seg_sel(2) <= seg_sel(1); 
          seg_sel(3) <= seg_sel(2); seg_sel(4) <= seg_sel(3); 
          seg_sel(5) <= seg_sel(4); seg_sel(6) <= seg_sel(5); 
          seg_sel(0) <= seg_sel(6);                                     
end if;
seg <= seg_sel;

 if (seg = "0000001") then 						            --Displays credits
	   if cred_data = 0 then disp <= "0111111";			    --Displays 0
    elsif cred_data = 1 then disp <= "0000110";			    --Displays 1
    elsif cred_data = 2 then disp <= "1011011"; 			--Displays 2 
    elsif cred_data = 3 then disp <= "1001111"; 			--Displays 3 
    elsif cred_data = 4 then disp <= "1100110"; 			--Displays 4 
    elsif cred_data = 5 then disp <= "1101101"; 			--Displays 5 
    elsif cred_data = 6 then disp <= "1111101"; 			--Displays 6 
    elsif cred_data = 7 then disp <= "0000111"; 			--Displays 7 
    elsif cred_data = 8 then disp <= "1111111";			    --Displays 8     
    elsif cred_data = 9 then disp <= "1101111"; 			--Displays 9
    end if;

elsif (seg = "0000010") then 						        --Displays 100s big win
	   if win_hundreds = "0000" then disp <= "0111111";		--Displays 0
    elsif win_hundreds = "0001" then disp <= "0000110";		--Displays 1
    elsif win_hundreds = "0010" then disp <= "1011011"; 	--Displays 2 
    elsif win_hundreds = "0011" then disp <= "1001111"; 	--Displays 3 
    elsif win_hundreds = "0100" then disp <= "1100110"; 	--Displays 4 
    elsif win_hundreds = "0101" then disp <= "1101101"; 	--Displays 5
    elsif win_hundreds = "0110" then disp <= "1111101"; 	--Displays 6
    elsif win_hundreds = "0111" then disp <= "0000111"; 	--Displays 7
    elsif win_hundreds = "1000" then disp <= "1111111";		--Displays 8
    elsif win_hundreds = "1001" then disp <= "1101111"; 	--Displays 9
   end if;

elsif (seg = "0000100") then 						    --Displays 10s big win
	   if win_tens = "0000" then disp <= "0111111";		--Displays 0
    elsif win_tens = "0001" then disp <= "0000110";		--Displays 1
    elsif win_tens = "0010" then disp <= "1011011";     --Displays 2 
    elsif win_tens = "0011" then disp <= "1001111"; 	--Displays 3 
    elsif win_tens = "0100" then disp <= "1100110"; 	--Displays 4 
    elsif win_tens = "0101" then disp <= "1101101"; 	--Displays 5 
    elsif win_tens = "0110" then disp <= "1111101"; 	--Displays 6 
    elsif win_tens = "0111" then disp <= "0000111"; 	--Displays 7 
    elsif win_tens = "1000" then disp <= "1111111";		--Displays 8     
    elsif win_tens = "1001" then disp <= "1101111"; 	--Displays 9
    end if;

elsif (seg = "0001000") then 						    --Displays 1s big win
	   if win_ones = "0000" then disp <= "0111111";		--Displays 0
    elsif win_ones = "0001" then disp <= "0000110";     --Displays 1
    elsif win_ones = "0010" then disp <= "1011011";     --Displays 2 
    elsif win_ones = "0011" then disp <= "1001111"; 	--Displays 3 
    elsif win_ones = "0100" then disp <= "1100110"; 	--Displays 4 
    elsif win_ones = "0101" then disp <= "1101101"; 	--Displays 5 
    elsif win_ones = "0110" then disp <= "1111101"; 	--Displays 6 
    elsif win_ones = "0111" then disp <= "0000111"; 	--Displays 7 
    elsif win_ones = "1000" then disp <= "1111111";		--Displays 8     
    elsif win_ones = "1001" then disp <= "1101111";     --Displays 9
    end if;

elsif (seg = "0010000") then 						            --Displays 100s tickets owed
       if payout_hundreds = "0000" then disp <= "0111111";		--Displays 0
    elsif payout_hundreds = "0001" then disp <= "0000110";		--Displays 1
    elsif payout_hundreds = "0010" then disp <= "1011011";		--Displays 2
    elsif payout_hundreds = "0011" then disp <= "1001111";		--Displays 3
    elsif payout_hundreds = "0100" then disp <= "1100110";		--Displays 4
    elsif payout_hundreds = "0101" then disp <= "1101101";		--Displays 5
    elsif payout_hundreds = "0110" then disp <= "1111101";		--Displays 6
    elsif payout_hundreds = "0111" then disp <= "0000111";		--Displays 7
    elsif payout_hundreds = "1000" then disp <= "1111111";		--Displays 8
    elsif payout_hundreds = "1001" then disp <= "1101111";		--Displays 9
    end if;

elsif (seg = "0100000") then					                --Displays 10s tickets owed
       if payout_tens = "0000" then disp <= "0111111";		    --Displays 0
    elsif payout_tens = "0001" then disp <= "0000110";		    --Displays 1
    elsif payout_tens = "0010" then disp <= "1011011";		    --Displays 2
    elsif payout_tens = "0011" then disp <= "1001111";	    	--Displays 3
    elsif payout_tens = "0100" then disp <= "1100110";		    --Displays 4
    elsif payout_tens = "0101" then disp <= "1101101";	        --Displays 5
    elsif payout_tens = "0110" then disp <= "1111101";		    --Displays 6
    elsif payout_tens = "0111" then disp <= "0000111";	        --Displays 7
    elsif payout_tens = "1000" then disp <= "1111111";		    --Displays 8
    elsif payout_tens = "1001" then disp <= "1101111";		    --Displays 9
    end if;

elsif (seg = "1000000") then  					                --Displays 1s tickets owed
       if payout_ones = "0000" then disp <= "0111111";	   	    --Displays 0
    elsif payout_ones = "0001" then disp <= "0000110";	        --Displays 1
    elsif payout_ones = "0010" then disp <= "1011011";		    --Displays 2
    elsif payout_ones = "0011" then disp <= "1001111";		    --Displays 3
    elsif payout_ones = "0100" then disp <= "1100110";		    --Displays 4
    elsif payout_ones = "0101" then disp <= "1101101";		    --Displays 5
    elsif payout_ones = "0110" then disp <= "1111101";		    --Displays 6
    elsif payout_ones = "0111" then disp <= "0000111";		    --Displays 7
    elsif payout_ones = "1000" then disp <= "1111111";		    --Displays 8
    elsif payout_ones = "1001" then disp <= "1101111";		    --Displays 9
    end if;
end if;

end process;


end Behavioral;
