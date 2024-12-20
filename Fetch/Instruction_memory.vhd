library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_memory is 
generic( 
	address_bits : integer := 12; 
	word_width : integer := 16 ); 
port(
	--inputs 
	address 	: in std_logic_vector(address_bits-1 downto 0);
	--outputs
	instruction : out std_logic_vector(word_width-1 downto 0); 
	immediate 	: out std_logic_vector(word_width-1 downto 0);
	IM_3 		: out std_logic_vector(word_width-1 downto 0)
	); 
end entity;


ARCHITECTURE Instruction_memory_arch OF Instruction_memory IS

TYPE Rom_type IS ARRAY(0 TO 2**address_bits) OF STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
SIGNAL memory: Rom_type := (
	others => (others => '0') );
BEGIN 

instruction <= memory(to_integer(unsigned(address)));
immediate <= memory(to_integer(unsigned(address))+1);
IM_3 <= memory(3);

END ARCHITECTURE;