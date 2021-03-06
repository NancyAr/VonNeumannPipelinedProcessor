Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
entity RegisterFile is
port (
 	Clk,Rst, RegWrite, isMul: in std_logic;
	Rsrc, Rdst, WriteAddress1, WriteAddress2: in std_logic_vector(2 downto 0);
 	WriteData1, WriteData2: in std_logic_vector(15 downto 0);
	RsrcOut, RdstOut1, RdstOut2: out std_logic_vector(15 downto 0));
end entity;

architecture Behavioral of RegisterFile is
type reg_type is array (0 to 7 ) of std_logic_vector (15 downto 0);
signal reg_array: reg_type;
begin
 process(Clk,Rst) 
 begin
 if(Rst = '1') then
   reg_array(0) <= x"0001";
   reg_array(1) <= x"0002";
   reg_array(2) <= x"0003";
   reg_array(3) <= x"0004";
   reg_array(4) <= "0000000000000101";
   reg_array(5) <= x"0006";
   reg_array(6) <= x"0007";
   reg_array(7) <= x"0008";
 elsif(rising_edge(Clk)) and RegWrite='1' then
    	if(isMul = '0') then
	reg_array(to_integer(unsigned(WriteAddress1))) <= WriteData1;
	elsif(isMul = '1') then
	reg_array(to_integer(unsigned(WriteAddress1))) <= WriteData1;
	reg_array(to_integer(unsigned(WriteAddress2))) <= WriteData2;
    	end if;
	end if;
 end process;

 	RsrcOut <= "XXXXXXXXXXXXXXXX" when Rsrc = "XXX" else reg_array(to_integer(unsigned(Rsrc)));
 	RdstOut1 <= "XXXXXXXXXXXXXXXX" when Rdst = "XXX" else reg_array(to_integer(unsigned(Rdst)));
	RdstOut2 <= "XXXXXXXXXXXXXXXX" when Rsrc = "XXX" else reg_array(to_integer(unsigned(Rsrc)));

end architecture;