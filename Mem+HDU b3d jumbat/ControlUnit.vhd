Library ieee;
USE ieee.std_logic_1164.ALL;

Entity CU is
Port(
OPCode	: in std_logic_vector(4 downto 0);
mReadbuff, mWritebuff : in std_logic;
Writeback: out std_logic_vector(1 downto 0);
MemRead, MemWrite, isMul: out std_logic;
PCWrite, SETC, CLRC, ALUOp, PortOut, PortIn, MemFlag, Reg_Write, JZ, JN, JC, JMP : out std_logic); --signals added for branch operations
End Entity;

Architecture Behavioral of CU is
 
Signal mem_read, mem_write, mem_flag, instr: std_logic;

begin
SETC <= '1'  when OPCode = "00001" else '0';
CLRC <= '1'  when OPCode = "00010" else '0';
isMul <= '1'  when OPCode = "01000" else '0';
Reg_Write <= '1' when OPCode = "01101" or  OPCode = "00110" or OPCode = "00111" or OPCode = "01001" or OPCode = "01010" or OPCode = "01000" or OPCode = "01011" or OPCode = "01100" or OPCode = "10010" or OPCode = "10011" or OPCode = "00100" or OPCode = "00101" or OPCode = "10001" else '0';
Writeback <= "10" when OPCode = "01101" else "01" when OPCode = "00110" or OPCode = "00111" or OPCode = "01001" or OPCode = "01010" or OPCode = "01000"  or OPCode = "01011" or OPCode = "01100" or OPCode = "10010" or OPCode = "00100" or OPCode = "00101"
else "00" when OPCode = "10011" or OPCode = "10001";
ALUOp <= '1' when OPCode = "00001" or OPCode = "00010" or OPCode = "00011" or OPCode = "00100" or OPCode = "00101" else '0';
PortOut <= '1' when OPCode = "01110" else '0';
PortIn <= '1' when OPCode = "01111" else '0';
mem_flag <= '1' when mReadbuff = '1' or mWritebuff = '1' else '0';
MemFlag <= mem_flag;
MemRead <= '1' when OPCode = "10011" or OPCode = "10001" or OPCode = "11010" or OPCode = "11100" else '0';
MemWrite <= '1' when OPCode = "10100" or OPCode = "10000" or OPCode = "11001" else '0';
--------------branch output--------------
JZ <= '1' when OPCode ="10101" else '0';
JN <='1' when OPCode ="10110" else '0';
JC <='1' when OPCode ="10111" else '0';
JMP <='1' when OPCode ="11000" else '0';

--PCWrite <= '1' when mem_flag = '1' or instr = '1' else '0';

end Architecture;