LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Programme_Counter is
	generic (n :integer:=32);
	port( Clk,Rst, PC_Write: in std_logic;
		is32bit: in std_logic;		
		Address_IN: in std_logic_vector (n-1 downto 0);
		Address_OUT: out std_logic_vector (31 downto 0));
end entity Programme_Counter;

Architecture PC of Programme_Counter is
signal input , output: std_logic_vector(31 downto 0);
begin

process(Clk,Rst,is32bit)
begin  
if (Rst = '1') then
	input <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
	Address_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
elsif (rising_edge(Clk) and Rst ='0' and PC_Write = '1') then
	if (PC_Write = '1') then
	 Address_OUT <= Address_IN+ "00000000000000000000000000000001";
	else
		if (is32bit = '1') then --SHL SHR
		        Address_OUT <= Address_IN + "00000000000000000000000000000001";
		else
			Address_OUT <= Address_IN + "00000000000000000000000000000001";
	end if;
	end if;

	
end if;
end process;

end Architecture;
