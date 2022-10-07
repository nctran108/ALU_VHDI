library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity top_level is
    Port ( 
           clk         : in		STD_LOGIC;
           RegWr       : in	    STD_LOGIC;
           Rd          : in 	std_logic_vector(4 downto 0);
           Rs          : in 	std_logic_vector(4 downto 0);
           Rt          : in 	std_logic_vector(4 downto 0);
           ALUctr      : in     std_logic_vector(3 downto 0);
           Zero	       : out	STD_LOGIC;
           Overflow    : out	STD_LOGIC;
           Carryout    : out    STD_LOGIC;
           Result      : out    std_logic_vector(31 downto 0)
           );
           
end top_level;

architecture simple of top_level is
    signal busA_sig, busB_sig : std_logic_vector(31 downto 0);
    signal Result_sig : std_logic_vector(31 downto 0);
------------------------------------------------------------------------
-- Implementation
------------------------------------------------------------------------
	begin
	
	Registers: entity work.Registers(Behavioral)
	        port map(RegWr => RegWr,
	                 clk => clk,
	                 Rd => Rd,
	                 Rs => Rs,
	                 Rt => Rt,
	                 busW => Result_sig,
	                 busA => busA_sig,
	                 busB => busB_sig
	                 );
    ALU:    entity work.ALU(Behavioral)
            port map(busA => busA_sig,
                     busB => busB_sig,
                     ALUctr => ALUctr,
                     Zero => Zero,
                     Overflow => Overflow,
                     Carryout => Carryout,
                     Result => Result_sig
            );   
    Result <= Result_sig;
end simple;