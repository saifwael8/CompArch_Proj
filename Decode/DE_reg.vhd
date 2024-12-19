library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE_reg is
port( clk: in std_logic;
		flush: in std_logic;
		stall: in std_logic;

		Control_Bus: in std_logic_vector(24 downto 0);
		RD1: in std_logic_vector(15 downto 0);
		RD2: in std_logic_vector(15 downto 0);
		Imm: in std_logic_vector(15 downto 0);
		RA1: in std_logic_vector(2 downto 0);
		RA2: in std_logic_vector(2 downto 0);
		WA: in std_logic_vector(2 downto 0);
		PC_1: in std_logic_vector(15 downto 0);

		Control_Bus_out: out std_logic_vector(24 downto 0);
		RD1_out: out std_logic_vector(15 downto 0);
		RD2_out: out std_logic_vector(15 downto 0);
		Imm_out: out std_logic_vector(15 downto 0);
		RA1_out: out std_logic_vector(2 downto 0);
		RA2_out: out std_logic_vector(2 downto 0);
		WA_out: out std_logic_vector(2 downto 0);
		PC_1_out: out std_logic_vector(15 downto 0)
);
end entity;


architecture DE_arch OF DE_reg IS
BEGIN

PROCESS(clk,flush)
BEGIN

	IF (flush= '1' AND rising_edge(clk)) then
			Control_Bus_out <= (others => '0');

	ELSIF rising_edge(clk) then
		IF (stall = '0') then
			Control_Bus_out <= Control_Bus;
			RD1_out <= RD1;
			RD2_out <= RD2;
			Imm_out <= Imm;
			RA1_out <= RA1;
			RA2_out <= RA2;
			WA_out <= WA;
			PC_1_out <= PC_1;
		END IF;
	END IF;
	
END PROCESS;

end architecture;