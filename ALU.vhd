library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (busA, busB    : in    std_logic_vector(31 downto 0); --busA = rs and busB = rt
          ALUctr        : in    std_logic_vector(3 downto 0);
          Zero          : out   std_logic;
          Overflow      : out   std_logic;
          Carryout      : out   std_logic;
          Result        : out   std_logic_vector(31 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
function checkZero (a: std_logic_vector(31 downto 0)) return std_logic is
begin
    if a = x"00000000" then
        return '1';
    else
        return '0';
    end if;
end checkZero;

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
variable rs : integer := 0;
variable output : std_logic_vector(31 downto 0);
begin
    case ALUctr is
    when "0000" => --addition
        output := sumResult;
        Zero <= checkZero(output);
        Carryout <= c_out;
        Overflow <= is_overflow;
    when "0001" => --subtraction
        output := subResult;
        Zero <= checkZero(output);
        Carryout <= c_out1;
        Overflow <= is_overflow;
    when "0010" => --Bitwise AND
        output := busA and busB;
        Zero <= checkZero(output);
        Carryout <= '0';
        Overflow <= '0';
    when "0011" => --Bitwise OR
        output := busA or busB;
        Zero <= checkZero(output);
        Carryout <= '0';
        Overflow <= '0';
    when "0100" => --Logical left shift
        output := busB;
        rs := to_integer(signed(busA));
        if rs <= 0 or rs >= 5 then
            rs := 0;
        else
            rs := rs;
            end if;
        for i in 1 to rs loop
            output(31 downto 0) := output(30 downto 0) & '0';
            end loop;
        Zero <= checkZero(output);
        Carryout <= '0';
        Overflow <= '0';
    when "0101" => --Logical right shift
        output := busB;
        rs := to_integer(signed(busA));
        if rs < 1 or rs >= 5 then
            rs := 0;
        else
            rs := rs;
            end if;
        for i in 1 to rs loop
            output(31 downto 0) := '0' & output(31 downto 1);
            end loop;
        Zero <= checkZero(output);
        Carryout <= '0';
        Overflow <= '0';
    when "0110" => --Arithmetic left shift
        output := busB;
        rs := to_integer(signed(busA));
        if rs < 1 or rs >= 5 then
            rs := 0;
        else
            rs := rs;
            end if;
        for i in 1 to rs loop
            output(31 downto 0) := output(30 downto 0) & '0';
            end loop;
        Zero <= checkZero(output);
        Carryout <= '0';
        Overflow <= '0';
    when "0111" => --Arithmetic right shift
        output := busB;
        rs := to_integer(signed(busA));
        if rs < 1 or rs >= 5 then
            rs := 0;
        else
            rs := rs;
            end if;
        for i in 1 to rs loop
            output(31 downto 0) := output(31) & output(31 downto 1);
            end loop;
        Zero <= checkZero(output);
        Carryout <= '0';
        Overflow <= '0';
    when "1000" => --Multiplier
    when others => --other cases
        output := (others => '0');   
        Zero <= '0';
        Carryout <= '0';
        Overflow <= '0';
    end case;
    Result <= output;
    end process mux;

end Behavioral;
