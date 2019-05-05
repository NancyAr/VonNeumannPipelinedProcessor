Library ieee;
use ieee.std_logic_1164.all;

entity partb is
  generic (n :integer:=16);
  
port( 
a,b : in std_logic_vector (n-1 downto 0);
s : in std_logic_vector (1 downto 0);
Zero,Neg : out std_logic;
f : out std_logic_vector (n-1 downto 0));

end entity;
Architecture Modelb of partb is
  
  signal Wresult,zeros : std_logic_vector (n-1 downto 0);
begin
  Wresult <= (a and b) when s= "00"
else (a or b) when s= "01"
else (a nor b) when s= "10"
else not a when s= "11";
  
zeros<= (others=>'0') ;
  
  Zero <= '1' when (Wresult(n-1 downto 0)= zeros) else
        '0';

Neg <= Wresult(n-1);
 f<= Wresult; 
  
  
end Architecture;
