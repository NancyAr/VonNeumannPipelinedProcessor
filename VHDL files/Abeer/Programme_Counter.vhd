LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Programme_Counter is
	generic (n :integer:=32);
	port( Address_IN: in std_logic_vector (n-1 downto 0);
		Address_OUT: out std_logic_vector (n-1 downto 0));
end entity Programme_Counter;

Architecture PC of Programme_Counter is
signal input , output: std_logic_vector(n-1 downto 0);
begin

output<= Address_IN +'1';
Address_OUT<= output;

end Architecture;
