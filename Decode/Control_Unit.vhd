library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Control_Unit IS
port( 	Opcode : in std_logic_vector(4 downto 0);
		ALU_selector: out std_logic_vector(3 downto 0);
		write_enable: out std_logic);
end entity;


architecture controller_arch of Controller IS

begin

write_enable <= data_in(2);
ALU_selector <= '0'  & data_in;

end architecture;