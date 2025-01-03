library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Exception_Handler is 
port( 
	clk, SP_enable, SInc, MR, MW	: in std_logic; 
	SP_Address, Memory_Address: in std_logic_vector(15 downto 0);
	Save_EPC, SP_Exception, Memory_Exception: out std_logic); 
	
end entity; 

ARCHITECTURE Exception_Handler_arch OF Exception_Handler IS

signal EPC_saved, SP_Exception_saved, Memory_Exception_saved : std_logic := '0';
signal max_mem_address: std_logic_vector(15 downto 0) := "0000111111111111";

BEGIN

PROCESS(SP_Address, Memory_Address, SP_enable, SInc)
BEGIN

		IF SP_enable = '1' and SInc = '1' and SP_Address = "0000111111111111" then
			EPC_saved <= '1';
			SP_Exception_saved <= '1';
			Memory_Exception_saved <= '0'; -- PC <= IM[1];
		
		ELSIF ((unsigned(Memory_Address) > unsigned(max_mem_address))) then -- and (mw = 1 or mr = 1)
			EPC_saved <= '1';
			SP_Exception_saved <= '0';
			Memory_Exception_saved <= '1'; -- PC <= IM[2];
		ELSE
			EPC_saved <= '0';
			SP_Exception_saved <= '0';
			Memory_Exception_saved <= '0';
		END IF;
	
END PROCESS;
Save_EPC <= EPC_saved;
SP_Exception <= SP_Exception_saved;
Memory_Exception <= Memory_Exception_saved;
END Exception_Handler_arch;