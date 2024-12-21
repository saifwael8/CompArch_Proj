library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Forwarding_Unit is
port( DE_RA1, DE_RA2: in std_logic_vector(2 downto 0);
		EM_WA, MWB_WA: in std_logic_vector(2 downto 0);
		EM_WB, MWB_WB: in std_logic;
		OP1_Selector, OP2_Selector: out std_logic_vector(1 downto 0)
		
);
end entity;

architecture Forwarding_Unit_arch of Forwarding_Unit is

begin

process(DE_RA1, DE_RA2, EM_WA, MWB_WA, EM_WB, MWB_WB)
begin
if((EM_WB = '1') and (EM_WA = DE_RA1)) then
	OP1_Selector <= "10"; -- ALU_to_ALU
elsif ((MWB_WB = '1') and (MWB_WA = DE_RA1)) then 
	OP1_Selector <= "01"; -- Mem_to_ALU
else OP1_Selector <= "00";
end if;
	
if((EM_WB = '1') and (EM_WA = DE_RA2)) then
	OP2_Selector <= "10"; -- ALU_to_ALU
elsif ((MWB_WB = '1') and (MWB_WA = DE_RA2)) then 
	OP2_Selector <= "01"; -- Mem_to_ALU
else OP2_Selector <= "00";
end if;




end process;
end architecture;