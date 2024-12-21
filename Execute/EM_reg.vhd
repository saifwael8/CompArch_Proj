library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EM_reg is
port( clk: in std_logic;
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
end entity;


architecture EM_reg_arch OF EM_reg IS
BEGIN

PROCESS(clk,flush)
BEGIN

	IF (flush= '1' AND rising_edge(clk)) then
			Control_Bus_out <= (others => '0');

	ELSIF rising_edge(clk) then
		IF (stall = '0') then
			Control_Bus_out <= Control_Bus;
			RD2_out <= RD2;
			WA_out <= WA;
			PC_1_out <= PC_1;
			ALU_out <= ALU_Result;
			PCSrc_out <= PCSrc;
		END IF;
	END IF;
	
END PROCESS;

end architecture;