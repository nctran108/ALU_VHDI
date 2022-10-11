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
type mips_register_type is array (0 to 31) of std_logic_vector(31 downto 0);
signal register_array : mips_register_type := ( x"00000000", -- $zero
                                                x"00000001", -- $at
                                                x"00000010", -- $v0
                                                x"00000004", -- $v1
                                                x"0000007f", -- $a0
                                                x"00000101", -- $a1
                                                x"00000002", -- $a2
                                                x"00000003", -- $a3
                                                x"00000400", -- $t0
                                                x"ffffffff", -- $t1
                                                x"7fffffff", -- $t2
                                                x"0fffffff", -- $t3
                                                x"10011101", -- $t4
                                                x"00000005", -- $t5
                                                x"00000006", -- $t6
                                                x"ffffff50", -- $t7
                                                x"fffffff2", -- $s0
                                                x"fffffff8", -- $s1
                                                x"efffffff", -- $s2
                                                x"ffffff20", -- $s3
                                                x"00000100", -- $s4
                                                x"00000011", -- $s5
                                                x"000000ff", -- $s6
                                                x"0000007f", -- $s7
                                                x"000007ff", -- $t8
                                                x"f0000000", -- $t9
                                                x"22222222", -- $k0
                                                x"33333333", -- $k1
                                                x"44444444", -- $gp
                                                x"aaaaaaaa", -- $sp
                                                x"eeeeeeee", -- $fp
                                                x"12345678");-- $ra

begin
       
    process(clk,RegWr)
    begin
        if falling_edge(clk) then
            if RegWr = '1' then
                register_array(to_integer(unsigned(Rd))) <= busW;
                end if;
            end if;     
    end process;
    
    process(Rd,Rs,Rt)
    begin
        busA <= register_array(to_integer(unsigned(Rs)));
        busB <= register_array(to_integer(unsigned(Rt)));
    end process;

end Behavioral;
