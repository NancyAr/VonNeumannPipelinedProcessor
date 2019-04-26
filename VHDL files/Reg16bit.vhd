Library ieee;
Use ieee.std_logic_1164.all;

Entity Reg16bit is
	port( Clk,Rst : in std_logic;
	d : in std_logic_vector(15 downto 0);
	q : out std_logic_vector(15 downto 0));
end Entity;

Architecture dataflow of Reg16bit is
begin
Process (Clk,Rst)
begin
if Rst = '1' then
q <= (others=>'0');
elsif rising_edge (Clk) then
q <= d;
end if;
end process;
end Architecture;
