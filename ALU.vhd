library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (busA, busB    : in    std_logic_vector(31 downto 0);
          ALUctr        : in    std_logic_vector(3 downto 0);
          Zero          : out   std_logic;
          Overflow      : out   std_logic;
          Carryout      : out   std_logic;
          Result        : inout   std_logic_vector(31 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
signal sumResult, subResult : std_logic_vector(31 downto 0);
signal c_in, c_out, is_zero,c_in1, c_out1,is_overflow: std_logic := '0';

begin   
c_in1 <= '1';
adder: entity work.N_bit_adder(Behavioral)
    generic map(32)
    port map (A => busA,
              B => busB,
              C_in => c_in,
              C_out => c_out,
              Overflow => is_overflow,
              S => sumResult);

subtracter: entity work.N_bit_adder(Behavioral)
    generic map(32)
    port map (A => busA,
              B => busB,
              C_in => c_in1,
              C_out => c_out1,
              Overflow => is_overflow,
              S => subResult);

mux: process(ALUctr,busA,busB)
begin
    case ALUctr is
    when "0000" => --addition
        Result <= sumResult;
        Zero <= is_zero;
        Carryout <= is_overflow;
        Overflow <= '0';
    when "0001" => --subtraction
        Result <= subResult;
        Zero <= is_zero;
        Carryout <= c_out1;
        Overflow <= is_overflow;
    when "0010" => --Bitwise AND
        Result <= busA and busB;
        Zero <= is_zero;
        Carryout <= '0';
        Overflow <= '0';
    when "0011" => --Bitwise OR
        Result <= busA or busB;
        Zero <= is_zero;
        Carryout <= '0';
        Overflow <= '0';
    when "0100" => --Logical left shift
    when "0101" => --Logical right shift
    when "0110" => --Arithmetic left shift
    when "0111" => --Arithmetic right shift
    when "1000" => --Multiplier
    when others => --other cases
        Result <= (others => '0');   
        Zero <= '0';
        Carryout <= '0';
        Overflow <= '0';
    end case;
    end process mux;

count: process(Result)
variable count: integer := 0;
begin
    if Result = x"00000000" then
        is_zero <= '1';
    else
        is_zero <= '0';
    end if;
    end process count;
end Behavioral;
