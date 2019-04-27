Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity VN_Processor is
port (
	Clk,Rst: in std_logic;
 	PCOut, ALUOut: out std_logic_vector(15 downto 0);
	inPort : in std_logic_vector(15 downto 0);
	outPort : out std_logic_vector(15 downto 0));
end Entity;

Architecture DataFlow of VN_Processor is

-------Components----------------------

Component Programme_Counter is
	generic (n :integer:=16);
	port( Clk,Rst: in std_logic;
	Address_IN: in std_logic_vector (n-1 downto 0);
		Address_OUT: out std_logic_vector (n-1 downto 0));
end Component;

---------------------------------------
Component RegisterFile is
port (
 	Clk,Rst, RegWrite: in std_logic;
	Rsrc, Rdst, WriteAddress: in std_logic_vector(2 downto 0);
 	WriteData1, WriteData2: in std_logic_vector(15 downto 0);
	RsrcOut, RdstOut1, RdstOut2: out std_logic_vector(15 downto 0));
end Component;

--------------------------------------
Component alu is
  generic (n :integer:=16);
port( 
a,b : in std_logic_vector (n-1 downto 0);
s : in std_logic_vector (3 downto 0);
f : out std_logic_vector (n-1 downto 0);
cin : in std_logic;
cout : out std_logic;
zero,neg,ovrflw : out std_logic
);
end Component;
-----------------------------------
Component my_buff is
Generic ( n : integer := 16);
port( Clk,Rst, En, Flush : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end Component;
-----------------------------------
Component alu_contr is

Port(
OPCode	: in std_logic_vector(4 downto 0);
aluCode	: out std_logic_vector(3 downto 0);
aluCin : out std_logic);

End Component;

-----------------------------------
Component CU is
Port(
OPCode	: in std_logic_vector(4 downto 0);
MemRead, MemWrite: in std_logic;
PCWrite, SETC, CLRC, ALUOp, PortOut, PortIn, MemFlag: out std_logic);
End Component;

----------------------------------
Component Memory is

generic(n:integer:=16; m:integer:=16);

port (
	Clk, Rst, MemFlag, MemRead, MemWrite: in std_logic;
	PCin: in std_logic_vector(m-1 downto 0);
	Address: in std_logic_vector(n-1 downto 0);
	WriteData: in std_logic_vector(m-1 downto 0);
	OutData: out std_logic_vector(m-1 downto 0)
);
end Component;


---------------Signals-------------------
Signal op_code:  std_logic_vector(4 downto 0); 
Signal Pc_in, Pc_out: std_logic_vector(15 downto 0);
Signal mflag, mread, mwrite: std_logic; --signal
Signal pc_write, alu_op, set_c, clr_c, port_in, port_out: std_logic;
Signal EAddr: std_logic_vector(15 downto 0);
Signal MWritedata, MOutdata: std_logic_vector(15 downto 0); --vector
Signal reg_write: std_logic;
Signal r_src, r_dst, w_addr: std_logic_vector(2 downto 0);
Signal reg_write_data1,reg_write_data2, reg_rsrc_out, reg_rdst_out1,reg_rdst_out2,w_reg_rdst_out1,w_reg_rsrc_out: std_logic_vector(15 downto 0); 
Signal wa,wb,wf: std_logic_vector (15 downto 0);
Signal ws : std_logic_vector (3 downto 0);
Signal wcin, wcout, wz, wn, wovrflw , c: std_logic;
----fetch signals----
signal R1_En, f_flush: std_logic;
signal R1_In, R1_Out : std_logic_vector(23 downto 0);
---Dec_Ex signals----
Signal R2_En, d_flush: std_logic;
signal R2_In, R2_Out : std_logic_vector(55 downto 0);
---Ex_Mem signals----
Signal R3_En, e_flush: std_logic;
signal R3_In, R3_Out : std_logic_vector(71 downto 0);
---Mem_WB signals----
Signal R4_En, m_flush: std_logic;
signal R4_In, R4_Out : std_logic_vector(87 downto 0);

begin

PC: Programme_Counter port map (Clk, Rst, Pc_in, Pc_out);

Mem: Memory port map (Clk, Rst, mflag, mread, mwrite, Pc_in, EAddr, MWritedata, MOutdata);
--Initially--
f_flush <= '1' when mflag = '1' else '0';
R1_In <= MOutdata(15 downto 11) &  MOutdata(10 downto 8) & Pc_out; --OpCode+Rdst+PC+1

IF_ID: my_buff generic map (24) port map (Clk, Rst, R1_En, f_flush,R1_In,R1_Out);

op_code <= R1_Out(23 downto 19);
r_src <= "000"; --till 2 operands
w_addr <= "000"; --till 2 operands

r_dst <= R1_Out(18 downto 16) when op_code = "00011" or op_code = "00100" or op_code = "00101" or op_code = "01111" or op_code = "01110" else "000";

ControlUnit: CU port map (op_code, mread, mwrite, pc_write, set_c, clr_c, alu_op, port_out, port_in, mflag);


reg_file: RegisterFile port map (Clk, Rst, reg_write, r_src, r_dst,w_addr,reg_write_data1,reg_write_data2,reg_rsrc_out,reg_rdst_out1,reg_rdst_out2 );
---in port
w_reg_rdst_out1 <= inPort when port_in = '1' else reg_rdst_out1;
---for alu ops one op uses Rdst not Rsrc
w_reg_rsrc_out <= w_reg_rdst_out1 when op_code = "00011" or op_code = "00100" or op_code = "00101" or op_code = "01111" or op_code = "01110" else x"0000";


R2_In <= R1_In  & w_reg_rsrc_out & w_reg_rdst_out1;
R2_En <= '0' when mflag = '1' else '1';
ID_EX: my_buff generic map (56) port map (Clk, Rst, R2_En, '0',R2_In,R2_Out);

alu1: alu generic map (16) port map(R2_Out(31 downto 16 ),R2_Out(15 downto 0),ws,wf,wcin,wcout,wz,wn,wovrflw);

ac: alu_contr port map (R2_Out(55 downto 51), ws, wcin);

c <= '1' when set_c = '1' else '0' when clr_c = '1' or Rst = '1' else wcout; --setc & clrc

R3_In <= R2_In  & wf;
R3_En <= '0' when mflag = '1' else '1';
EX_M: my_buff generic map (72) port map (Clk, Rst, R3_En, '0',R3_In,R3_Out);


R4_In <= R3_In  & MOutData;
R4_En <= '0' when mflag = '1' else '1';
M_WB: my_buff generic map (88) port map (Clk, Rst, R4_En, '0', R4_In, R4_Out);

ALUOut <= wf;
PCOut <= Pc_out;
outPort <=  w_reg_rdst_out1 when port_out = '1' else x"0000";
end Architecture;