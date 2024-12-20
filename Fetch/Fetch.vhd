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
begin


end architecture; 