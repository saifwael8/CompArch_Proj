LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Part_A IS
GENERIC (n: integer :=8);
PORT ( A, B: IN STD_LOGIC_VECTOR (n-1 downto 0);
		 Cin: IN STD_LOGIC;
		 Sel: IN STD_LOGIC_VECTOR (1 downto 0);
		 F: OUT STD_LOGIC_VECTOR (n-1 downto 0);
		 Cout: OUT STD_LOGIC
	   );
END Part_A;

ARCHITECTURE Part_A_arch OF Part_A IS

COMPONENT my_adder IS
GENERIC (n: INTEGER :=8);
PORT( a,b : IN STD_LOGIC_VECTOR (n-1 downto 0);
		cin: IN STD_LOGIC;
		s: OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		cout: OUT STD_LOGIC);
		
END COMPONENT;

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
Signal not_B: STD_LOGIC_VECTOR (n-1 downto 0);

BEGIN

		a1: my_adder GENERIC MAP(n) PORT MAP (A, (OTHERS => '0'), Cin, x1, Cout1);
		a2: my_adder GENERIC MAP(n) PORT MAP (A, B, Cin, x2, Cout2);
		
		not_B <= NOT B; --taking not B will give me -B-1
		a3: my_adder GENERIC MAP(n) PORT MAP (A, not_B, Cin, x3, Cout3);
		a4: my_adder GENERIC MAP(n) PORT MAP (A, (OTHERS => '1'), Cin, x4, Cout4);
		
		m: mux4_generic GENERIC MAP(n) PORT MAP(x1,x2,x3,x4,Cout1,Cout2,Cout3,Cout4,Sel,F,Cout);
		
END Part_A_arch;
