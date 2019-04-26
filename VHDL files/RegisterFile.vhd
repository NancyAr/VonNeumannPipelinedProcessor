Library ieee;
Use ieee.std_logic_1164.all;


Entity RegFile is
port( 
	Clk,Rst,RegWrite : in std_logic;
	Rsrc, Rdst, WriteAdress: in std_logic_vector(2 downto 0);
	WriteData1, WriteData2: in std_logic_vector(15 downto 0);
	RsrcOut, RdstOut1, RdstOut2: out std_logic_vector(15 downto 0));
end Entity;

Architecture dataflow of RegFile is

Component Reg16bit is
port( Clk : in std_logic;
Rst : in std_logic;
d : in std_logic_vector(15 downto 0);
q : out std_logic_vector(15 downto 0));
end Component;

signal d0, d1, d2, d3, d4, d5, d6, d7: std_logic_vector(15 downto 0):="0000000000000000";
signal q0, q1, q2, q3, q4, q5, q6, q7: std_logic_vector(15 downto 0);

begin

	r0:Reg16bit port map(Clk, Rst, d0, q0);
	r1:Reg16bit port map(Clk, Rst, d1, q1);
	r2:Reg16bit port map(Clk, Rst, d2, q2);
	r3:Reg16bit port map(Clk, Rst, d3, q3);
	r4:Reg16bit port map(Clk, Rst, d4, q4);
	r5:Reg16bit port map(Clk, Rst, d5, q5);
	r6:Reg16bit port map(Clk, Rst, d6, q6);
	r7:Reg16bit port map(Clk, Rst, d7, q7);
	
	d0<=WriteData1 when WriteAdress = "000" and RegWrite='1' ;
	d1<=WriteData1 when WriteAdress = "001" and RegWrite='1' ;
	d2<=WriteData1 when WriteAdress = "010" and RegWrite='1' ;
	d3<=WriteData1 when WriteAdress = "011" and RegWrite='1' ;
	d4<=WriteData1 when WriteAdress = "100" and RegWrite='1' ;
	d5<=WriteData1 when WriteAdress = "101" and RegWrite='1' ;
	d6<=WriteData1 when WriteAdress = "110" and RegWrite='1' ;
	d5<=WriteData1 when WriteAdress = "111" and RegWrite='1' ;

 	RsrcOut<= q0 when Rsrc="000" else
	  q1 when Rsrc="001" else
	  q2 when Rsrc="010" else
	  q3 when Rsrc="011" else
	  q4 when Rsrc="100" else
	  q5 when Rsrc="101" else
	  q6 when Rsrc="110" else
		q7 when Rsrc="111";


	RdstOut1<= q0 when Rdst="000" else
	  q1 when Rdst="001" else
	  q2 when Rdst="010" else
	  q3 when Rdst="011" else
	  q4 when Rdst="100" else
	  q5 when Rdst="101" else
	  q6 when Rdst="110" else
	  q7 when Rdst="111";

	--RdstOut2<= q0 when Rdst="000" else
	--  q1 when Rdst="001" else
	--  q2 when Rdst="010" else
	--  q3 when Rdst="011" else
	--  q4 when Rdst="100" else
	 -- q5 when Rdst="101";
 
	
	--d0<=WriteData2 when WriteAdress="000" and RegWrite='1' ;
	--d1<=WriteData2 when WriteAdress="001" and RegWrite='1' ;
	--d2<=WriteData2 when WriteAdress="010" and RegWrite='1' ;
	--d3<=WriteData2 when WriteAdress="011" and RegWrite='1' ;
	--d4<=WriteData2 when WriteAdress="100" and RegWrite='1' ;
	--d5<=WriteData2 when WriteAdress="101" and RegWrite='1' ;

end Architecture;
