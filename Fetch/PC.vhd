library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is 
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

ARCHITECTURE PC_arch OF PC IS
BEGIN

PROCESS(clk)
BEGIN

	IF (rising_edge(clk)) then
		address <= mux_entry;
	END IF;
	
END PROCESS;

END PC_arch;

