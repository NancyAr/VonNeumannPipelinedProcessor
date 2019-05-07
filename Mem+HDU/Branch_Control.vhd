LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith;
USE IEEE.numeric_std.all;
entity Branch_Control is
port(JZ, JN, JC, JMP,carry,negative,zero: in std_logic;
RstC,RstZ,RstN,PCsrc: out std_logic
);
end entity;
Architecture Branch_controlArch of Branch_Control is
begin
RstC <= carry and JC;
RstZ <= zero and JZ;
RstN <= negative and JN;

PCsrc <= JMP or (negative and JN) or ((zero and JZ) or (negative and JN));

end Architecture;