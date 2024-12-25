library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Multi_cycle IS
PORT(
        --INPUTS
        clk     : in std_logic;
        reset   : in std_logic;
        inport    : in std_logic_vector(15 downto 0);
        --OUTPUTS
        outport   : out std_logic_vector(15 downto 0)
);
END ENTITY;

ARCHITECTURE Multi_cycle_arch OF Multi_cycle IS

COMPONENT Fetch IS
port( 
		--inputs
		clk: in std_logic;
		PC_Src      : in std_logic;
		invalid_mem : in std_logic;
		SP_exception: in std_logic;
		reset       : in std_logic;
        stall       : in std_logic;
		WD: in std_logic_vector(15 downto 0);
		--outputs
		instruction : out std_logic_vector(15 downto 0); 
		immediate 	: out std_logic_vector(15 downto 0);
		--IM_3 		: out std_logic_vector(15 downto 0);
        PC_address_out: out std_logic_vector(15 downto 0)
		);
end COMPONENT;

COMPONENT FD_reg is
port( 	
        --inputs
        clk: in std_logic;
        flush: in std_logic;
        stall: in std_logic;
        instruction: in std_logic_vector(15 downto 0);
        immediate: in std_logic_vector(15 downto 0);
        PC_address_in: in std_logic_vector(15 downto 0);
        --outputs
        opcode: out std_logic_vector(4 downto 0);
        RA1: out std_logic_vector(2 downto 0);
        RA2: out std_logic_vector(2 downto 0);
        WA: out std_logic_vector(2 downto 0);
        PC_address_out: out std_logic_vector(15 downto 0)
    );	
end COMPONENT;

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

COMPONENT DE_reg is
port( 
        clk: in std_logic;
        flush: in std_logic;
        stall: in std_logic;

        Control_Bus: in std_logic_vector(23 downto 0);
        RD1: in std_logic_vector(15 downto 0);
        RD2: in std_logic_vector(15 downto 0);
        Imm: in std_logic_vector(15 downto 0);
        RA1: in std_logic_vector(2 downto 0);
        RA2: in std_logic_vector(2 downto 0);
        WA: in std_logic_vector(2 downto 0);
        PC_1: in std_logic_vector(15 downto 0);

        Control_Bus_out: out std_logic_vector(23 downto 0);
        RD1_out: out std_logic_vector(15 downto 0);
        RD2_out: out std_logic_vector(15 downto 0);
        Imm_out: out std_logic_vector(15 downto 0);
        RA1_out: out std_logic_vector(2 downto 0);
        RA2_out: out std_logic_vector(2 downto 0);
        WA_out: out std_logic_vector(2 downto 0);
        PC_1_out: out std_logic_vector(15 downto 0)
        );
        end COMPONENT;

COMPONENT Hazard_Detection is 
port(
        exception: in std_logic;
        FD_RA1: in std_logic_vector(2 downto 0);
        FD_RA2: in std_logic_vector(2 downto 0);
        DE_WA: in std_logic_vector(2 downto 0);
        DE_MR: in std_logic;

        stall: out std_logic;
        Flush_exc: out std_logic
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
        PCSrc: out std_logic;
        RD2_out: out std_logic_vector(15 downto 0)
        );
end COMPONENT;


COMPONENT EM_reg is
port( 
        clk: in std_logic;
        flush: in std_logic;
        stall: in std_logic;
        
        Control_Bus: in std_logic_vector(23 downto 0);
        RD2: in std_logic_vector(15 downto 0);
        WA: in std_logic_vector(2 downto 0);
        ALU_Result: in std_logic_vector(15 downto 0); 		
        PC_1: in std_logic_vector(15 downto 0);
        PCSrc: in std_logic;
        
        Control_Bus_out: out std_logic_vector(23 downto 0);
        RD2_out: out std_logic_vector(15 downto 0);
        WA_out: out std_logic_vector(2 downto 0);
        ALU_out: out std_logic_vector(15 downto 0);
        PC_1_out: out std_logic_vector(15 downto 0);
        PCSrc_out: out std_logic
);
end COMPONENT;

COMPONENT Forwarding_Unit is
port( 
        DE_RA1, DE_RA2: in std_logic_vector(2 downto 0);
        EM_WA, MWB_WA: in std_logic_vector(2 downto 0);
        EM_WB, MWB_WB: in std_logic;

        OP1_Selector, OP2_Selector: out std_logic_vector(1 downto 0)
        
);
end COMPONENT;

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

