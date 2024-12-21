library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_Mux is 
 
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
end entity;

ARCHITECTURE PC_Mux_arch OF PC_Mux IS
BEGIN
with selector select
    address <= PC when "000",
               PC_plus1 when "001",
               PC_plus2 when "010",
               jump when "011",
               IM_0 when "100",
               IM_1 when "101",
               IM_2 when "110",
               interrupt when "111",
               (others => '0') when others;
END PC_Mux_arch;
