library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Fetch IS
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
end entity;

architecture Fetch_arch of Fetch is 

component PC_Mux is
port(
	--inputs
	selector 	: in std_logic_vector(2 downto 0);  
	PC       	: in std_logic_vector(15 downto 0);
	PC_plus1 	: in std_logic_vector(15 downto 0);
	PC_plus2 	: in std_logic_vector(15 downto 0);
	jump 	    : in std_logic_vector(15 downto 0);
	IM_0 	    : in std_logic_vector(15 downto 0);
	IM_1 	    : in std_logic_vector(15 downto 0);
	IM_2 	    : in std_logic_vector(15 downto 0);
	interrupt 	: in std_logic_vector(15 downto 0);

	--outputs
	address 	: out std_logic_vector(15 downto 0) 
	); 
end component;

component Instruction_memory is 
port(
	--inputs 
	address 	: in std_logic_vector(11 downto 0);
	add3_index : in std_logic_vector(11 downto 0);
	--outputs
	instruction : out std_logic_vector(15 downto 0); 
	immediate 	: out std_logic_vector(15 downto 0);
	IM_0		: out std_logic_vector(15 downto 0);
	IM_1		: out std_logic_vector(15 downto 0);
	IM_2		: out std_logic_vector(15 downto 0);
	IM_3 		: out std_logic_vector(15 downto 0);
	IM_3_index  : out std_logic_vector(15 downto 0)
	); 
end component;

component PC is
port(
	--inputs
	clk 		: in std_logic;  
	mux_entry 	: in std_logic_vector(15 downto 0);
	--outputs
	address 	: out std_logic_vector(15 downto 0) 
	); 
end component;

component PC_Decoder is
port(
    --inputs
    instruction : in std_logic_vector(15 downto 0);
    IM_3        : in std_logic_vector(15 downto 0);
    PC_Src      : in std_logic;
    invalid_mem : in std_logic;
    SP_exception: in std_logic;
    reset       : in std_logic;
	stall       : in std_logic;
    --outputs
    PC_selector : out std_logic_vector(2 downto 0);
    interrupt   : out std_logic_vector(15 downto 0)
    ); 
end component;
signal address_pc, pc_1, pc_2, mux_out, inst_m0, inst_m1, inst_m2, im_int, instruct, imm, im3, interruptValue: std_logic_vector(15 downto 0);
signal pc_sel : std_logic_vector(2 downto 0);
begin

progc: PC port map(clk, mux_out, address_pc);
pc_1 <= std_logic_vector(unsigned(address_pc) + 1);
pc_2 <= std_logic_vector(unsigned(address_pc) + 2);
pc_mx: PC_Mux port map(pc_sel, address_pc, pc_1, pc_2, WD, inst_m0, inst_m1, inst_m2, interruptValue , mux_out);
inst_mem: Instruction_Memory port map(address_pc(11 downto 0), im_int(11 downto 0) , instruct, imm, inst_m0, inst_m1, inst_m2, im3, interruptValue);
pc_dec: PC_Decoder port map(instruct, im3, PC_Src, invalid_mem, SP_exception, reset, stall, pc_sel, im_int);

instruction <= instruct;
immediate <= imm;
PC_address_out <= pc_1;
end architecture; 