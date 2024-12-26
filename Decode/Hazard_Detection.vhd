library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Hazard_Detection is 
port(
    clk: in std_logic;
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
signal curr_stall : std_logic := '0';
signal stall_pulse : std_logic := '0';
begin
Flush_exc <= exception; 
PROCESS (clk)
begin
    if rising_edge(clk) then
        if ( (FD_RA1 = DE_WA or FD_RA2 = DE_WA) and DE_MR = '1' ) then
            curr_stall <= '1';
        else
            curr_stall <= '0';
        end if;
    end if;
end PROCESS;

stall <= curr_stall;
end Architecture;
