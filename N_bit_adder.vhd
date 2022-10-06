library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity N_bit_adder is
    generic(N: integer := 8);
    Port (A,B : in std_logic_vector (N-1 downto 0);
          C_in: in std_logic;
          C_out: out std_logic;
          Overflow: out std_logic;
          S: out std_logic_vector (N-1 downto 0));
end N_bit_adder;

architecture Behavioral of N_bit_adder is

signal c, temp: std_logic_vector (N-1 downto 0);

begin
AddOrSub: process(A,B,C_in,c,temp)
begin
    temp(0) <= B(0) xor C_in;
    S(0) <= (A(0) xor temp(0)) xor C_in;
    c(0) <= (A(0) and (temp(0) or C_in)) or (C_in and temp(0));
    for i in 1 to (N - 1) loop
        temp(i) <= B(i) xor C_in;
        S(i) <= (A(i) xor temp(i)) xor c(i-1);
        c(i) <= (A(i) and (temp(i) or c(i-1))) or (c(i-1) and temp(i)); 
    end loop; 
    C_out <= c(31);
    Overflow <= C(31) xor C(30);
end process AddOrSub;    
end Behavioral;
