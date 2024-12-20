library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Memory block (SP, Data_Memory, muxes in between)

-- we will forward WA, PCSrc, ALU_Result(From_ALU), stall signals and Control_bus from EM_reg to MWB_reg
  
ENTITY Memory IS
port( 
		clk: in std_logic;
		Control_Bus: in std_logic_vector(23 downto 0);
		ALU_Result : in std_logic_vector(15 downto 0);
		RD2, PC_plus_1: in std_logic_vector(15 downto 0);
		
		SP_address, Memory_address, From_Memory: out std_logic_vector(15 downto 0);
		Restore_Flags: out std_logic_vector(2 downto 0)
		);
end entity;

architecture Memory_arch of Memory is

signal SInc : std_logic := Control_Bus(4);
signal SP_enable : std_logic := Control_Bus(5);
signal DSrc : std_logic := Control_Bus(3);
signal WB : std_logic := Control_Bus(23);
signal MR : std_logic := Control_Bus(21);
signal MW : std_logic := Control_Bus(22);
signal Input_Memory_Address, Input_Data_Memory, Output_From_Memory, SP_Intermediate : std_logic_vector(15 downto 0); 

component Data_Memory is 
generic( 
	address_bits : integer := 12; 
	word_width : integer := 16 ); 
port( 
	clk 		: in std_logic; 
	MR, MW 		: in std_logic; 
	Memory_Address: in std_logic_vector(11 downto 0);
	Data: in std_logic_vector(15 downto 0);
	From_Memory: out std_logic_vector(15 downto 0)
	);
	
end component;

component SP is 
port( 
	clk 		: in std_logic; 
	SP_enable: in std_logic; 
	SInc     : in std_logic;
	SP_address_out 	: out std_logic_vector(15 downto 0)); 
	
end component;

begin

SPointer: SP Port Map (clk, SP_enable, SInc, SP_Intermediate);

with SP_enable select Input_Memory_Address <= 
	ALU_Result when '0', SP_Intermediate when '1', (others => '0') when others;

with DSrc select Input_Data_Memory <= 
RD2 when '0', PC_plus_1 when '1', (others => '0') when others;

DM: Data_Memory Port MAP (clk, MR, MW, Input_Memory_Address(11 downto 0), Input_Data_Memory, Output_From_Memory);

From_Memory <= Output_From_Memory;
Restore_Flags <= Output_From_Memory(15 downto 13);
SP_address <= SP_Intermediate;
Memory_address <= Input_Memory_Address;

end architecture;