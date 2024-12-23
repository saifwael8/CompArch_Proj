library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_memory is 
port(
	--inputs 
	address 	: in std_logic_vector(11 downto 0);
	add3_index : in std_logic_vector(11 downto 0);
	--outputs
	instruction : out std_logic_vector(15 downto 0); 
	immediate 	: out std_logic_vector(15 downto 0);
	IM_3 		: out std_logic_vector(15 downto 0);
	IM_3_index  : out std_logic_vector(15 downto 0)
	); 
end entity;


ARCHITECTURE Instruction_memory_arch OF Instruction_memory IS

TYPE Rom_type IS ARRAY(0 TO 2**12-1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL memory: Rom_type := (
	others => (others => '0') );
BEGIN 

instruction <= memory(to_integer(unsigned(address)));
immediate <= memory(to_integer(unsigned(address))+1);
IM_3 <= memory(3);
IM_3_index <= memory(to_integer(unsigned(add3_index)));

END ARCHITECTURE;