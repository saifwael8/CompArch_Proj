library ieee;
use ieee.std_logic_1164.all;


entity ALU is
	port (
		ALUop : in std_logic_vector(3 downto 0);
		OP1, OP2 : in std_logic_vector(15 downto 0);
		Cin : in std_logic;
		ALU_Result : out std_logic_vector(15 downto 0);
		Output_Flags: out std_logic_vector(2 downto 0) --(ZF, CF, NF)
	);

end entity ALU;


architecture ALU_arch of ALU is

	-- your component and signal declarations here
COMPONENT Part_A IS
PORT ( A, B: IN STD_LOGIC_VECTOR (15 downto 0);
		 Cin: IN STD_LOGIC;
		 Sel: IN STD_LOGIC_VECTOR (1 downto 0);
		 F: OUT STD_LOGIC_VECTOR (15 downto 0);
		 Cout: OUT STD_LOGIC
		 --Output_Flags: out std_logic_vector(2 downto 0)
	   );
END COMPONENT;

COMPONENT Part_B IS
PORT ( A, B: IN STD_LOGIC_VECTOR (15 downto 0);
		 Cin: IN STD_LOGIC;
		 Sel: IN STD_LOGIC_VECTOR (1 downto 0);
		 F: OUT STD_LOGIC_VECTOR (15 downto 0);
		 Cout: OUT STD_LOGIC
		 --Output_Flags: out std_logic_vector(2 downto 0)
	   );
END COMPONENT;

COMPONENT Part_C IS
PORT ( A, B: IN STD_LOGIC_VECTOR (15 downto 0);
		 Cin: IN STD_LOGIC;
		 Sel: IN STD_LOGIC_VECTOR (1 downto 0);
		 F: OUT STD_LOGIC_VECTOR (15 downto 0);
		 Cout: OUT STD_LOGIC
		 --Output_Flags: out std_logic_vector(2 downto 0)
	   );
END COMPONENT;

COMPONENT Part_D IS
PORT ( A, B: IN STD_LOGIC_VECTOR (15 downto 0);
		 Cin: IN STD_LOGIC;
		 Sel: IN STD_LOGIC_VECTOR (1 downto 0);
		 F: OUT STD_LOGIC_VECTOR (15 downto 0);
		 Cout: OUT STD_LOGIC
		 --Output_Flags: out std_logic_vector(2 downto 0)
	   );
END COMPONENT;

COMPONENT mux4_generic IS
PORT ( in0, in1, in2, in3: IN STD_LOGIC_VECTOR (15 downto 0);
		 c0, c1, c2, c3: IN STD_LOGIC;
		 sel : IN STD_LOGIC_VECTOR (1 downto 0);
		 out1: OUT STD_LOGIC_VECTOR (15 downto 0);
		 cout: OUT STD_LOGIC
		);
END COMPONENT;

Signal f1,f2,f3,f4: STD_LOGIC_VECTOR (15 downto 0);
Signal Cout1,Cout2,Cout3,Cout4: STD_LOGIC;
Signal Carry_out, Zero_out, Negative_out: std_logic;
Signal ALU_res: STD_LOGIC_VECTOR (15 downto 0);

begin

	-- Your structural/behavioural code here
	
	p0: Part_A PORT MAP (OP1,OP2,Cin,ALUop(1 downto 0),f1,Cout1);
	p1: Part_B PORT MAP (OP1,OP2,Cin,ALUop(1 downto 0),f2,Cout2);
	p2: Part_C PORT MAP (OP1,OP2,Cin,ALUop(1 downto 0),f3,Cout3);
	p3: Part_D PORT MAP (OP1,OP2,Cin,ALUop(1 downto 0),f4,Cout4);
	
	m: mux4_generic PORT MAP (f1,f2,f3,f4,Cout1,Cout2,Cout3,Cout4,ALUop(3 downto 2),ALU_res,Carry_out);
	
	Output_Flags(1) <= Carry_out;
	
	with ALU_res select
    Zero_out <= '1' when "0000000000000000",
                '0' when others;
	Output_Flags(2) <= Zero_out;
	
	Negative_out <= ALU_res(15);
	Output_Flags(0) <= Negative_out;
	
	ALU_Result <= ALU_res;
	
end architecture ALU_arch;
