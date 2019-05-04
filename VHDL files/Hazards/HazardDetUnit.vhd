LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Hazard_Detection_Unit is
	
	port( R_src,R_dst: in std_logic_vector(2 downto 0);
		mem_Read: in std_logic;
		PC_write,Stall_signal:out std_logic);
end entity;

architecture DataFlow of Hazard_Detection_Unit is
begin
	process(mem_Read)
		begin
		if(R_src = "XXX" and R_dst = "XXX") then 
			PC_write<= '0';
			stall_signal <='0';
		elsif( R_src = R_dst and mem_Read = '1') then
			PC_write<= '1';
			stall_signal <='1';
		else 
			PC_write<= '0';
			stall_signal <='0';
		end if;
	end process;
end architecture;
