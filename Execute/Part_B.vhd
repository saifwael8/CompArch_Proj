LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Part_B IS
GENERIC (n: integer :=8);
PORT ( A, B: IN STD_LOGIC_VECTOR (n-1 downto 0);
		 Cin: IN STD_LOGIC;
		 Sel: IN STD_LOGIC_VECTOR (1 downto 0);
		 F: OUT STD_LOGIC_VECTOR (n-1 downto 0);
		 Cout: OUT STD_LOGIC
	   );
END Part_B;

ARCHITECTURE Part_B_arch OF Part_B IS

COMPONENT mux4_generic IS
GENERIC (n: integer :=8);
PORT ( in0, in1, in2, in3: IN STD_LOGIC_VECTOR (n-1 downto 0);
		 c0, c1, c2, c3: IN STD_LOGIC;
		 sel : IN STD_LOGIC_VECTOR (1 downto 0);
		 out1: OUT STD_LOGIC_VECTOR (n-1 downto 0);
		 cout: OUT STD_LOGIC
		);
END COMPONENT;
Signal x1,x2,x3,x4: STD_LOGIC_VECTOR (n-1 downto 0);


BEGIN
	
	x1<= A xor B;
	x2<= A and B;
	x3<= A or B;
	x4<= not A;
	m: mux4_generic GENERIC MAP(n) PORT MAP (x1,x2,x3,x4,'0','0','0','0',Sel,F,Cout);

END Part_B_arch;