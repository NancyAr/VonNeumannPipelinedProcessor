
Library ieee;
Use ieee.std_logic_1164.all;

Entity my_buff is
Generic ( n : integer := 16);
port( Clk,Rst, En, Flush : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end my_buff;

Architecture model_buff of my_buff is
begin
	Process (Clk,Rst)
	begin
		if Rst = '1' then
			q <= (others=>'Z');
		elsif rising_edge(Clk) and En = '1' and Flush = '0' then
			q <= d;
		elsif rising_edge(Clk) and En = '1' and Flush = '1' then
			q <= (others=>'0');
		end if;
	end process;
end architecture;