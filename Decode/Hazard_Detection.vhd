library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Hazard_Detection is 
port(
    exception: in std_logic;
    FD_RA1: in std_logic_vector(2 downto 0);
    FD_RA2: in std_logic_vector(2 downto 0);
    DE_WA: in std_logic_vector(2 downto 0);
    DE_MR: in std_logic;

    stall: out std_logic;
    Flush_exc: out std_logic
);
end entity;

architecture HD_arch of Hazard_Detection is 

begin

Flush_exc <= exception; --flush if an exception occurs

--- Load Use Hazard Detection ------
PROCESS (FD_RA1,FD_RA2,DE_WA,DE_MR)
begin

    IF ( (FD_RA1=DE_WA OR FD_RA2=DE_WA) AND DE_MR = '1' ) then
        stall <= '1';
    else
        stall <= '0';
    end if;

end PROCESS;

end architecture;