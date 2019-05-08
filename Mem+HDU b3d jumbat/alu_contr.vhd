Library ieee;
USE ieee.std_logic_1164.ALL;

Entity alu_contr is
Port(
OPCode	: in std_logic_vector(4 downto 0);
aluCode	: out std_logic_vector(3 downto 0);
aluCin : out std_logic);
End Entity alu_contr;

Architecture model_alu_contr of alu_contr is
Begin
	aluCode <= "0000" when OPCode = "01101" else	--MOV --Output is the Rsrc Value
		   "0001" when OPCode = "00110" else	--Add
		   "0010" when OPCode = "00111" else	--Sub
		   "0100" when OPCode = "01001" else	--AND
		   "0101" when OPCode = "01010" else	--OR
		   --"1110" when OPCode = "00110" else	--RLC
		   --"1010" when OPCode = "00111" else	--RRC
		   "1100" when OPCode = "01011" else	--SHL
		   "1000" when OPCode = "01100" else	--SHR
		   "0111" when OPCode = "00011" else	--NOT
		   --"0011" when OPCode = "10001" else 	--Neg
		   "0000" when OPCode = "00100" else	--INC
		   "0011" when OPCode = "00101" else	--DEC
		   "1001" when OPCode = "01000" else --MUL
		   "1111"; --Output is the Rdst Value

	aluCin <= '1' when (OPCode = "00111" or OPCode = "00100") 
	else '0';

End Architecture model_alu_contr;

