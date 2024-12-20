library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_Mux is 
generic(  
	word_width : integer := 8 ); 
port(
	--inputs
	clk 		: in std_logic;  
	mux_entry 	: in std_logic_vector(word_width-1 downto 0);
	--outputs
	address 	: out std_logic_vector(word_width-1 downto 0) 
	); 
end entity;

ARCHITECTURE PC_Mux_arch OF PC_Mux IS
BEGIN
end architecture;