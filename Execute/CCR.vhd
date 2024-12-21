library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CCR is
port( clk: in std_logic;
		Input_Flags_ALU, Input_Flags_Restore: in std_logic_vector(2 downto 0); -- assume ZF is CCR(2), CF is CCR(1), NF is CCR(0)
		ZW, CW, NW, SetC, SelFlag, EM_RTI: in std_logic;
		Output_Flags: out std_logic_vector(2 downto 0)
);

end entity;



architecture CCR_arch of CCR is
signal Input_Flags_Signal, Input_Flag_Zeros, Flags : std_logic_vector(2 downto 0) := "000";
signal selector : std_logic_vector(1 downto 0) := "00";
begin
selector <= SelFlag & EM_RTI;
Input_Flag_Zeros(1) <= SetC;

with selector select Input_Flags_Signal <= 
	Input_Flags_ALU when "10",
	Input_Flags_Restore when "11",
	Input_Flags_Restore when "01",
	Input_Flag_Zeros when "00",
	"000" when others;
	
process(clk)
begin 
if(rising_edge(clk)) then
	if(ZW = '1') then
		Flags(2) <= Input_Flags_Signal(2);
	end if;
	if(CW = '1') then
		Flags(1) <= Input_Flags_Signal(1);
	end if;
	if(NW = '1') then
		Flags(0) <= Input_Flags_Signal(0);
	end if;
end if;
end process;

Output_Flags <= Flags;
end architecture CCR_arch;