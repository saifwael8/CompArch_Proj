library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is 

port(
	--inputs
	clk 		: in std_logic;  
	mux_entry 	: in std_logic_vector(15 downto 0);
	--outputs
	address 	: out std_logic_vector(15 downto 0) 
	); 
end entity; 

ARCHITECTURE PC_arch OF PC IS
signal PC_current : std_logic_vector(15 downto 0) := (Others => '0');
BEGIN

PROCESS(clk, mux_entry)
BEGIN

	IF (rising_edge(clk)) then
		PC_current <= mux_entry;
	END IF;
	
END PROCESS;
address <= PC_current;
END PC_arch;

