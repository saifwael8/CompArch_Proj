library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Control_Unit IS
port( 	Opcode : in std_logic_vector(4 downto 0);
		PC_src: in std_logic;
		Control_Bus: out std_logic_vector(23 downto 0);
		Flush_br : out std_logic
		);
end entity;


architecture controller_arch of Control_Unit IS

begin

	Flush_br <= PC_src;
	
	with Opcode select
	Control_Bus <=

		(others => '0') when "00000",
		(others => '0') when "00001",
		(11 => '1', 9 => '1', others => '0') when "00010" ,
		"100001111001010100000000" when "00011" ,
		"100000001011110100000000" when "00100" ,
		"100000001000000000000000" when "00101"  ,
		"100001011001010100000000" when "00110"  ,
		"100000011001110100000000" when "00111"  ,
		"100000101011110100000000" when "01000"  ,
		"100100011001110100000000" when "01001"  ,
		"010100010000000000000000" when "01010"  ,
		"101100010000000000000000" when "01011"  ,
		"100111001000000000000000" when "01100"  ,
		(7 => '1', others => '0') when "01101"  ,
		(23 => '1', 15 => '1', 6 => '1', others => '0') when "01110"  ,
		(22 => '1', 5 => '1', others => '0') when "01111"  ,
		"101000000000000000110000" when "10000"  ,
		"000000001101000000000000" when "10001"  ,
		"000000001100010000000010" when "10010"  ,
		"000000001100100000000100" when "10011"  ,
		"000000001100000000000110" when "10100"  ,
		"010000001100000000101110" when "10101"  ,
		"010000000000000000101000" when "10110"  ,
		"001000000100000000110110" when "10111"  ,
		"001000000100000000110111" when "11000",
		(others => '0') when others;


end Architecture;