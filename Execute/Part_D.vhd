LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Part_D IS
GENERIC (n: INTEGER := 8);
PORT ( A, B: IN STD_LOGIC_VECTOR (n-1 downto 0);
		 Cin: IN STD_LOGIC;
		 Sel: IN STD_LOGIC_VECTOR (1 downto 0);
		 F: OUT STD_LOGIC_VECTOR (n-1 downto 0);
		 Cout: OUT STD_LOGIC
	   );
END Part_D;

ARCHITECTURE Part_D_arch OF Part_D IS

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
	
	x1<= B;
	x2<= A(0) & A(n-1 downto 1);
	x3<= Cin & A(n-1 downto 1);
	x4<= A(n-1) & A(n-1 downto 1);
	
	m: mux4_generic GENERIC MAP(n) PORT MAP (x1,x2,x3,x4,'0',A(0),A(0),A(0),Sel,F,Cout);

END Part_D_arch;