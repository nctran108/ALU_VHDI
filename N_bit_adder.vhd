library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity N_bit_adder is
    generic(N: integer := 8);
    Port (A,B : in std_logic_vector (N-1 downto 0);
          C_in: in std_logic;
          C_out: out std_logic;
          S: out std_logic_vector (N-1 downto 0));
end N_bit_adder;

architecture Behavioral of N_bit_adder is
constant MAX_DELAY: time := 14 ns;
signal c: std_logic_vector (N-1 downto 0);
begin
Add : process(A,B,C_in,c)
    begin
        S(0) <= A(0) XOR C_in after MAX_DELAY;
        c(0) <= (A(0) AND C_in) OR (B(0) AND C_in) OR (A(0) AND B(0)) after MAX_DELAY;
        
        for i in 1 to (S'length - 1) loop
            S(i) <= A(i) XOR B(i) XOR c(i-1) after MAX_DELAY;
            c(i) <= (A(i) AND c(i-1)) OR (B(i) AND c(i-1)) OR (A(i) AND B(i)) after MAX_DELAY;
        end loop;
        C_out <= c(N-1);
    end process Add;
    
end Behavioral;
