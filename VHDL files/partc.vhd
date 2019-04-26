Library ieee;
use ieee.std_logic_1164.all;

entity partc is
  generic (n :integer:=8);
  
port( 
a,b : in std_logic_vector (n-1 downto 0);
s : in std_logic_vector (1 downto 0);
Cin : in std_logic;
Cout,Zero,Neg : out std_logic;
f : out std_logic_vector (n-1 downto 0));

end entity;
Architecture Modelc of partc is
  signal Wresult,zeros : std_logic_vector (n-1 downto 0);
  
  
begin
  f <= '0' & a(n-1 downto 1) when s= "00"
else a(0) & a(n-1 downto 1) when s= "01"
else Cin & a(n-1 downto 1) when s= "10"
else a(n-1) & a(n-1 downto 1) when s= "11";
  
Cout <= a(0) when s="00"
else a(0) when s="01"
else a(0) when s="10" 
else a(0) when s="11" ;
  
zeros<= (others=>'0') ;
  
  Zero <= '1' when (Wresult(n-1 downto 0)= zeros) else
        '0';

Neg <= Wresult(15);
 f<= Wresult;   
  
end Architecture;
