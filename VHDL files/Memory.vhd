library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Memory is

generic(n:integer:=16; m:integer:=16);

port (
	Clk, Rst, MemFlag, MemRead, MemWrite: in std_logic;
	PCin: in std_logic_vector(m-1 downto 0);
	Address: in std_logic_vector(n-1 downto 0);
	WriteData: in std_logic_vector(m-1 downto 0);
	OutData: out std_logic_vector(m-1 downto 0)
);
end entity;


architecture synchronusRam of Memory is
type RAM_Type is array(0 to (2**(n-1))-1) of std_logic_vector(15 downto 0);
type ROM_Type is array(0 to 7) of std_logic_vector(15 downto 0);
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

   rom(0) <= "00000XXXXXXXXXXX";
   rom(1) <= "00001XXXXXXXXXXX";
   rom(2) <= "00010XXXXXXXXXXX";
   rom(3) <= "00011100XXXXXXXX";
   rom(4) <= "00100011XXXXXXXX";
   rom(5) <= "00101010XXXXXXXX";
   rom(6) <= "01110001XXXXXXXX";
   rom(7) <= "01111000XXXXXXXX";
   
		 elsif (rising_edge(Clk)) and MemFlag = '0' then
			OutData <= rom(to_integer(unsigned(PCin)));	
		elsif (rising_edge(Clk)) and MemFlag = '1' and  MemWrite = '1' and MemRead = '0' then
				ram(to_integer(unsigned(Address))) <= WriteData;
			elsif (rising_edge(Clk)) and MemFlag = '1' and  MemWrite = '0' and MemRead = '1' then
				OutData <= ram(to_integer(unsigned(Address)));
							
			end if;
	end process;
	--OutData <= ram(to_integer(unsigned(Address)));

end architecture;
