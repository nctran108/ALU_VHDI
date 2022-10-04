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
--constant MAX_DELAY: time := 14 ns;
signal c: std_logic_vector (N-1 downto 0);
begin
Add : process(A,B,C_in,c)
    begin
        S(0) <= (A(0) XOR B(0)) XOR C_in;
        c(0) <= (A(0) AND (B(0)or C_in)) OR (B(0) AND C_in);
        
        for i in 1 to (S'length - 1) loop
            S(i) <= (A(i) XOR B(i)) XOR c(i-1);
            c(i) <= (A(i) AND (B(i)or C(i-1))) OR (B(i) AND C(i-1));
        end loop;
        C_out <= c(N-1);
        Overflow <= c(N-1) xor c(N-2);
    end process Add;
    
end Behavioral;
