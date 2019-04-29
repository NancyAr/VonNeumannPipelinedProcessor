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
		is32bit: in std_logic;		
		Address_IN: in std_logic_vector (n-1 downto 0);
		Address_OUT: out std_logic_vector (n-1 downto 0));
end Component;

---------------------------------------
Component RegisterFile is
port (
 	Clk,Rst, RegWrite: in std_logic;
	Rsrc, Rdst, WriteAddress1, WriteAddress2: in std_logic_vector(2 downto 0);
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
mult: out std_logic_vector (31 downto 0);
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
Component mux_generic IS 
	Generic ( n : Integer:=16);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END Component;
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
Writeback: out std_logic_vector(1 downto 0);
MemRead, MemWrite, Inst32, isMul: out std_logic;
PCWrite, SETC, CLRC, ALUOp, PortOut, PortIn, MemFlag, Reg_Write : out std_logic);
End Component;

----------------------------------
Component Memory is

generic(m:integer:=32; n:integer:=16);

port (
	Clk, Rst, MemFlag, MemRead, MemWrite: in std_logic;
	PCin: in std_logic_vector(n-1 downto 0);
	Address: in std_logic_vector(n-1 downto 0);
	WriteData: in std_logic_vector(n-1 downto 0);
	OutData: out std_logic_vector(m-1 downto 0)
);
end Component;
-----------------------------------------
Component ForwUnit is
port( 	Rdst,Rsrc,Ex_Mem_Rdst,Mem_WB_Rdst,Ex_Mem_Rsrc : in std_logic_vector (2 downto 0);
  WB1,WB2,Mult : in std_logic;
	Mux_DST, Mux_SRC : out std_logic_vector(1 downto 0));

end Component;

---------------Signals-------------------
Signal op_code:  std_logic_vector(4 downto 0); 
Signal Pc_in, Pc_out: std_logic_vector(15 downto 0);
Signal mflag, mread, mwrite, regwrite: std_logic; --signal
Signal pc_write, alu_op, set_c, clr_c, port_in, port_out, instr32bit: std_logic;
Signal EAddr: std_logic_vector(15 downto 0);
Signal MWritedata: std_logic_vector(15 downto 0); --vector
Signal r_src, r_dst, w_addr, w_addr2: std_logic_vector(2 downto 0);
Signal reg_write_data1,reg_write_data2, reg_rsrc_out, reg_rdst_out1,reg_rdst_out2,w_reg_rdst_out1,w_reg_rdst_out2,w_reg_rsrc_out: std_logic_vector(15 downto 0); 
Signal wa,wb,wf: std_logic_vector (15 downto 0);
Signal MOutdata, wmult: std_logic_vector (31 downto 0);
Signal ws : std_logic_vector (3 downto 0);
Signal wcin, wcout, wz, wn, wovrflw , c: std_logic;
Signal mul, shift: std_logic;
----fetch signals----
signal R1_En, f_flush: std_logic;
signal R1_In, R1_Out : std_logic_vector(42 downto 0);
---Dec_Ex signals----
Signal R2_En, d_flush: std_logic;
signal R2_In, R2_Out : std_logic_vector(94 downto 0);
---Ex_Mem signals----
Signal R3_En, e_flush: std_logic;
signal R3_In, R3_Out : std_logic_vector(142 downto 0);
---Mem_WB signals----
Signal R4_En, m_flush: std_logic;
signal R4_In, R4_Out : std_logic_vector(174 downto 0);
---Write back signal----
Signal WB_signal: std_logic_vector(1 downto 0);
----
Signal Sel_AluMuxRsrc: std_logic_vector(1 downto 0);
Signal Sel_AluMuxRdst: std_logic_vector(1 downto 0);
Signal AlU_Rsrc: std_logic_vector(15 downto 0);
Signal AlU_Rdst: std_logic_vector(15 downto 0);

begin

