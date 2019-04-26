Library ieee;
use ieee.std_logic_1164.all;

entity parta is
  generic (n :integer:=8);
  
port( 
a,b : in std_logic_vector (n-1 downto 0);
sel : in std_logic_vector (1 downto 0);
Cin : in std_logic;
Cout,Zero,Neg : out std_logic;
sum : out std_logic_vector (n-1 downto 0));

end entity;
Architecture Modela of parta is
component mynbit is
generic (n :integer:=8);
port(a,b : in std_logic_vector (n-1 downto 0);
cin : in std_logic;
sum: out std_logic_vector(n-1 downto 0);
cout : out std_logic);
end component;  
signal Ws1,Ws2,Ws3,Ws4 : std_logic_vector (n-1 downto 0);
signal Wcout1,Wcout2,Wcout3,Wcout4 : std_logic;  
signal Wmux:std_logic_vector (n-1 downto 0) ;  
signal notb:std_logic_vector (n-1 downto 0) ; 
signal Wsum,zeros:std_logic_vector (n-1 downto 0) ; 
begin
notb <= (not b);
Wmux <= (others=>'1') when cin='0'
else  not a when cin='1';
A1: mynbit generic map(8) port map(a,(others=>'0'),cin,Ws1,Wcout1);
A2: mynbit generic map(8) port map(a,b,cin,Ws2,Wcout2);
A3: mynbit generic map(8) port map(a,notb,cin,Ws3,Wcout3);
A4: mynbit generic map(8) port map(a,Wmux,cin,Ws4,Wcout4);
Wsum <= Ws1 when sel(1)='0' and sel(0)='0'
 else Ws2 when sel(1)='0' and sel(0)='1'
 else Ws3 when sel(1)='1' and sel(0)='0'
 else Ws4 when sel(1)='1' and sel(0)='1';
   
  cout <= Wcout1 when sel(1)='0' and sel(0)='0'
 else Wcout2 when sel(1)='0' and sel(0)='1'
 else Wcout3 when sel(1)='1' and sel(0)='0'
 else Wcout4 when sel(1)='1' and sel(0)='1';
zeros<= (others=>'0') ;
  
  Zero <= '1' when (Wsum(n-1 downto 0)= zeros) else
        '0';Neg <= Wsum(n-1);
sum<=Wsum;

end Architecture;

