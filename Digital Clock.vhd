library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clock is
    Port (sysClk : in STD_LOGIC; --100MHZ clock
          clk1hz : inout STD_LOGIC; --1HZ clock
          dispClk : inout STD_LOGIC; --400hz clock
          Dsp: out STD_LOGIC_VECTOR (7 downto 0); --7seg display
          set : in STD_LOGIC;
          passbit : out STD_LOGIC;
          clkps : inout STD_LOGIC;
          Tset, TsetT : inout STD_LOGIC;
          ANoff : out STD_LOGIC_VECTOR (1 downto 0); --turns off one side of the 7seg displays
          AN : inout STD_LOGIC_VECTOR (5 downto 0)); --turns on one side of the 7seg displays
             
          signal op1, op2, op3, op4, op5, op6 : STD_LOGIC; --debounce for switch **Does not work**
          signal Vcc, Gnd : STD_LOGIC; --Constant 1,0 input

          signal disp :std_logic_vector (5 downto 0); -- 7 segment display
end clock;

architecture Behavioral of clock is

begin

    ANoff <= "11";
    Vcc <= '1'; Gnd <= '0';

	
	process (sysClk)
		variable dispCnt: integer range 0 to 250000 := 0; -- Turns 100MHZ to 400HZ
        variable mscnt:	integer range 0 to 399 := 0; -- Turns 400HZ to 1HZ
        variable counter_second:integer range 0 to 10 := 0;
        variable counter_Tsecond:integer range 0 to 6 := 3;
        variable counter_minute:integer range 0 to 10 := 9;
        variable counter_Tminute:integer range 0 to 6 := 5;
        variable counter_hour:integer range 0 to 10 := 3;
        variable counter_Thour:integer range 0 to 3 := 2;
        variable counter_dp:integer range 0 to 2 := 0;
	begin
		if(sysClk'event and sysClk='1') then 		
            dispCnt:=dispCnt+1;
            
			--generates dispClk
			--if clkps = '1' then
			--dispClk <= '1';	
			if (dispCnt=125000) then	 
				dispClk<='1';
			elsif (dispCnt=250000) then
				dispClk <= '0'; 
	            msCnt:= msCnt + 1;

			--generates clk1hz	
            if clkps = '1' then --pauses 1hz clock
                clk1hz<='1';
            elsif (mscnt=199) then --half of 1s     
                clk1hz<='1'; 
            elsif (mscnt=399) then --1s
                clk1hz <= '0';
                mscnt:=0;
   
end if; end if; end if;

if (rising_edge(clk1hz)) then
 counter_second:=counter_second + 1;

 if(counter_second >=10) then 
 counter_Tsecond:=counter_Tsecond + 1;
 counter_second:=0;
 if(counter_Tsecond >=6) then 
 counter_minute:=counter_minute + 1;
 counter_Tsecond:=0;
 
 if(counter_minute >=10) then
 counter_Tminute:=counter_Tminute + 1;
 counter_minute:=0;
 if(counter_Tminute >=6) then
 counter_hour:=counter_hour + 1;
 counter_Tminute:=0;

 if(counter_hour >=10) then
 counter_Thour:=counter_Thour + 1; 
 counter_hour:=0;


 end if; end if; end if; end if; end if; end if;

 if( counter_hour = 4 and counter_Thour = 2) then 
 counter_hour:=0;
 counter_Thour:=0;
 
 end if;
 
 if rising_edge (dispClk) then
 
 op1 <= Tset; op2 <= op1; op3 <= op2; op4 <= op3; op5 <= op4; op6 <= op5;
 
 end if;
 
 TsetT <= op1 and op2 and op3 and op4 and op5 and op6;
 
 --if (TsetT ='1') then 
 --counter_second:=counter_second+1;
 --end if;
 
 
	if (set = '1') then 
          disp <= "111110";
                  
    elsif (rising_edge(dispClk)) then 
          disp(5) <= disp(4); disp(4) <= disp(3);
          disp(3) <= disp(2); disp(2) <= disp(1); 
          disp(1) <= disp(0); disp(0) <= disp(5);                                     
end if;
AN <= disp;

if (AN = "111110") then     
       if counter_second = 0 then Dsp <= "11000000";
       elsif counter_second = 1 then Dsp <= "11111001";                
       elsif counter_second = 2 then Dsp <= "10100100";
       elsif counter_second = 3 then Dsp <= "10110000";
       elsif counter_second = 4 then Dsp <= "10011001";
       elsif counter_second = 5 then Dsp <= "10010010";
       elsif counter_second = 6 then Dsp <= "10000010";
       elsif counter_second = 7 then Dsp <= "11111000";
       elsif counter_second = 8 then Dsp <= "10000000";
       elsif counter_second = 9 then Dsp <= "10010000";
    end if;
elsif (AN = "111101") then     
       if counter_Tsecond = 0 then Dsp <= "11000000";
       elsif counter_Tsecond = 1 then Dsp <= "11111001";                
       elsif counter_Tsecond = 2 then Dsp <= "10100100";
       elsif counter_Tsecond = 3 then Dsp <= "10110000";
       elsif counter_Tsecond = 4 then Dsp <= "10011001";
       elsif counter_Tsecond = 5 then Dsp <= "10010010";
   end if; 
elsif (AN = "111011") then     
          if counter_minute = 0 then Dsp <= "11000000";
       elsif counter_minute = 1 then Dsp <= "11111001";                
       elsif counter_minute = 2 then Dsp <= "10100100";
       elsif counter_minute = 3 then Dsp <= "10110000";
       elsif counter_minute = 4 then Dsp <= "10011001";
       elsif counter_minute = 5 then Dsp <= "10010010";
       elsif counter_minute = 6 then Dsp <= "10000010";
       elsif counter_minute = 7 then Dsp <= "11111000";
       elsif counter_minute = 8 then Dsp <= "10000000";
       elsif counter_minute = 9 then Dsp <= "10010000";
       end if;   
elsif (AN = "110111") then     
       if counter_Tminute = 0 then Dsp <= "11000000";
       elsif counter_Tminute = 1 then Dsp <= "11111001";                
       elsif counter_Tminute = 2 then Dsp <= "10100100";
       elsif counter_Tminute = 3 then Dsp <= "10110000";
       elsif counter_Tminute = 4 then Dsp <= "10011001";
       elsif counter_Tminute = 5 then Dsp <= "10010010";
       end if;
elsif (AN = "101111") then     
       if counter_hour = 0 then Dsp <= "11000000";
       elsif counter_hour = 1 then Dsp <= "11111001";                
       elsif counter_hour = 2 then Dsp <= "10100100";
       elsif counter_hour = 3 then Dsp <= "10110000";
       elsif counter_hour = 4 then Dsp <= "10011001";
       elsif counter_hour = 5 then Dsp <= "10010010";
       elsif counter_hour = 6 then Dsp <= "10000010";
       elsif counter_hour = 7 then Dsp <= "11111000";
       elsif counter_hour = 8 then Dsp <= "10000000";
       elsif counter_hour = 9 then Dsp <= "10010000";
       end if;
elsif (AN = "011111") then     
       if counter_Thour = 0 then Dsp <= "11000000";
       elsif counter_Thour = 1 then Dsp <= "11111001";                
       elsif counter_Thour = 2 then Dsp <= "10100100";                
       end if;
end if;

        end process;

end Behavioral;
