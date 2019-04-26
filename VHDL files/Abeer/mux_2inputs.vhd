LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity mux_2inputs is 
		generic(n: integer := 16);
	
	port ( in1,in2 : in std_logic_vector(n-1 downto 0);
		sel: in std_logic;
		output: out std_logic_vector(n-1 downto 0));
end entity;

Architecture two_inputs_mux of mux_2inputs is

		begin 
	output <= in1 when sel='0'
		else in2 when sel='1';
End architecture;