component Exception_Handler is 
port( 
	clk, SP_enable, SInc, MR, MW	: in std_logic; 
	SP_Address, Memory_Address: in std_logic_vector(15 downto 0);
	Save_EPC, SP_Exception, Memory_Exception: out std_logic); 
	
end component; 


COMPONENT EPC is 
port( 
        clk, Save_EPC 		: in std_logic; 
        PC_plus_1: in std_logic_vector(15 downto 0);
        EPC_out 	: out std_logic_vector(15 downto 0)
); 
	
end COMPONENT;

COMPONENT MWB_reg is
port( 
        clk: in std_logic;
        stall: in std_logic;
        PCSrc: in std_logic;
        
        Control_Bus: in std_logic_vector(23 downto 0);
        From_Memory: in std_logic_vector(15 downto 0);
        From_ALU: in std_logic_vector(15 downto 0);
        WA: in std_logic_vector(2 downto 0);
        
        Control_Bus_out: out std_logic_vector(23 downto 0);
        From_Memory_out: out std_logic_vector(15 downto 0);
        From_ALU_out: out std_logic_vector(15 downto 0);
        WA_out: out std_logic_vector(2 downto 0);
        PCSrc_out: out std_logic
);
end COMPONENT;
--Signals
signal pc_src: std_logic; -- from Execute through WB and back to Fetch
signal invld_mem: std_logic; -- from Exception Handling unit to Fetch
signal SP_ex: std_logic; -- from Exception Handling unit to Fetch
signal WD: std_logic_vector(15 downto 0); -- from DE reg through to WB and back to Fetch
signal pc_outf: std_logic_vector(15 downto 0); -- from fetch to fd reg
signal instruction: std_logic_vector(15 downto 0); -- from Fetch to FD reg
signal immediate: std_logic_vector(15 downto 0); -- from Fetch to FD reg
--signal IM_3: std_logic_vector(15 downto 0); -- from Fetch to FD reg
signal stall : std_logic := '0'; -- from Hazard Detection to Fetch

signal opcode: std_logic_vector(4 downto 0); -- from FD reg to Decode
signal RA1: std_logic_vector(2 downto 0); -- from FD reg to Decode
signal RA2: std_logic_vector(2 downto 0); -- from FD reg to Decode
signal WA: std_logic_vector(2 downto 0); -- from FD reg to Decode
signal instruction_d: std_logic_vector(15 downto 0); -- from FD reg to Decode
signal pc_outfd: std_logic_vector(15 downto 0); -- from FD reg to Decode
signal ctrl_bus_d: std_logic_vector(23 downto 0); -- from Decode to DE reg
signal flush_br: std_logic := '0'; -- from Decode to DE reg
signal RD1: std_logic_vector(15 downto 0); -- from Decode to DE reg
signal RD2: std_logic_vector(15 downto 0); -- from Decode to DE reg

signal ctrl_bus_e: std_logic_vector(23 downto 0); -- from DE reg to Execute
signal RD1_e: std_logic_vector(15 downto 0); -- from DE reg to Execute
signal RD2_e: std_logic_vector(15 downto 0); -- from DE reg to Execute
signal RD2_e_out: std_logic_vector(15 downto 0); -- from DE reg to Execute
signal immediate_e: std_logic_vector(15 downto 0); -- from DE reg to Execute
signal RA1_e: std_logic_vector(2 downto 0); -- from DE reg to Execute
signal RA2_e: std_logic_vector(2 downto 0); -- from DE reg to Execute
signal WA_e: std_logic_vector(2 downto 0); -- from DE reg to Execute
signal pc_outde: std_logic_vector(15 downto 0); -- from DE reg to Execute

signal exception: std_logic; -- from Fetch to Hazard Detection
signal flush_ex: std_logic:= '0'; -- from Hazard Detection to DE reg
signal flush: std_logic:= '0'; -- flush_br or flush_ex

signal OP1_Selector: std_logic_vector(1 downto 0); -- from Forwarding Unit to Execute
signal OP2_Selector: std_logic_vector(1 downto 0); -- from Forwarding Unit to Execute
signal pc_oute: std_logic_vector(15 downto 0); -- from Execute to EM reg
signal alu_out: std_logic_vector(15 downto 0); -- from Execute to EM reg
signal pc_src_e: std_logic; -- from Execute to EM reg

