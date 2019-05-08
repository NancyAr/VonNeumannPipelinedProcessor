Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
entity alu is
  generic (n :integer:=16);
port( 
a,b : in std_logic_vector (n-1 downto 0);
s : in std_logic_vector (3 downto 0);
f : out std_logic_vector (n-1 downto 0);
mult: out std_logic_vector (31 downto 0);
cin : in std_logic;
cout : out std_logic;
zero,neg,ovrflw : out std_logic
);

end entity;
Architecture Modelalu of alu is
  component parta is
    generic (n :integer:=16);
port( 
a,b : in std_logic_vector (n-1 downto 0);
sel : in std_logic_vector (1 downto 0);
Cin : in std_logic;
Cout,Zero,Neg,ovrflw : out std_logic;
sum : out std_logic_vector (n-1 downto 0));
    
    
  end component;
component partb is
  generic (n :integer:=16);
  port( 
a,b : in std_logic_vector (n-1 downto 0);
s : in std_logic_vector (1 downto 0);
Zero,Neg : out std_logic;
f : out std_logic_vector (n-1 downto 0));
end component;


component partc is
  generic (n :integer:=16);
  port( 
a,b : in std_logic_vector (n-1 downto 0);
s : in std_logic_vector (1 downto 0);
Cin : in std_logic;
Cout,Zero,Neg : out std_logic;
f : out std_logic_vector (n-1 downto 0));
end component;


component partd is
  generic (n :integer:=16);
port( 
a,b : in std_logic_vector (n-1 downto 0);
s : in std_logic_vector (1 downto 0);
Cin : in std_logic;
Cout,Zero,Neg : out std_logic;
f : out std_logic_vector (n-1 downto 0)); 
end component;

signal Wfa,Wfb,Wfc,Wfd : std_logic_vector (n-1 downto 0);
Signal MulOut: std_logic_vector (31 downto 0);
Signal Wcouta,Wcoutc,Wcoutd : std_logic;
signal Wna,Wnb,Wnc,Wnd : std_logic;
signal Wza,Wzb,Wzc,Wzd : std_logic;
signal OFa : std_logic;
signal selct : std_logic_vector (1 downto 0);
Begin 
  selct <= s(1 downto 0);
U0 : partb generic map (16) port map (a,b,selct,Wzb,Wnb,Wfb);
U1 : partc generic map (16) port map (a,b,selct,cin,Wcoutc,Wzc,Wnc,Wfc);
U2 : partd generic map (16) port map (a,b,selct,cin,Wcoutd,Wzd,Wnd,Wfd);
U3 : parta generic map (16) port map(a,b,selct,cin,Wcouta,Wza,Wna,OFa,Wfa);

MulOut <= std_logic_vector(to_unsigned((to_integer(unsigned(a)) * to_integer(unsigned(b))),32)) ;

mult<= MulOut when s(3) = '1' and s(2) = '0' and s(1) = '0' and s(0) = '1' else (others=>'0');

F <= Wfb when s(3)='0' and s(2)='1'
else Wfc when s(3)='1' and s(2)='0'
else Wfd when s(3)='1' and s(2)='1'
else Wfa when s(3)='0' and s(2)='0';

cout <= Wcoutc when s(3)='1' and s(2)='0'
else '0' when s(3)='0' and s(2)='1'
else Wcouta when s(3)='0' and s(2)='0'
else Wcoutd when s(3)='1' and s(2)='1';



zero <= Wzc when s(3)='1' and s(2)='0'
else Wzb when s(3)='0' and s(2)='1'
else Wza when s(3)='0' and s(2)='0'
else Wzd when s(3)='1' and s(2)='1';  

neg <= Wnc when s(3)='1' and s(2)='0'
else Wnb when s(3)='0' and s(2)='1'
else Wna when s(3)='0' and s(2)='0'
else Wnd when s(3)='1' and s(2)='1';
  ovrflw <= ofa when s(3)='0' and s(2)='1'
else '0';
  
end architecture;
