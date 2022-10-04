library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Registers is
    Port (RegWr, clk: in     STD_LOGIC;
          Rd, Rs, Rt: in     std_logic_vector(4 downto 0);
          busW      : in     std_logic_vector(31 downto 0);
          busA, busB: out    std_logic_vector(31 downto 0));
end Registers;

architecture Behavioral of Registers is

begin
    process(RegWr,clk)
    begin
    
    end process;

end Behavioral;
