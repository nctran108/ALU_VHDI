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

procedure adder (variable x,y: in signed(31 downto 0);
                 variable c_in: in std_logic;
                 variable c_out: out std_logic;
                 variable sum: out std_logic_vector(31 downto 0);
                 variable over: out std_logic) is
                 
                 variable temp : signed(31 downto 0);
                 variable c : signed(31 downto 0) := (others => '0');
                 begin

                    temp(0) := y(0) xor c_in;
                    sum(0) := (x(0) xor temp(0)) xor c_in;
                    c(0) := (x(0) and (temp(0) or c_in)) or (c_in and temp(0));
                    for i in 1 to 31 loop
                        temp(i) := y(i) xor c_in;
                        sum(i) := (x(i) xor temp(i)) xor c(i-1);
                        c(i) := (x(i) and (temp(i) or c(i-1))) or (c(i-1) and temp(i)); 
                    end loop; 
                    
                    c_out := c(31);
                    over := C(30) xor C(31);            
    end adder; 

begin   

mux: process(ALUctr,busA,busB)
variable rs: integer := 0;
variable output : std_logic_vector(31 downto 0);
variable is_overflow, Cin, Cout : std_logic := '0';
variable a_sig, b_sig, temp: signed(31 downto 0);
variable c : signed(31 downto 0) := (others => '0');
variable multiplier, multiplicand : std_logic_vector(31 downto 0);
variable product : std_logic_vector(63 downto 0) := (others => '0');
begin
    case ALUctr is
    when "0000" => --addition
        a_sig := signed(busA);
        b_sig := signed(busB);
        adder(a_sig,b_sig,Cin,Cout,output,is_overflow);
        Carryout <= Cout;
        Zero <= checkZero(output);
    when "0001" => --subtraction
        a_sig := signed(busA);
        b_sig := signed(busB);
        Cin := '1';
        adder(a_sig,b_sig,Cin,Cout,output,is_overflow);
        Zero <= checkZero(output);
        Carryout <= Cout;
    when "0010" => --Bitwise AND
        output := busA and busB;
        Zero <= checkZero(output);
        Carryout <= '0';
    when "0011" => --Bitwise OR
        output := busA or busB;
        Zero <= checkZero(output);
        Carryout <= '0';
    when "0100" => --Logical left shift
        output := busB;
        rs := to_integer(signed(busA));
        if rs <= 0 or rs >= 32 then
            rs := 0;
        else
            rs := rs;
            end if;
        for i in 1 to rs loop
            output(31 downto 0) := output(30 downto 0) & '0';
            end loop;
        Zero <= checkZero(output);
        Carryout <= '0';
    when "0101" => --Logical right shift
        output := busB;
        rs := to_integer(signed(busA));
        if rs < 1 or rs >= 32 then
            rs := 0;
        else
            rs := rs;
            end if;
        for i in 1 to rs loop
            output(31 downto 0) := '0' & output(31 downto 1);
            end loop;
        Zero <= checkZero(output);
        Carryout <= '0';
    when "0110" => --Arithmetic left shift
        output := busB;
        rs := to_integer(signed(busA));
        if rs < 1 or rs >= 32 then
            rs := 0;
        else
            rs := rs;
            end if;
        for i in 1 to rs loop
            output(31 downto 0) := output(30 downto 0) & '0';
            end loop;
        Zero <= checkZero(output);
        Carryout <= '0';
    when "0111" => --Arithmetic right shift
        output := busB;
        rs := to_integer(signed(busA));
        if rs < 1 or rs >= 32 then
            rs := 0;
        else
            rs := rs;
            end if;
        for i in 1 to rs loop
            output(31 downto 0) := output(31) & output(31 downto 1);
            end loop;
        Zero <= checkZero(output);
        Carryout <= '0';
    when "1000" => --Multiplier
        multiplier := busA;
        multiplicand := busB;
        Cin := '0';
        product := (others => '0');
        for i in 0 to 31 loop
            if multiplier(0) = '1' then
                adder(signed(multiplicand),signed(product(63 downto 32)),Cin,Cout,product(63 downto 32),is_overflow);
                end if;
            multiplier := '0' & multiplier(31 downto 1);
            product := '0' & product(63 downto 1);
            end loop;
        output := product(31 downto 0);
        Zero <= checkZero(output);
        Carryout <= '0';
        if to_integer(signed(product)) /= to_integer(signed(output)) then
            is_overflow := '1';
        else
            is_overflow := '0';
            end if;
    when others => --other cases
        output := (others => '0');   
        Zero <= '0';
        Carryout <= '0';
    end case;
    Result <= output;
    Overflow <= is_overflow;
    end process mux;

end Behavioral;
