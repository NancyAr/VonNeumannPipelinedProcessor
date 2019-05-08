library ieee;
use ieee.std_logic_1164.all;

entity CCR_main is
port( Clk, RST, WriteCCR, SETC, CLRC, CoutAlu, ZeroAlu, NegAlu, OverflowAlu: in std_logic;
CoutTempCCR, ZeroTempCCR, NegTempCCR, OverflowTempCCR: in std_logic;
Cout, Zero, Neg, Overflow: out std_logic);
end entity;

architecture main_model_ccr of CCR_main is

signal carryFlag, zeroFlag, negativeFlag, overflowFlag: std_logic;

begin
	process(Clk, RST)
		begin
			if(RST = '1')
				then
		    	    carryFlag <= '0';
			    zeroFlag <= '0';
			    negativeFlag <= '0';
			    overflowFlag <= '0';
				
			
			elsif(rising_edge(Clk) ) then
					if(SETC = '1') then
						carryFlag <= '1';
					elsif(CLRC = '1') then
						carryFlag <= '0';
					elsif(WriteCCR = '1') then
  						 carryFlag <= CoutTempCCR;
			  		  	 zeroFlag <= ZeroTempCCR;
			 		  	 negativeFlag <= NegTempCCR;
			  		  	 overflowFlag <= OverflowTempCCR;
					else
						carryFlag <= CoutAlu;
					    zeroFlag <= ZeroAlu;
					    negativeFlag <= NegAlu;
			   			overflowFlag <= OverflowAlu;	
					end if;			
			end if;
		
		end process;
		 Cout <= carryFlag;
		 Zero<= zeroFlag;
		 Neg <= negativeFlag;
     		Overflow <= overflowFlag;
end architecture;