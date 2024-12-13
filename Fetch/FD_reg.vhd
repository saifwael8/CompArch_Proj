library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FD_reg is
port( clk: in std_logic;
		rst: in std_logic;
		enable: in std_logic;
		instruction: in std_logic_vector(15 downto 0);
		opcode: out std_logic_vector(2 downto 0);
		src1: out std_logic_vector(2 downto 0);
		src2: out std_logic_vector(2 downto 0);
		dst: out std_logic_vector(2 downto 0));
			
end entity;


architecture FD_arch OF FD_reg IS
BEGIN

PROCESS(clk,rst)
BEGIN

	IF (rst= '0' AND rising_edge(clk)) then
			opcode <= "000";
			src1 <= "000";
			src2 <= "000";
			dst <= "000";

	ELSIF rising_edge(clk) then
		IF (enable = '1') then
			opcode <= instruction(2 downto 0);
			src1 <= instruction(5 downto 3);
			src2 <= instruction(8 downto 6);
			dst <= instruction(11 downto 9);
		else
			opcode <= "000";
		END IF;
	END IF;
	
END PROCESS;

end architecture;