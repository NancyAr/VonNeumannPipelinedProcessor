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
type ROM_Type is array(0 to 19) of std_logic_vector(31 downto 0);
signal ram: RAM_Type;
signal rom: ROM_Type;

begin
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
  

   rom(0) <= "00000XXXXXXXXXXXXXXXXXXXXXXXXXXX";
   rom(1) <= "00001XXXXXXXXXXXXXXXXXXXXXXXXXXX";
   rom(2) <= "00010XXXXXXXXXXXXXXXXXXXXXXXXXXX";
   rom(3) <= "00011100XXXXXXXXXXXXXXXXXXXXXXXX";
   rom(4) <= "00100011XXXXXXXXXXXXXXXXXXXXXXXX";
   rom(5) <= "00101010XXXXXXXXXXXXXXXXXXXXXXXX";
   rom(6) <= "01110001XXXXXXXXXXXXXXXXXXXXXXXX";
   rom(7) <= "01111000XXXXXXXXXXXXXXXXXXXXXXXX";
   rom(8) <= "01101000101XXXXXXXXXXXXXXXXXXXXX";
   rom(9) <= "00110110000XXXXXXXXXXXXXXXXXXXXX"; --add
   rom(10)<= "00111010011XXXXXXXXXXXXXXXXXXXXX"; --sub
   rom(11)<= "01001001010XXXXXXXXXXXXXXXXXXXXX"; --
   rom(12)<= "01010000001XXXXXXXXXXXXXXXXXXXXX";
   rom(13)<= "01000110111XXXXXXXXXXXXXXXXXXXXX"; 
   rom(14)<= "01011010XXXXXXXX0000000000000001"; --shl
   rom(16)<= "01100011XXXXXXXX0000000000000001"; --shr
   rom(17)<= "10010011XXXXXXXX0000000000000001"; --LDM
   rom(18)<= "10011111XXXX00000000000000000010"; --lDD	
   rom(19)<= "10100111XXXX00000000000000000001"; --STD	

		 elsif (rising_edge(Clk)) and MemFlag = '0' then
			OutData <= rom(to_integer(unsigned(Address)));	
		elsif (rising_edge(Clk)) and MemFlag = '1' and  MemWrite = '1' and MemRead = '0' then
				ram(to_integer(unsigned(Address(19 downto 0)))) <= WriteData;
			elsif (rising_edge(Clk)) and MemFlag = '1' and  MemWrite = '0' and MemRead = '1' then
	--MulOut <= std_logic_vector(to_unsigned((to_integer(unsigned(a)) * to_integer(unsigned(b))),32)) ;			--OutData <= std_logic_vector(ram(to_integer(unsigned(Address)),32);
				OutData <= "XXXXXXXXXXXXXXXX" & ram(to_integer(unsigned(Address(19 downto 0)))) ;
							
			end if;
	end process;
	--OutData <= ram(to_integer(unsigned(Address)));

end architecture;
