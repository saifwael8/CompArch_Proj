library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SingleCycle is
PORT(
		reset, clk: in std_logic;
		InPort: in std_logic_vector(15 downto 0);
		OutPort: out std_logic_vector(15 downto 0));
end entity;


Architecture SingleCycle_arch of SingleCycle is

--components
component Fetch IS
port( 
		--inputs
		clk: in std_logic;
		PC_Src      : in std_logic;
		invalid_mem : in std_logic;
		SP_exception: in std_logic;
		reset       : in std_logic;
		stall	    : in std_logic;
		WD: in std_logic_vector(15 downto 0);
		--outputs
		instruction : out std_logic_vector(15 downto 0); 
		immediate 	: out std_logic_vector(15 downto 0);
		--IM_3 		: out std_logic_vector(15 downto 0);
		PC_address_out: out std_logic_vector(15 downto 0)
		);
end component;




COMPONENT Decode IS
port( 
		clk: in std_logic;
		Instruction : in std_logic_vector(15 downto 0);
		PC_src: in std_logic;
		WA_WB: in std_logic_vector(2 downto 0);
		WD: in std_logic_vector(15 downto 0);
		WB: in std_logic;
		Control_Bus: out std_logic_vector(23 downto 0);
		Flush_br : out std_logic;
		RD1: out std_logic_vector(15 downto 0);
		RD2: out std_logic_vector(15 downto 0)
		);
end COMPONENT;	


COMPONENT Execute IS
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
		PCSrc: out std_logic
		);
end COMPONENT;


component Exception_Handler is 
port( 
	clk, SP_enable, SInc, MR, MW	: in std_logic; 
	SP_Address, Memory_Address: in std_logic_vector(15 downto 0);
	Save_EPC, SP_Exception, Memory_Exception: out std_logic); 
	
end component; 

 
COMPONENT Memory IS
port( 
		clk: in std_logic;
		Control_Bus: in std_logic_vector(23 downto 0);
		ALU_Result : in std_logic_vector(15 downto 0);
		RD2, PC_plus_1: in std_logic_vector(15 downto 0);
		
		SP_address, Memory_address, From_Memory: out std_logic_vector(15 downto 0);
		Restore_Flags: out std_logic_vector(2 downto 0)
		);
end COMPONENT;

COMPONENT EPC is 
port( 
	clk, Save_EPC 		: in std_logic; 
	PC_plus_1: in std_logic_vector(15 downto 0);
	EPC_out 	: out std_logic_vector(15 downto 0)); 
end COMPONENT; 




Signal Immediate_Fetch, Instruction_Fetch, PC_Plus_1_Fetch: std_logic_vector(15 downto 0);  --fetch output signals

Signal RD1_Decode, RD2_Decode: std_logic_vector(15 downto 0); --decode output signals
Signal Control_Bus_Decode: std_logic_vector(23 downto 0); --decode output signal
Signal PC_Src_Decode: std_logic := '0';
Signal Flush_Br_Decode: std_logic;

--Signal Control_Bus_Execute: std_logic_vector(23 downto 0); --execute output signal
--Signal WA_Execute: std_logic_vector(2 downto 0); --execute output signal
--Signal RD2_Execute, 
Signal ALU_Result_Execute: std_logic_vector(15 downto 0); --execute output signal
Signal PC_Plus_1_Execute: std_logic_vector(15 downto 0); --execute output signal
Signal OP1_Selector_Execute, OP2_Selector_Execute: std_logic_vector(1 downto 0) := "00";
Signal PC_Src_Execute: std_logic;

--Signal Control_Bus_Memory: std_logic_vector(23 downto 0); --Memory output signal
Signal From_Memory_Memory: std_logic_vector(15 downto 0); --Memory output signal
Signal SP_Memory, Memory_Address_Memory: std_logic_vector(15 downto 0); --Memory

Signal WA_Memory, Restore_Flags: std_logic_vector(2 downto 0); --Memory output signal
Signal PC_Src_Memory: std_logic;

Signal Save_EPC, SP_Exception, Memory_Exception: std_logic := '0';
Signal WD_Memory: std_logic_vector(15 downto 0) := (others => '0');
---------------------------------------------
Signal EPC_out: std_logic_vector(15 downto 0);

begin

F: Fetch PORT MAP (clk, PC_Src_Execute, Memory_Exception, SP_Exception, reset, '0', WD_Memory, Instruction_Fetch, 
						 Immediate_Fetch, PC_Plus_1_Fetch);
						 
D: Decode PORT MAP (clk, Instruction_Fetch, PC_Src_Decode, Instruction_Fetch(10 downto 8), WD_Memory, Control_Bus_Decode(23), 
						  Control_Bus_Decode, Flush_Br_Decode, RD1_Decode, RD2_Decode);
						  
E: Execute PORT MAP (clk, Control_Bus_Decode, RD1_Decode, WD_Memory, (others => '0'), RD2_Decode, 
						Immediate_Fetch, InPort, From_Memory_Memory(15 downto 13), OP1_Selector_Execute, 
						OP2_Selector_Execute, PC_Plus_1_Fetch, Control_Bus_Decode(0), PC_Plus_1_Execute, ALU_Result_Execute, PC_Src_Execute);

Restore_Flags <= From_Memory_Memory(15 downto 13);						
M: Memory PORT MAP (clk, Control_Bus_Decode, ALU_Result_Execute, RD2_Decode, PC_Plus_1_Execute, SP_Memory, 
						  Memory_Address_Memory, From_Memory_Memory, Restore_Flags);
						  
EH: Exception_Handler PORT MAP (clk, Control_Bus_Decode(5), Control_Bus_Decode(4), Control_Bus_Decode(21) , Control_Bus_Decode(22)  ,SP_Memory, Memory_Address_Memory, 
										  Save_EPC, SP_Exception, Memory_Exception);
										  
EXPC: EPC PORT MAP (clk, Save_EPC, PC_Plus_1_Execute, EPC_out);

with Control_Bus_Decode(15) Select WD_Memory <= 
From_Memory_Memory when '0', ALU_Result_Execute when others;

with Control_Bus_Decode(7) Select OutPort <= 
RD1_Decode when '1', (others => '0') when others;

end architecture;