library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (busA, busB    : in    std_logic_vector(31 downto 0);
          ALUctr        : in    std_logic_vector(3 downto 0);
          Zero          : out   std_logic;
          Overflow      : out   std_logic;
          Carryout      : out   std_logic;
          Result        : out   std_logic_vector(31 downto 0)
    );
end ALU;

architecture Behavioral of ALU is

signal c_in, c_out : std_logic := '0';

component N_bit_adder
    generic(N: integer := 32);
    Port (A,B : in std_logic_vector (N-1 downto 0);
          C_in: in std_logic;
          C_out: out std_logic;
          S: out std_logic_vector (N-1 downto 0));
    end component;
begin   

addition: if ALUctr = "0000" generate
    adder: N_bit_adder port map (busA,busB,c_in,c_out,Result);
    end generate addition;

subtraction: if ALUctr = "0001" generate
-- component
    end generate subtraction;

Bitwise_AND: if ALUctr = "0010" generate
-- component
    end generate Bitwise_AND;

Bitwise_OR: if ALUctr = "0011" generate
-- component
    end generate Bitwise_OR;

Logical_left_shift: if ALUctr = "0100" generate
-- component
    end generate Logical_left_shift;

Logical_right_shift: if ALUctr = "0101" generate
-- component
    end generate Logical_right_shift;

Arithmetic_left_shift: if ALUctr = "0110" generate
-- component
    end generate Arithmetic_left_shift;

Arithmetic_right_shift: if ALUctr = "0111" generate
-- component
    end generate Arithmetic_right_shift;

Multiplier: if ALUctr = "1000" generate
-- component
    end generate Multiplier;
end Behavioral;
