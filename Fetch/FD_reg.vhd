library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FD_reg is
port( 	
		--inputs
		clk: in std_logic;
		flush: in std_logic;
		stall: in std_logic;
		instruction: in std_logic_vector(15 downto 0);
		immediate: in std_logic_vector(15 downto 0);
		PC_address_in: in std_logic_vector(15 downto 0);
		--outputs
		opcode: out std_logic_vector(4 downto 0);
		RA1: out std_logic_vector(2 downto 0);
		RA2: out std_logic_vector(2 downto 0);
		WA: out std_logic_vector(2 downto 0);
		PC_address_out: out std_logic_vector(15 downto 0);
		imm_out: out std_logic_vector(15 downto 0)
	);	
end entity;


architecture FD_arch OF FD_reg IS
BEGIN

PROCESS(clk,flush)
BEGIN

	IF (flush= '1' AND rising_edge(clk)) then
			opcode <= "00000";
			RA1 <= "000";
			RA2 <= "000";
			WA <= "000";
			PC_address_out <= PC_address_in;
			imm_out <= (others => '0');

	ELSIF rising_edge(clk) then
		IF (stall = '0') then
			opcode <= instruction(15 downto 11);
			RA1 <= instruction(7 downto 5);
			RA2 <= instruction(4 downto 2);
			WA <= instruction(10 downto 8);
			PC_address_out <= PC_address_in;
			imm_out <= immediate;
		END IF;
	END IF;
	
END PROCESS;

end architecture;