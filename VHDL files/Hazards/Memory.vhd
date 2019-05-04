library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Memory is

generic(n:integer:=16; m:integer:=32);

port (
	Clk, Rst, MemFlag, MemRead, MemWrite: in std_logic;
	Address: in std_logic_vector(31 downto 0);
	WriteData: in std_logic_vector(n-1 downto 0);
	OutData: out std_logic_vector(m-1 downto 0)
);
end entity;


architecture synchronusRam of Memory is
type RAM_Type is array(0 to (2**(20-1))-1) of std_logic_vector(15 downto 0);
type ROM_Type is array(0 to 39) of std_logic_vector(15 downto 0);
signal ram: RAM_Type;
signal rom: ROM_Type;
signal is32bit: std_logic;
signal mem_en: std_logic;
signal optemp: std_logic_vector(4 downto 0);
begin
mem_en <= '1' when MemRead = '1' or MemWrite = '1' else '0';
	process(Clk, MemFlag, Rst) is
	begin
	if(Rst = '1') then
   ram(0) <= x"0001";
   ram(1) <= x"0002";
   ram(2) <= x"0003";
   ram(3) <= x"0004";
   ram(4) <= x"0005";
   ram(5) <= x"0006";
   ram(6) <= "01110XXXXXXXXXXX";
   ram(7) <= "01111XXXXXXXXXXX";
  

   	rom(0) <= "00000XXXXXXXXXXX";
   	rom(1) <= "00001XXXXXXXXXXX";
   	rom(2) <= "00010XXXXXXXXXXX";
   	rom(3) <= "00011100XXXXXXXX";
   	rom(4) <= "00100011XXXXXXXX";
   	rom(5) <= "00101010XXXXXXXX";
   	rom(6) <= "01110001XXXXXXXX";
  	rom(7) <= "01111000XXXXXXXX";
   	rom(8) <= "01101000101XXXXX";
   	rom(9) <= "00110111110XXXXX"; --add
  	rom(10)<= "00111010011XXXXX"; --sub
   	rom(11)<= "01001001010XXXXX"; --
   	rom(12)<= "01010000001XXXXX";
   	rom(13)<= "01000110111XXXXX"; 
   	rom(14)<= "01011010XXXXXXXX";
	rom(15)<= "0000000000000001"; --shl
   	rom(16)<= "01100011XXXXXXXX";
	rom(17)<= "0000000000000001"; --shr
   	rom(18)<= "10010011XXXXXXXX";
	rom(19)<= "0000000000000001"; --LDM
   	rom(20)<= "10011111XXXX0000";
	rom(21)<= "0000000000000010"; --lDD	
   	rom(22)<= "10100111XXXX0000";
	rom(23)<= "0000000000000001"; --STD	

		elsif (rising_edge(Clk) and mem_en = '0') then
			OutData <= rom(to_integer(unsigned(Address)))& rom(to_integer(unsigned(Address))+1);
			
		elsif (falling_edge(Clk) and mem_en = '1' and MemWrite = '0' and MemRead = '1') then
				OutData <= "XXXXXXXXXXXXXXXX" & ram(to_integer(unsigned(Address(19 downto 0)))) ;
				
				
		elsif (rising_edge(Clk) and mem_en = '1' and MemWrite = '1' and MemRead = '0') then
--if (rising_edge(Clk) and  MemWrite = '1' and MemRead = '0' )then
				ram(to_integer(unsigned(Address(19 downto 0)))) <= WriteData;
			
			end if;
	end process;
	--OutData <= rom(to_integer(unsigned(Address)))& rom(to_integer(unsigned(Address))+1) when mem_en = '0' else "XXXXXXXXXXXXXXXX" & ram(to_integer(unsigned(Address(19 downto 0)))) ;
			

end architecture;