signal ctrl_bus_em: std_logic_vector(23 downto 0); -- from EM reg to Memory
signal RD2_em: std_logic_vector(15 downto 0); -- from EM reg to Memory
signal WA_em: std_logic_vector(2 downto 0); -- from EM reg to Memory
signal alu_out_em: std_logic_vector(15 downto 0); -- from EM reg to Memory
signal pc_outem: std_logic_vector(15 downto 0); -- from EM reg to Memory
signal pc_src_em: std_logic; -- from EM reg to Memory

signal SP_address: std_logic_vector(15 downto 0); -- from Memory to MWB reg
signal Memory_address: std_logic_vector(15 downto 0); -- from Memory to MWB reg
signal From_Memory: std_logic_vector(15 downto 0); -- from Memory to MWB reg
signal restore_flags: std_logic_vector(2 downto 0); -- from Memory to Execute
signal WA_m: std_logic_vector(2 downto 0); -- from Memory to MWB reg

signal WA_mw: std_logic_vector(2 downto 0); -- from MW reg to WB
signal ctrl_bus_mw: std_logic_vector(23 downto 0); -- from MW reg to WB
signal From_Memory_out: std_logic_vector(15 downto 0); -- from MW reg to WB
signal From_ALU_out: std_logic_vector(15 downto 0); -- from MW reg to WB
signal pc_src_mw: std_logic; -- from MW reg to WB

signal WD_WB: std_logic_vector(15 downto 0); -- from WB to Decode

signal Save_EPC: std_logic; -- from Exception Handling to EPC
signal EPC_out: std_logic_vector(15 downto 0); -- from EPC to Exception Handling
BEGIN

F: Fetch PORT MAP(clk, pc_src, invld_mem, SP_ex, reset, stall, WD, instruction, immediate, pc_outf);
FD: FD_reg PORT MAP(clk, flush, stall, instruction, immediate, pc_outf, opcode, RA1, RA2, WA, pc_outfd);
instruction_d <= opcode & WA & RA1 & RA2 & "00";
D: Decode PORT MAP(clk, instruction_d, pc_src, WA_mw, WD_WB, ctrl_bus_mw(23), ctrl_bus_d, flush_br, RD1, RD2);
DE: DE_reg PORT MAP(clk, flush, stall, ctrl_bus_d, RD1, RD2, immediate, RA1, RA2, WA, pc_outfd, ctrl_bus_e, RD1_e, RD2_e, immediate_e, RA1_e, RA2_e, WA_e, pc_outde);
exception <= SP_ex or invld_mem;
HD: Hazard_Detection PORT MAP(exception, RA1, RA2, WA_e, stall, flush_ex);
flush <= flush_br or flush_ex;
E: Execute PORT MAP(clk, ctrl_bus_e, RD1_e, WD_WB, alu_out_em, RD2_e, immediate_e, inport, restore_flags, OP1_Selector, OP2_Selector, pc_outde, ctrl_bus_em(0), pc_oute, alu_out, pc_src_e, RD2_e_out);
EM: EM_reg PORT MAP(clk, flush, stall, ctrl_bus_e, RD2_e_out, WA_e, alu_out, pc_oute, pc_src_e, ctrl_bus_em, RD2_em, WA_em, alu_out_em, pc_outem, pc_src_em);
M: Memory PORT MAP(clk, ctrl_bus_em, alu_out_em, RD2_em, pc_outem, SP_address, Memory_address, From_Memory, restore_flags);
MWB: MWB_reg PORT MAP(clk, stall, pc_src_em, ctrl_bus_em, From_Memory, alu_out_em, WA_em, ctrl_bus_mw, From_Memory_out, From_ALU_out, WA_mw, pc_src_mw);
FU: Forwarding_Unit PORT MAP(RA1_e, RA2_e, WA_em, WA_mw, ctrl_bus_em(23), ctrl_bus_mw(23), OP1_Selector, OP2_Selector);
EH: Exception_Handler PORT MAP(clk, ctrl_bus_em(5), ctrl_bus_em(4), ctrl_bus_em(21)  , ctrl_bus_em(22)  ,  SP_address, Memory_address, Save_EPC, SP_ex, invld_mem);
e_pc: EPC PORT MAP(clk, Save_EPC, pc_outem, EPC_out);

with ctrl_bus_mw(15) select
    WD_WB <= From_Memory_out when '0',
    From_ALU_out when others;
with ctrl_bus_e(7) select
    outport <= RD1_e when '1',
    (others => '0') when others;
END ARCHITECTURE;