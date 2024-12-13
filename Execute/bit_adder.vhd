LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY bit_adder IS
PORT (a, b, cin: IN STD_LOGIC;
		s, cout: OUT STD_LOGIC);
END bit_adder; 

ARCHITECTURE bit_adder_arch OF bit_adder IS
BEGIN

		s <= a XOR b XOR cin;
		cout <= (a AND b) OR (cin AND (a XOR b));

END bit_adder_arch;
