library ieee;
use ieee.std_logic_1164.all;

entity CCR_sec is
port( Clk, WriteTempCCR: in std_logic;
CoutCCR, ZeroCCR, NegCCR, OverflowCCR: in std_logic;
Cout, Zero, Neg, Overflow: out std_logic);
end entity;

architecture model_CCR_sec of CCR_sec is

--writetempccr here is probaby interrupt signal but not sure


signal carryFlag, zeroFlag, negativeFlag, overflowFlag: std_logic;

begin
	process(Clk)
		begin		
			if(rising_edge(Clk)) then					
					if(WriteTempCCR = '1') then
  						 carryFlag <= CoutCCR;
			  		  	 zeroFlag <= ZeroCCR;
			 		  	 negativeFlag <= NegCCR;
			  		  	 overflowFlag <= OverflowCCR;
					end if;			
			end if;		
		end process;
		 Cout <= carryFlag;
		 Zero<= zeroFlag;
		 Neg <= negativeFlag;
     		Overflow <= overflowFlag;
end architecture ;
