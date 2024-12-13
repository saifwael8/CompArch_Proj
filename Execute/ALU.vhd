library ieee;
use ieee.std_logic_1164.all;


entity ALU is

	generic (
		WIDTH : integer := 8
	);

	port (
		S : in std_logic_vector(3 downto 0);
		In1, In2 : in std_logic_vector(WIDTH-1 downto 0);
		Cin : in std_logic;
		F : out std_logic_vector(WIDTH-1 downto 0);
		Cout : out std_logic
	);

end entity ALU;


architecture ALU_arch of ALU is

	-- your component and signal declarations here
COMPONENT Part_A IS
GENERIC (n: integer :=8);
PORT ( A, B: IN STD_LOGIC_VECTOR (n-1 downto 0);
		 Cin: IN STD_LOGIC;
		 Sel: IN STD_LOGIC_VECTOR (1 downto 0);
		 F: OUT STD_LOGIC_VECTOR (n-1 downto 0);
		 Cout: OUT STD_LOGIC
	   );
END COMPONENT;

COMPONENT Part_B IS
GENERIC (n: integer :=8);
PORT ( A, B: IN STD_LOGIC_VECTOR (n-1 downto 0);
		 Cin: IN STD_LOGIC;
		 Sel: IN STD_LOGIC_VECTOR (1 downto 0);
		 F: OUT STD_LOGIC_VECTOR (n-1 downto 0);
		 Cout: OUT STD_LOGIC
	   );
END COMPONENT;

COMPONENT Part_C IS
GENERIC (n: integer :=8);
PORT ( A, B: IN STD_LOGIC_VECTOR (n-1 downto 0);
		 Cin: IN STD_LOGIC;
		 Sel: IN STD_LOGIC_VECTOR (1 downto 0);
		 F: OUT STD_LOGIC_VECTOR (n-1 downto 0);
		 Cout: OUT STD_LOGIC
	   );
END COMPONENT;

COMPONENT Part_D IS
GENERIC (n: integer :=8);
PORT ( A, B: IN STD_LOGIC_VECTOR (n-1 downto 0);
		 Cin: IN STD_LOGIC;
		 Sel: IN STD_LOGIC_VECTOR (1 downto 0);
		 F: OUT STD_LOGIC_VECTOR (n-1 downto 0);
		 Cout: OUT STD_LOGIC
	   );
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

Signal f1,f2,f3,f4: STD_LOGIC_VECTOR (WIDTH-1 downto 0);
Signal Cout1,Cout2,Cout3,Cout4: STD_LOGIC;

begin

	-- Your structural/behavioural code here
	
	p0: Part_A GENERIC MAP(WIDTH) PORT MAP (In1,In2,Cin,S(1 downto 0),f1,Cout1);
	p1: Part_B GENERIC MAP(WIDTH) PORT MAP (In1,In2,Cin,S(1 downto 0),f2,Cout2);
	p2: Part_C GENERIC MAP(WIDTH) PORT MAP (In1,In2,Cin,S(1 downto 0),f3,Cout3);
	p3: Part_D GENERIC MAP(WIDTH) PORT MAP (In1,In2,Cin,S(1 downto 0),f4,Cout4);
	
	m: mux4_generic GENERIC MAP(WIDTH) PORT MAP (f1,f2,f3,f4,Cout1,Cout2,Cout3,Cout4,S(3 downto 2),F,Cout);

end architecture ALU_arch;
