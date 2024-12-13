LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Part_C IS
GENERIC (n: integer :=8);
PORT ( A, B: IN STD_LOGIC_VECTOR (n-1 downto 0);
		 Cin: IN STD_LOGIC;
		 Sel: IN STD_LOGIC_VECTOR (1 downto 0);
		 F: OUT STD_LOGIC_VECTOR (n-1 downto 0);
		 Cout: OUT STD_LOGIC
	   );
END Part_C;

ARCHITECTURE Part_C_arch OF Part_C IS

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
Signal Cout1,Cout2,Cout3,Cout4: STD_LOGIC;

BEGIN
	
	x1<=A(n-2 downto 0) & '0';
	Cout1<=A(n-1);
	x2<=A(n-2 downto 0) & A(n-1);
	Cout2<=A(n-1);
	x3<=A(n-2 downto 0) & Cin;
	Cout3<= A(n-1);
	x4<=(OTHERS => '0');
	Cout4<='0';
	
	m: mux4_generic GENERIC MAP(n) PORT MAP (x1,x2,x3,x4,Cout1,Cout2,Cout3,Cout4,Sel,F,Cout);
	

END Part_C_arch;