library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_memory is 
generic( 
	address_bits : integer := 8; 
	word_width : integer := 16 ); 
port( 
	address 	: in std_logic_vector(address_bits-1 downto 0);
	instruction 	: out std_logic_vector(word_width-1 downto 0) ); 
	
end entity;


ARCHITECTURE Instruction_memory_arch OF Instruction_memory IS

TYPE Rom_type IS ARRAY(0 TO 2**address_bits) OF STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
SIGNAL memory: Rom_type := (
	0 => b"0000_001_001_001_101", -- R1 = R1 nand R1
	1 => b"0000_011_010_001_100", -- R3 = R1 xor R2
	2 => b"0000_011_010_001_010", -- NOP
	others => (others => '0') );

BEGIN 

instruction <= memory(to_integer(unsigned(address)));

END ARCHITECTURE;