library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_Decoder is
port(
    --inputs
    instruction : in std_logic_vector(15 downto 0);
    IM_3        : in std_logic_vector(15 downto 0);
    PC_Src      : in std_logic;
    invalid_mem : in std_logic;
    SP_exception: in std_logic;
    reset       : in std_logic;
    stall       : in std_logic;
    --outputs
    PC_selector : out std_logic_vector(2 downto 0);
    interrupt   : out std_logic_vector(15 downto 0)
    ); 
end entity;

ARCHITECTURE PC_Decoder_arch OF PC_Decoder IS
signal bit_10: std_logic_vector(15 downto 0);
BEGIN
PROCESS(stall, instruction, PC_Src, invalid_mem, SP_exception, reset)
BEGIN
    IF (reset = '1') then
        PC_selector <= "100";
    ELSIF (SP_exception = '1') then
        PC_selector <= "101";
    ELSIF (invalid_mem = '1') then
        PC_selector <= "110";
    ELSIF (PC_Src = '1') then
        PC_selector <= "011";
    ELSIF (instruction(15 downto 11) > "01000" and instruction(15 downto 11) < "01101") then
        PC_selector <= "010";
    ELSIF ((instruction(15 downto 11) = "00001")  or (stall = '1'))then
        PC_selector <= "000";
    ELSIF (instruction(15 downto 11) = "10110") then
        PC_selector <= "111";
    ELSE 
        PC_selector <= "001";
    END IF;
END PROCESS;
bit_10(0) <= instruction(10) ;
bit_10(15 downto 1) <= (others => '0');
interrupt <= std_logic_vector(unsigned(IM_3) + unsigned(bit_10));
END PC_Decoder_arch;