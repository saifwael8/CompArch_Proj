library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data_Memory is 
port( 
	clk 		: in std_logic; 
	MR, MW 		: in std_logic; 
	Memory_Address: in std_logic_vector(11 downto 0);
	Data: in std_logic_vector(15 downto 0);
	From_Memory: out std_logic_vector(15 downto 0)
	);
	
end entity; 

ARCHITECTURE Data_Memory_arch OF Data_Memory IS

TYPE Ram_type IS ARRAY(0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL memory: Ram_type := (others => (others => '0'));

BEGIN

PROCESS(clk)
BEGIN

	IF rising_edge(clk) then
		IF (MW = '1') then
			memory(to_integer(unsigned(Memory_Address))) <= Data;
		END IF;
		END IF;
	IF (MR = '1') then
		From_Memory <= memory(to_integer(unsigned(Memory_Address)));
	END IF;
	
END PROCESS;

END Data_Memory_arch;