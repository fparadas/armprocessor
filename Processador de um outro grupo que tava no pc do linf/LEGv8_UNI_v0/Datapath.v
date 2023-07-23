/*
 * Caminho de dados processador uniciclo
 * input: 
 *	iCLK - Clock
 *	iRST - Reset
 * output:
 *	none
 *
 */
//os wXXXX da entrada sao na verdade oXXXX
module Datapath (
	iCLK,
	iCLKMem,
	iCLK50,
	iRST,
	wPC,
	wCReg2Loc,
	wCOrigALU, 
	wCMem2Reg, 
	wCRegWrite, 
	wCMemRead, 
	wCMemWrite, 
	wOpcode,
	wRegDispSelect,
	wiRegA0,
	wCInputA0En,
	wRegDisp,
	wCALUOp,
	wCBranch,
	wCUBranch,
	wCRegDst,
	woInstr,
	wDebug
);

input wire	iCLK, iCLKMem, iCLK50, iRST;
output wire [31:0] woInstr;
output wire [63:0] wPC, wRegDisp;
input wire [63:0] wiRegA0;
output wire  wCRegWrite, wCMemRead, wCMemWrite, wCMem2Reg, wCReg2Loc, wCBranch, wCUBranch, wCRegDst;
output wire [1:0] wCALUOp, wCOrigALU;
output wire [11:0] wOpcode;
input wire [4:0] wRegDispSelect;
input wire wCInputA0En;
/*Para debug*/
output wire [63:0] wDebug;


/* Padrao de nomeclatura
 *
 * XXXXX - registrador XXXX
 * wXXXX - wire XXXX
 * wCXXX - wire do sinal de controle XXX
 * memXX - memoria XXXX
 * Xunit - unidade funcional X
 * iXXXX - sinal de entrada/input
 * oXXXX - sinal de saida/output
 */
 
reg [63:0] PC; // registrador do PC
wire [63:0] wPC4;
wire [63:0] wiPC;
wire [31:0] wInstr; 
wire [4:0] wAddrRm, wAddrRn, wAddrRd, wAddrR2, wRegDst, wShamt; // enderecos dos reg rm, rn ,rd e saida do Mux regDst
wire [63:0] wRead1, wRead2;
wire [63:0] wOrigALU;
wire [63:0] wALUresult;
wire wZero;
wire [3:0] wALUControl;
wire [63:0] wReadData;
wire [63:0] wDataReg;
wire [63:0] wBranchPC;
wire [63:0] wUBranchPC;
wire [63:0] wAddrMem;
wire wOverflow;

/* Inicializa��o */
initial
begin
	PC <= 64'b0;	
end


assign wPC4	= wPC + 64'h4;  /* Calculo PC+4 */
assign wUBranchPC = wPC4 + {{36{wInstr[25]}},wInstr[25:0],2'b0};  /* Endereco do Branch condicional*/
assign wBranchPC = wPC4 + {{43{wInstr[24]}},wInstr[24:5],2'b0};  /* Endereco do Branch incondicional */
assign wPC 		= PC;
assign wOpcode = wInstr[31:21];
assign wAddrRm = wInstr[20:16];
assign wAddrRn = wInstr[9:5];
assign wAddrRd = wInstr[4:0];
assign wShamt  = wInstr[15:10];
assign woInstr = wInstr;
assign wAddrMem = {{55{wInstr[8]}}, wInstr[8:0]};
/* Assigns para debug */
assign wDebug = wiRegA0;



/* Mem�ria de Instru��es */
CodeMemory memInstr(
	.iCLK(iCLK),
	.iCLKMem(iCLKMem),
	.iAddress(wPC),
	.iWriteData(ZERO),
	.iMemRead(ON),
	.oMemData(wInstr)
);


/* Banco de Registradores */
Registers memReg(
	.iCLK(iCLK),
	.iCLR(iRST),
	.iReadRegister1(wAddrRm),
	.iReadRegister2(wAddrR2),
	.iWriteRegister(wRegDst),
	.iWriteData(wDataReg), 
	.iRegWrite(wCRegWrite),
	.oReadData1(wRead1),
	.oReadData2(wRead2),
	.iRegDispSelect(wRegDispSelect),
	.oRegDisp(wRegDisp),
	.iRegA0(wiRegA0),
	.iA0en(wCInputA0En)
 );
  

/* ALU CTRL */
ALUControl ALUControlunit (
	.iOpcode(wOpcode), 
	.iALUOp(wCALUOp), 
	.oControlSignal(wALUControl)
);

/* ALU */
ALU ALUunit(
	.Op(wALUControl),
	.A(wRead1), 
	.B(wOrigALU),
	.Out(wALUresult),
	.Zero(wZero),
	.Overflow(wOverflow),
	.Shamt(wShamt)
);
	
/* memoria de dados */
DataMemory memData(
	.iCLK(iCLK),
	.iCLKMem(iCLKMem), 
	.iAddress(wALUresult), 
	.iWriteData(wRead2),
	.iMemRead(wCMemRead), 
	.iMemWrite(wCMemWrite),
	.oMemData(wReadData)
);


	


Control Controlunit (
	.iCLK(iCLK),
	.iOp(wOpcode),
	.oReg2Loc(wCReg2Loc),
	.oALUSrc(wCOrigALU),
	.oMemtoReg(wCMem2Reg),
	.oRegWrite(wCRegWrite),
	.oMemRead(wCMemRead),
	.oMemWrite(wCMemWrite),
	.oOpALU(wCALUOp),
	.oBranch(wCBranch),
	.oUBranch(wCUBranch),
	.oRegDst(wCRegDst)
);


always @(wCOrigALU)
begin
	case(wCOrigALU)
		2'b00:
			wOrigALU <= wRead2;
		2'b01:
			wOrigALU <= wAddrMem;
		2'b10:
			wOrigALU <= wPC4;	
	endcase
end
/*
always @(wCOrigPC)
begin
	case(wCOrigPC)
		2'b00:
			wiPC <= wPC4;
		2'b01:
			wiPC <= wZero ? wBranchPC: wPC4;
		2'b10:
			wiPC <= wJumpAddr;
		2'b11:
			wiPC <= wRead1;
	endcase
end
*/



always @(wCMem2Reg)
begin
	case(wCMem2Reg)
		1'b0:
			wDataReg <= wALUresult;
		1'b1:
			wDataReg <= wReadData;
	endcase
end

//
// atribui ao segundo registrador de leitura o endereco correto conforme o sinal de controle Reg2Loc
always @(wCReg2Loc)
begin
	case(wCReg2Loc)
		1'b0:
			wAddrR2 <= wAddrRn;
		1'b1:
			wAddrR2 <= wAddrRd;
	endcase
end

always @(wCBranch or wCUBranch)
begin
	case(wCBranch)
		1'b0:
			case(wCUBranch)
				1'b0:
					wiPC <= wPC4;
				1'b1:
					if(wOpcode == OPCBR)
						wiPC <= wRead2;
					else
						wiPC <= wCUBranch;
			endcase
		1'b1:
			wiPC <= wZero ? wBranchPC: wPC4;
	endcase
end
   
always @(posedge iCLK)
begin
	if(iRST)
		PC <= 64'b0;
	else
		PC <= wiPC;

end
always @(posedge wCRegDst)
	case(wCRegDst)
		1'b0:
			wRegDst <= wAddrRd;
		1'b1:
			wRegDst <= 5'd30; //caso seja uma instrução BL, escreve o valor de PC+4 em X30 (Return Address)
	endcase

endmodule