Pc_in <= R1_Out(15 downto 0);
PC: Programme_Counter port map (Clk, Rst, instr32bit,R1_Out(15 downto 0), Pc_out);

Mem: Memory port map (Clk, Rst, mflag, mread, mwrite, Pc_in, EAddr, MWritedata, MOutdata);
--Initially--
R1_En <= '1';
f_flush <= '1' when mflag = '1' else '0';
---R1_In <= R4_Out(31 downto 27) &  R4_Out(26 downto 24) & R4_Out(23 downto 21) & R4_Out(15 downto 0)& Pc_out; --OpCode(42-38)+Rsrc(37-35)+Rdst(34-32)+ImmValue(31-16)+(PC+1)(15-0)
R1_In <= MOutdata(31 downto 27) &  MOutdata(26 downto 24) & MOutdata(23 downto 21) & MOutdata(15 downto 0)& Pc_out;

IF_ID: my_buff generic map (43) port map (Clk, Rst, R1_En, f_flush,R1_In,R1_Out);

op_code <= R1_Out(42 downto 38);
 
r_src <= R1_Out(37 downto 35);

--  rdst is 3 bits after opcode (instr(10-8)) when not, inc, dec, in or out, else it's rdst 3ady
r_dst <=  R1_Out(37 downto 35) when op_code = "00011" or op_code = "00100" or op_code = "00101" or op_code = "01111" or op_code = "01110" 
else R1_Out(34 downto 32);


ControlUnit: CU port map (op_code, WB_signal, mread, mwrite, instr32bit, mul,pc_write, set_c, clr_c, alu_op, port_out, port_in, mflag, regwrite);

--regwrite signal R4Out(82)
reg_file: RegisterFile port map (Clk, Rst, R4_Out(83), r_src, r_dst,w_addr,w_addr2,reg_write_data1,reg_write_data2,reg_rsrc_out,reg_rdst_out1,reg_rdst_out2 );

---in port
w_reg_rdst_out1 <= inPort when port_in = '1' else reg_rdst_out1;

w_reg_rdst_out2 <= reg_rdst_out2 when mul = '1' else "XXXXXXXXXXXXXXXX";

---for alu ops one op uses Rdst not Rsrc
w_reg_rsrc_out <= w_reg_rdst_out1 when op_code = "00011" or op_code = "00100" or op_code = "00101" or op_code = "01111" or op_code = "01110" else reg_rsrc_out;


R2_In <= R1_Out  & w_reg_rsrc_out & w_reg_rdst_out1 & w_reg_rdst_out2 & regwrite & WB_signal & mul; --OpCode(94-90)+Rsrc(89-87)+Rdst(86-84)+ImmVal(83-68)+(PC+1)(67-52)+Rsrcout(51-36)+Rdstout(35-20)+Rdstout2(19-4)+regwrite(3)+wb(2-1)+mul(0)
R2_En <= '0' when mflag = '1' else '1';
ID_EX: my_buff generic map (95) port map (Clk, Rst, R2_En, '0',R2_In,R2_Out);

FU: ForwUnit port map(R2_Out(86 downto 84),R2_Out(89 downto 87), R3_Out(134 downto 132), R4_Out(166 downto 164), R3_Out(137 downto 135), R3_Out(51),R4_Out(83),R3_Out(48),Sel_AluMuxRdst,Sel_AluMuxRsrc );

--Rscrout from regfile, rdst_mem, ex_output, rsrc_ex (for mul)= rdstout2
alumux1: mux_generic port map (R2_Out(51 downto 36), R3_Out(83 downto 68), R3_Out(47 downto 32) ,R3_Out(31 downto 16), Sel_AluMuxRsrc ,AlU_Rsrc);

--Rdstout from regfile, rdst_mem, rdst_ex, rsrc_ex (for mul)= rdstout2
alumux2: mux_generic port map(R2_Out(35 downto 20), R3_Out(83 downto 68), R3_Out(47 downto 32), R3_Out(31 downto 16), Sel_AluMuxRdst ,AlU_Rdst);


