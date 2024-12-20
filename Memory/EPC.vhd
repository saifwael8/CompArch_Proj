library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EPC is 
port( 
	clk, Save_EPC 		: in std_logic; 
	PC_plus_1: in std_logic_vector(15 downto 0);
	EPC_out 	: out std_logic_vector(15 downto 0)); 
	
end entity; 

ARCHITECTURE EPC_arch OF EPC IS

signal EPC_current : std_logic_vector(15 downto 0) := (others => '0');

BEGIN

PROCESS(clk)
BEGIN

	IF (rising_edge(clk)) then
		IF Save_EPC = '1' then
			EPC_current <= std_logic_vector(unsigned(PC_plus_1)-1);
		END IF;
	END IF;
	
END PROCESS;
EPC_out <= EPC_current;
END EPC_arch;
