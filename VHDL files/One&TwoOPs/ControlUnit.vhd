Library ieee;
USE ieee.std_logic_1164.ALL;

Entity CU is
Port(
OPCode	: in std_logic_vector(4 downto 0);
Writeback: out std_logic_vector(1 downto 0);
MemRead, MemWrite, Inst32: out std_logic;
PCWrite, SETC, CLRC, ALUOp, PortOut, PortIn, MemFlag, Reg_Write : out std_logic);
End Entity;

Architecture Behavioral of CU is

Signal mem_read, mem_write: std_logic;

begin
PCWrite <= '1' when OPCode = "00000" else '0';
SETC <= '1'  when OPCode = "00001" else '0';
CLRC <= '1'  when OPCode = "00010" else '0';
Inst32 <= '1' when OPCode = "01011" or  OPCode = "01100" else '0'; --SHL SHR
Reg_Write <= '1' when OPCode = "01101" or  OPCode = "00110" or OPCode = "00111" or OPCode = "01001" or OPCode = "01010" or OPCode = "01000" or OPCode = "01011" or OPCode = "01100" else '0';
Writeback <= "10" when OPCode = "01101" else "01" when OPCode = "00110" or OPCode = "00111" or OPCode = "01001" or OPCode = "01010" or OPCode = "01000"  or OPCode = "01011" or OPCode = "01100" else "00";
ALUOp <= '1' when OPCode = "00001" or OPCode = "00010" or OPCode = "00011" or OPCode = "00100" or OPCode = "00101" else '0';
PortOut <= '1' when OPCode = "01110" else '0';
PortIn <= '1' when OPCode = "01111" else '0';
MemFlag <= '1' when mem_read = '1' or mem_write = '1' else '0';

end Architecture;