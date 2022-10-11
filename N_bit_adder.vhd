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


begin
AddOrSub: process(A,B,C_in)
variable a_sig, b_sig, s_sig, temp: signed(N-1 downto 0);
variable c : signed(N-1 downto 0) := (others => '0');
begin
    a_sig := signed(A);
    b_sig := signed(B);
    temp(0) := b_sig(0) xor c_in;
    s_sig(0) := (a_sig(0) xor temp(0)) xor C_in;
    c(0) := (a_sig(0) and (temp(0) or C_in)) or (C_in and temp(0));
    for i in 1 to (N - 1) loop
        temp(i) := b_sig(i) xor C_in;
        s_sig(i) := (a_sig(i) xor temp(i)) xor c(i-1);
        c(i) := (a_sig(i) and (temp(i) or c(i-1))) or (c(i-1) and temp(i)); 
    end loop; 
    S <= std_logic_vector(s_sig);
    C_out <= c(N-1);
    Overflow <= C(N-1) xor C(N-2);
end process AddOrSub;    
end Behavioral;
