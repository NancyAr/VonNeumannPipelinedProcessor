Library ieee;
use ieee.std_logic_1164.all;

entity partd is
  generic (n :integer:=8);
  
port( 
a,b : in std_logic_vector (n-1 downto 0);
s : in std_logic_vector (1 downto 0);
Cin : in std_logic;
Cout,Zero,Neg : out std_logic;
f : out std_logic_vector (n-1 downto 0));

end entity;
Architecture Modeld of partd is
  
  signal Wresult,zeros : std_logic_vector (n-1 downto 0);
begin
  Wresult <= a(n-2 downto 0) & '0' when s= "00"
else a(n-2 downto 0) & a(n-1) when s= "01"
else a(n-2 downto 0) & Cin when s= "10"
else (others=> '0') when s= "11";
  
Cout <= a(n-1) when s="00"
else a(n-1) when s="01"
else a(n-1) when s="10" 
else '0' when s="11" ;
  
  
 zeros<= (others=>'0') ;
  
  Zero <= '1' when (Wresult(n-1 downto 0)= zeros) else
        '0';

Neg <= Wresult(15);
 f<= Wresult;   
end Architecture;

