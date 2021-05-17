library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ComboLock is
    Port ( V10, U8, T8, J15 : in STD_LOGIC; --Correct inputs
           U11, U12, H6, T13, R16, R13, U18, T18, R17, R15, M13, L16 : in STD_LOGIC; --Incorrect Inputs
           S0, S1, S2, S3, S4, S5, S6, S7 : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           LED1g, LED2g, LED1r, LED2r, LED1b, LED2b : out STD_LOGIC); 
          signal Res, St1, St2, St3: STD_LOGIC; 
          signal ResIn : STD_LOGIC; --Input pin to NOR reset gate
          signal Vcc : STD_LOGIC; --Constant 1 input
          signal Gnd : STD_LOGIC; --Constant 0 input
          signal St4  : STD_LOGIC;  --Unlocks the thing
          
end ComboLock;

architecture Behavioral of ComboLock is

begin
    Vcc <= '1'; Gnd <= '0';
    LED1g <= St4; LED2g <= St4;
    LED1r <= not St4; LED2r <= not St4;
    LED1b <= not Res; LED2b <= not Res;
    ResIn <= U11 or U12 or H6 or T13 or R16 or R13 or U18 or T18 or R17 or R15 or M13 or L16;
    Res <= ResIn nor Gnd;
    St1 <= Res and V10;
    St2 <= St1 and U8;
    St3 <= St2 and T8;
    St4 <= St3 and J15;
    AN <= "11111110";
    S7 <= '1';
    S6 <= '1';
    S5 <= '0';
    S4 <= '0';
    S3 <= '0';
    S2 <= not St4;
    S1 <= not St4;
    S0 <= not St4;
    

end Behavioral;
