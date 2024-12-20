library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MWB_reg is
port( clk: in std_logic;
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
end entity;


architecture MWB_arch OF MWB_reg IS
BEGIN

PROCESS(clk)
BEGIN

	IF rising_edge(clk) then
		IF (stall = '0') then
			Control_Bus_out <= Control_Bus;
			From_Memory_out <= From_Memory;
			From_ALU_out <= From_ALU;
			WA_out <= WA;
			PCSrc_out <= PCSrc;
		END IF;
	END IF;
	
END PROCESS;

end architecture;