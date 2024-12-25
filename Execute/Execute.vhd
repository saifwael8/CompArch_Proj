library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Execute block (CCR, ALU, muxes in between)

-- we will forward WA(Ins10_8), RD2, stall signals and Control_bus from DE_reg to EM_reg
  
ENTITY Execute IS
port( 
		clk: in std_logic;
		Control_Bus: in std_logic_vector(23 downto 0);
		RD1, Mem_to_ALU, ALU_to_ALU : in std_logic_vector(15 downto 0);
		RD2, Immediate: in std_logic_vector(15 downto 0);
		Inport: in std_logic_vector(15 downto 0);
		
		
		Restore_Flags : in std_logic_vector(2 downto 0);
		OP1_Selector, OP2_Selector : in std_logic_vector(1 downto 0);
		
		PC_plus_1: in std_logic_vector(15 downto 0);
		EM_RTI: in std_logic;
		
		PC_out, ALU_Out: out std_logic_vector(15 downto 0);
		PCSrc: out std_logic;
		RD2_out: out std_logic_vector(15 downto 0)
		);
end entity;

Architecture Execute_arch of Execute is

component ALU is
	port (
		ALUop : in std_logic_vector(3 downto 0);
		OP1, OP2 : in std_logic_vector(15 downto 0);
		Cin : in std_logic;
		ALU_Result : out std_logic_vector(15 downto 0);
		Output_Flags: out std_logic_vector(2 downto 0) --(ZF, CF, NF)
	);

end component;

component CCR is
port( clk: in std_logic;
		Input_Flags_ALU, Input_Flags_Restore: in std_logic_vector(2 downto 0); -- assume ZF is CCR(2), CF is CCR(1), NF is CCR(0)
		ZW, CW, NW, SetC, SelFlag, EM_RTI: in std_logic;
		Output_Flags: out std_logic_vector(2 downto 0)
);

end component;

Signal OP1, OP2, RD2_mux, ALU_Result: std_logic_vector(15 downto 0);
Signal ALU_Flags, CCR_Flags: std_logic_vector(2 downto 0);
Signal Flags_mux: std_logic;

begin

with OP1_Selector select OP1 <=
	ALU_to_ALU when "10",
	Mem_to_ALU when "01",
	RD1 when others;

with Control_Bus(20) select OP2 <=
	RD2_mux when '0',
	Immediate when others;

with OP2_Selector select RD2_mux <=
	ALU_to_ALU when "10",
	Mem_to_ALU when "01",
	RD2 when others;	

RD2_out <= RD2_mux;
	
AL: ALU Port Map (Control_Bus(19 downto 16), OP1, OP2, Control_Bus(13), ALU_Result, ALU_Flags);

with Control_Bus(6) select ALU_Out <=
	ALU_Result when '0', 
	Inport when others;

CR: CCR Port Map (clk, ALU_Flags, Restore_Flags, Control_Bus(12), Control_Bus(11), Control_Bus(10), Control_Bus(9), Control_Bus(8), EM_RTI, CCR_Flags);	

PC_out(15 downto 13)	<= CCR_Flags;
PC_out(12 downto 0)<= PC_plus_1(12 downto 0);

with Control_Bus(2 downto 1) select Flags_mux <=
	CCR_Flags(2) when "00",
	CCR_Flags(0) when "01",
	CCR_Flags(1) when "10",
	'1' when others;
	
PCSrc <= Flags_mux and Control_Bus(14);

end architecture;