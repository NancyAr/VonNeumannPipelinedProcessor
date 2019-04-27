LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Programme_Counter is
	generic (n :integer:=16);
	port( Clk,Rst: in std_logic;
		Address_IN: in std_logic_vector (n-1 downto 0);
		Address_OUT: out std_logic_vector (n-1 downto 0));
end entity Programme_Counter;

Architecture PC of Programme_Counter is
signal input , output: std_logic_vector(n-1 downto 0);
begin
process(Clk,Rst)
begin 
if (Rst = '1') then
	Address_OUT <=  x"0000";
elsif (rising_edge(Clk)) then
	output<= Address_IN +'1';
	Address_OUT<= output;
end if;
end process;

end Architecture;
