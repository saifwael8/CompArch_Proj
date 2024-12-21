LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY my_adder IS
PORT( a,b : IN STD_LOGIC_VECTOR (15 downto 0);
		cin: IN STD_LOGIC;
		s: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		cout: OUT STD_LOGIC);
		
END my_adder;


ARCHITECTURE my_adder_arch OF my_adder IS

COMPONENT bit_adder IS
PORT (a, b, cin: IN STD_LOGIC;
		s, cout: OUT STD_LOGIC);
END COMPONENT;
SIGNAL c: STD_LOGIC_VECTOR (16 downto 0);

BEGIN
	c(0) <= cin;
	
	loop1: FOR i IN 0 TO 15 GENERATE
			 fx: bit_adder PORT MAP (a(i), b(i), c(i), s(i), c(i+1));
	END GENERATE;
	
	cout <= c(16);
	
END my_adder_arch;