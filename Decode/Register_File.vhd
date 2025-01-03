library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_File is 
generic( 
	address_bits : integer := 3; 
	word_width : integer := 16 ); 
port( 
	clk 		: in std_logic; 
	WE 		: in std_logic; 
	RA1, RA2, WA 	: in std_logic_vector(address_bits-1 downto 0);
 	WD	 	: in std_logic_vector(word_width-1 downto 0); 
	RD1, RD2 	: out std_logic_vector(word_width-1 downto 0) ); 
	
end entity; 
	
ARCHITECTURE Register_File_arch OF Register_File IS

TYPE Ram_type IS ARRAY((2**address_bits)-1 DOWNTO 0) OF STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
SIGNAL memory: Ram_type := (others => (others => '0'));

BEGIN

PROCESS(clk)
BEGIN

	IF rising_edge(clk) then
		IF (WE = '1') then
			memory(to_integer(unsigned(WA))) <= WD;
		END IF;
	END IF;
	
END PROCESS;

RD1 <= memory(to_integer(unsigned(RA1)));
RD2 <= memory(to_integer(unsigned(RA2)));

END Register_File_arch;




