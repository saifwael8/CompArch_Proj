library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_Mux is 
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
end entity;

ARCHITECTURE PC_Mux_arch OF PC_Mux IS
BEGIN
if selector = "000" then
    address <= PC;
elsif selector = "001" then
    address <= PC_plus1;
elsif selector = "010" then
    address <= PC_`lus2;;
elsif selector = "011" then
    address <= jump;
elsif selector = "100" then
    address <= IM_0;
elsif selector = "101" then
    address <= IM_1;
elsif selector = "110" then
    address <= IM_2;
elsif selector = "111" then
    address <= interrupt;
end if;
END PC_Mux_arch;
end architecture;