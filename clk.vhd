library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk is
    Port ( sysClk : in STD_LOGIC; --100MHZ clock
		   msClk :	out STD_LOGIC; --10kHZ clock
           clk1hz : inout STD_LOGIC; --1HZ clock
           Dsp: out STD_LOGIC_VECTOR (7 downto 0); --7seg display
           set : in STD_LOGIC;
           ANoff : out STD_LOGIC_VECTOR (3 downto 0); --turns off one side of the 7seg displays
           AN : out STD_LOGIC_VECTOR (3 downto 0)); --turns on one side of the 7seg displays
     signal Vcc : STD_LOGIC; --Constant 1 input
     signal Gnd : STD_LOGIC; --Constant 0 input
     signal oneMin0, oneMin1, oneMin2, oneMin3, oneMin4, oneMin5, oneMin6, oneMin7, oneMin8, oneMin9 : STD_LOGIC;
     signal tenSec0, tenSec1, tenSec2, tenSec3, tenSec4, tenSec5 : STD_LOGIC;
     signal oneSec0, oneSec1, oneSec2, oneSec3, oneSec4, oneSec5, oneSec6, oneSec7, oneSec8, oneSec9 : STD_LOGIC;
end clk;

architecture Behavioral of clk is 
begin 

    ANoff <= "1111";
    Vcc <= '1'; Gnd <= '0';
	
	process (sysClk)
		variable cnt: integer range 0 to 10000 := 0; -- Turns 100MHZ to 10kHZ
		variable mscnt:	integer range 0 to 100 := 0; -- Turns 10kHZ to 100HZ
	begin
		if(sysClk'event and sysClk='1')then 
		
			cnt:=cnt+1;		
 		     
			--generates msClk	
			if (cnt=5000) then --half of 100us	 
				msClk<='1'; 
			elsif (cnt=10000) then --100us
				msClk <= '0'; 
				cnt:= 0;
				msCnt:= msCnt + 1;

if (msCnt = 100) then --Reset
	  msCnt := 0; 
elsif (msCnt < 100 and msCnt > 76) then 
      AN <= "1110";
elsif (msCnt < 75 and msCnt > 51) then         
      AN <= "1101";
elsif (msCnt < 50 and msCnt > 26) then         
      AN <= "1011"; 
elsif (msCnt < 25 and msCnt > 0) then         
      AN <= "0111";  

end if; end if; end if;

if set = '1' then oneMin0 <= '1'; oneMin1 <= '0'; oneMin2 <= '0'; oneMin3 <= '0'; 
   oneMin4 <= '0'; oneMin5 <= '0'; oneMin6 <= '0'; oneMin7 <= '0'; oneMin8 <= '0'; 
   oneMin9 <= '0';        
elsif tenSec0 = '1' then oneMin9 <= oneMin8; oneMin8 <= oneMin7; oneMin7 <= oneMin6; 
      oneMin6 <= oneMin5; oneMin5 <= oneMin4; oneMin4 <= oneMin3;
      oneMin3 <= oneMin2; oneMin2 <= oneMin1; oneMin1 <= oneMin0; oneMin0 <= oneMin9;
end if;        
if set = '1' then tenSec0 <= '1'; tenSec1 <= '0'; tenSec2 <= '0'; tenSec3 <= '0'; 
                  tenSec4 <= '0'; tenSec5 <= '0';  
elsif oneSec0 = '1' then tenSec5 <= tenSec4; tenSec4 <= tenSec3;
      tenSec3 <= tenSec2; tenSec2 <= tenSec1; tenSec1 <= tenSec0; tenSec0 <= tenSec5;            
end if;        
if set = '1' then oneSec0 <= '1'; oneSec1 <= '0'; oneSec2 <= '0'; oneSec3 <= '0'; 
   oneSec4 <= '0'; oneSec5 <= '0'; oneSec6 <= '0'; oneSec7 <= '0'; oneSec8 <= '0'; oneSec9 <= '0';        
elsif rising_edge(clk1hz) then oneSec9 <= oneSec8; oneSec8 <= oneSec7; oneSec7 <= oneSec6; oneSec6 <= oneSec5; oneSec5 <= oneSec4; oneSec4 <= oneSec3;
   oneSec3 <= oneSec2; oneSec2 <= oneSec1; oneSec1 <= oneSec0; oneSec0 <= oneSec9;
         end if;  
	end process; 	
	
end Behavioral;

