Library ieee;
USE ieee.std_logic_1164.ALL;

Entity CU is
Port(
OPCode	: in std_logic_vector(4 downto 0);
MemRead, MemWrite: in std_logic;
PCWrite, SETC, CLRC, ALUOp, PortOut, PortIn, MemFlag: out std_logic);
End Entity;

Architecture Behavioral of CU is
begin
PCWrite <= '1' when OPCode = "00000" else '0';
SETC <= '1'  when OPCode = "00001" else '0';
CLRC <= '1'  when OPCode = "00010" else '0';
ALUOp <= '1' when OPCode = "00001" or OPCode = "00010" or OPCode = "00011" or OPCode = "00100" or OPCode = "00101" else '0';
PortOut <= '1' when OPCode = "01110" else '0';
PortIn <= '1' when OPCode = "01111" else '0';
MemFlag <= '1' when MemRead = '1' or MemWrite = '1' else '0';
end Architecture;