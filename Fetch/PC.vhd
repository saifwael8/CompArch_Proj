library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is 
generic(  
	word_width : integer := 8 ); 
port( 
	clk 		: in std_logic; 
	rst		: in std_logic; 
	enable 		: in std_logic;  
	count 	: out std_logic_vector(word_width-1 downto 0) ); 
	
end entity; 

ARCHITECTURE PC_arch OF PC IS

signal D : std_logic_vector(word_width-1 downto 0) := (Others => '0');
BEGIN

PROCESS(clk,rst)
BEGIN

	IF (rst= '0' AND rising_edge(clk)) then
			D <= (0 => '1', Others => '0');
			count <= (Others => '0');

	ELSIF rising_edge(clk) then
		IF (enable = '1') then
			D <= std_logic_vector(unsigned(D) + 1);
			count <= D;
		END IF;
	END IF;
	
END PROCESS;

END PC_arch;