alu1: alu generic map (16) port map(AlU_Rsrc,AlU_Rdst,ws,wf,wmult,wcin,wcout,wz,wn,wovrflw);

ac: alu_contr port map (R2_Out(94 downto 90), ws, wcin);

c <= '1' when set_c = '1' else '0' when clr_c = '1' or Rst = '1' else wcout; --setc & clrc

R3_In <= R2_Out  & wf & wmult ;  --OpCode(142-138)+Rsrc(137-135)+Rdst(134-132)+ImmVal(131-116)+(PC+1)(115-100)+Rsrcout(99-84)+Rdstout(83-68)+Rdstout2(67-52)+reqwrite(51)+wb(50-49)+mul(48)+Aluout(47-32)+Multout(31-0)

R3_En <= '0' when mflag = '1' else '1';
EX_M: my_buff generic map (143) port map (Clk, Rst, R3_En, '0',R3_In,R3_Out);


R4_In <= R3_Out  & MOutData  ; --OpCode(174-170)+Rsrc(169-167)+Rdst(166-164)+ImmVal(163-148)+(PC+1)(147-132)+Rsrcout(131-116)+Rdstout(115-100)+Rdstout2(99-84)+reqwrite(83)+wb(82-81)+mul(80)+Aluout(79-64)+Multout(63-32)(High 2 bytes = 63-48, low = 47-32)+Mout(31-0) edited by omar
R4_En <= '0' when mflag = '1' else '1';
M_WB: my_buff generic map (175) port map (Clk, Rst, R4_En, '0', R4_In, R4_Out);


shift <= '1' when R4_Out(174 downto 170) = "01011" or R4_Out(174 downto 170) = "01100"  else '0';

w_addr <= R4_Out(166 downto 164) when R4_Out(174 downto 170) = "01101" or R4_Out(174 downto 170) = "00110" or R4_Out(174 downto 170) = "00111" or  R4_Out(80) = '1'-- from rsrc to rdst for mov 
else R4_Out(169 downto 167) when shift = '1' else "XXX"; --  save in rsrc for SHL & SHR

w_addr2 <= R4_Out(169 downto 167) when R4_Out(80) = '1' else "XXX"; --rdst2 = rsrc for mul: value will equal highest 2bytes from alu output for mul

reg_write_data1 <= R4_Out(131 downto 116) when R4_Out(82) = '1' and R4_Out(81) = '0' --when WB = 10 MOV rsrc into rdst
	else R4_Out(79 downto 64) when R4_Out(82) = '0' and R4_Out(81) = '1' and  R4_Out(80) = '0'--when WB = 01 ADD or SUB or OR or AND or SHL or SHR aluoutput
	else R4_Out(63 downto 48) when R4_Out(82) = '0' and R4_Out(81) = '1' and R4_Out(80) = '1'--Mul: when WB = 01 & Opcode is mul, take higher 2 bytes into writedata1 (in Rdst)
else "XXXXXXXXXXXXXXXX";

reg_write_data2 <= R4_Out(47 downto 32) when R4_Out(82) = '0' and R4_Out(81) = '1' and R4_Out(80) = '1'-- --for mul: when WB = 01 & Opcode is mul, take lower 2 bytes into writedata2 (in Rsrc)
else "XXXXXXXXXXXXXXXX";

--ALUOut is zeroed when mult instr else set w/ alu output
ALUOut <= R3_Out(31 downto 16) when R2_Out(0) = '1' else wf;
PCOut <= Pc_out;
--Out_Buff: my_buff generic map (32) port map (Clk, Rst, '1', '0', R4_Out(98 downto 83), R4_Out);

outPort <=  R4_Out(115 downto 100) when port_out = '1' else x"0000";
end Architecture;