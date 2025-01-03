library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SP is 
port( 
	clk 		: in std_logic; 
	SP_enable: in std_logic; 
	SInc     : in std_logic;
	SP_address_out 	: out std_logic_vector(15 downto 0)); 
	
end entity; 

ARCHITECTURE SP_arch OF SP IS

signal SP_current : std_logic_vector(15 downto 0) := "0000111111111111";

BEGIN

PROCESS(clk)
BEGIN

	IF (rising_edge(clk)) then
		IF (SP_enable = '1') then
			IF (SInc = '1') then
				SP_current <= std_logic_vector(unsigned(SP_current)+1);
			ELSE SP_current <= std_logic_vector(unsigned(SP_current)-1);
			END IF;
		END IF;
	END IF;
	
END PROCESS;
SP_address_out <= SP_current;
END SP_arch;
