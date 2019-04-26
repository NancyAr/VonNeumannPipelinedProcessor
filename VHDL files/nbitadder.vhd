Library ieee;
use ieee.std_logic_1164.all;

entity mynbit is
generic (n :integer:=16);
port(a,b : in std_logic_vector (n-1 downto 0);
cin : in std_logic;
sum: out std_logic_vector(n-1 downto 0);
cout : out std_logic;
Ovrflw : out std_logic
);
  
end mynbit;

architecture modelmynbit of mynbit is

component my_adder is 
  port (a,b,cin: in std_logic;
  sum,cout : out std_logic);
  end component;
  signal temp: std_logic_vector(n downto 0);
  begin
  loop1: for i in 0 to n-1 generate
  fx: my_adder port map(a(i),b(i),temp(i),sum(i),temp(i+1));
 end generate;
 temp(0)<=cin;
 cout<=temp(n); 
  Ovrflw <= '1' when temp(n)/= temp(n-1) else
	 '0';
end architecture ;