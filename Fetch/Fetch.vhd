library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Fetch IS
port( 
		clk: in std_logic;
		Reset : in std_logic;
		SP_exc: in std_logic;
		Mem_exc: in std_logic;
		PC_src: in std_logic;
		WD: in std_logic_vector(15 downto 0);
		Instruction: out std_logic_vector(15 downto 0);
		Immediate : out std_logic_vector(15 downto 0);
		PC_1: out std_logic_vector(15 downto 0)
		);
end entity;

architecture Fetch_arch of Fetch is 

component PC_Mux is
generic(  
	word_width : integer := 8 );
port(
	--inputs
	selector 	: in std_logic_vector(2 downto 0);  
	PC       	: in std_logic_vector(word_width-1 downto 0);
	PC_plus1 	: in std_logic_vector(word_width-1 downto 0);
	PC_plus2 	: in std_logic_vector(word_width-1 downto 0);
	jump 	    : in std_logic_vector(word_width-1 downto 0);
	IM_0 	    : in std_logic_vector(word_width-1 downto 0);
	IM_1 	    : in std_logic_vector(word_width-1 downto 0);
	IM_2 	    : in std_logic_vector(word_width-1 downto 0);
	interrupt 	: in std_logic_vector(word_width-1 downto 0);

	--outputs
	address 	: out std_logic_vector(word_width-1 downto 0) 
	); 
end component;

component Instruction_Memory is
port(
	--inputs 
	address 	: in std_logic_vector(address_bits-1 downto 0);
	--outputs
	instruction : out std_logic_vector(word_width-1 downto 0); 
	immediate 	: out std_logic_vector(word_width-1 downto 0);
	IM_3 		: out std_logic_vector(word_width-1 downto 0)
	); 
end component;

component PC is
port(
	--inputs
	clk 		: in std_logic;  
	mux_entry 	: in std_logic_vector(word_width-1 downto 0);
	--outputs
	address 	: out std_logic_vector(word_width-1 downto 0) 
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
    --outputs
    PC_selector : out std_logic_vector(4 downto 0);
    interrupt   : out std_logic_vector(15 downto 0)
    ); 
end component;
begin
pc: PC Port


end architecture; 