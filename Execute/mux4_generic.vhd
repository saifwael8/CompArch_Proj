LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux4_generic IS
PORT ( in0, in1, in2, in3: IN STD_LOGIC_VECTOR (15 downto 0);
		 c0, c1, c2, c3: IN STD_LOGIC;
		 sel : IN STD_LOGIC_VECTOR (1 downto 0);
		 out1: OUT STD_LOGIC_VECTOR (15 downto 0);
		 cout: OUT STD_LOGIC
		);
END mux4_generic;

ARCHITECTURE mux4_generic_arch OF mux4_generic IS
BEGIN
	
	WITH 	sel SELECT
	out1<= 
	in0 WHEN "00",
	in1 WHEN "01",
	in2 WHEN "10",
	in3 WHEN Others;
	
	WITH 	sel SELECT
	cout<= 
	c0 WHEN "00",
	c1 WHEN "01",
	c2 WHEN "10",
	c3 WHEN Others;
	
END mux4_generic_arch;