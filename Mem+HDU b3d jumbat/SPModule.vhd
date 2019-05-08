Library ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith;

Entity SPModule is
Port(
Clk, Rst, MemWrite, SPSel, Call, Ret: in std_logic;
SP : out std_logic_vector(31 downto 0));
End Entity;

Architecture SPModule_Arch of SPModule is
signal wSP, SPout : std_logic_vector(31 downto 0);

Begin
	process(Clk, Rst, SPSel, MemWrite) is
	begin
		if (Rst = '1')  then
			--wSP <= "11111111111111111111111111111111";
			  wSP <= "00000000000000000000000000000001";
		elsif (rising_edge(Clk)) then
			wSP <= SPout;
		end if;
	end process;

	SP <= 	wSP when SPSel = '1' and MemWrite = '1' else	--Push
		wSP + "00000000000000000000000000000010" when SPSel = '1' and MemWrite = '0' and Ret = '1'  else	--ret
		wSP + "00000000000000000000000000000001" when SPSel = '1' and MemWrite = '0' and Ret = '0' else	--Pop
		wSP;

	SPout  <=  	wSP - "00000000000000000000000000000010" when SPSel = '1' and MemWrite = '1' and Call = '1' else	--call
		  	wSP - "00000000000000000000000000000001" when SPSel = '1' and MemWrite = '1' and Call = '0' else	--Push
		  	wSP + "00000000000000000000000000000010" when SPSel = '1' and MemWrite = '0' and Ret = '1'  else	--ret
			wSP + "00000000000000000000000000000001" when SPSel = '1' and MemWrite = '0'   else	--Pop
		  wSP;

End Architecture;
