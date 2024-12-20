library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Pass immediate, PC + 1, RA1, RA2, WA straight from FD_reg to DE_reg

ENTITY Decode IS
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
end entity;

architecture Decode_arc of Decode is

component Control_Unit IS
port( 	Opcode : in std_logic_vector(4 downto 0);
		PC_src: in std_logic;
		Control_Bus: out std_logic_vector(23 downto 0);
		Flush_br : out std_logic
		);
end component;

component Register_File is 
generic( 
	address_bits : integer := 3; 
	word_width : integer := 16 ); 
port( 
	clk 		: in std_logic; 
	WE 		: in std_logic; 
	RA1, RA2, WA 	: in std_logic_vector(address_bits-1 downto 0);
 	WD	 	: in std_logic_vector(word_width-1 downto 0); 
	RD1, RD2 	: out std_logic_vector(word_width-1 downto 0) ); 
	
end component; 

begin

CU: Control_Unit Port MAP (Instruction(15 downto 11), PC_src, Control_Bus, Flush_br);
Rg: Register_File Port Map (clk, WB, Instruction(7 downto 5), Instruction(4 downto 2), WA_WB, WD, RD1, RD2);


end architecture;