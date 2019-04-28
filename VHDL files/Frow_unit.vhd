
Library ieee;
Use ieee.std_logic_1164.all;

entity ForwUnit is
port( 	Rdst,Rsrc,Ex_Mem_Rdst,Mem_WB_Rdst,Rdst1M,Rdst2M : in std_logic_vector (2 downto 0);
  WB1,WB2,Mult : in std_logic;
	Mux_DST, Mux_SRC : out std_logic_vector(1 downto 0));
end entity;

-- RDST1M and RDST2M are due to multiplication operation is 32 bits so it's divided on two registers

Architecture model_FU of ForwUnit is

Begin

	Mux_DST <= "10" when (Rdst=Ex_Mem_Rdst and WB1='1')
	         else "01" when (Rdst=Mem_WB_Rdst and WB2='1') 
	         else "11" when (Rdst= Rdst1M and Mult='1') 
	           else "00";
	
	Mux_SRC <= "10" when (Rsrc=Ex_Mem_Rdst and WB1='1')
	         else "01" when (Rsrc=Mem_WB_Rdst and WB2='1') 
	         else "11" when (Rsrc= Rdst2M and Mult='1') 
	           else "00";
		
End Architecture;