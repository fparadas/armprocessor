///*
// TopDE
// 
// Top Level para processador MIPS UNICICLO v0 baseado no processador 
// desenvolvido por 
//Alexandre Lins 	09/40097
//Daniel Dutra 	09/08436
//Yuri Maia 	09/16803
//em 2010/1 na disciplina OAC
//
// Adaptado para a placa de desenvolvimento DE2-70.
// Prof. Marcus Vinicius Lamar   2010/2
//
// */
//module TopDE (CLOCK_50, 
//			  KEY, 
//			  HEX0, //HEX0_DP, 
//			  HEX1, //HEX1_DP, 
//			  HEX2, //HEX2_DP,
//			  HEX3, //HEX3_DP,
//			  HEX4, //HEX4_DP,
//			  HEX5, //HEX5_DP,
//			  HEX6, //HEX6_DP,
//			  HEX7, //HEX7_DP,
//			  LEDR, 
//			  SW);
//
///* I/O type definition */
//input CLOCK_50;
//input [3:0] KEY;
//input [9:0] SW;
////output [8:0] LEDG;
//output [9:0] LEDR;
//output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
////output HEX0_DP, HEX1_DP, HEX2_DP, HEX3_DP, HEX4_DP, HEX5_DP, HEX6_DP, HEX7_DP;
//
///* Local Clock signals */
//reg CLKManual, CLKAutoSlow, CLKSelectAuto, CLKSelectFast, CLKAutoFast, CLK_5;
//wire CLK, clock50_ctrl;
//
//integer CLKCount, CLKCount2, CLKCount5;
//
///* Local wires */
//wire [63:0] PC, wRegDisp, wRegA0, extOpcode, wOutput, wDebug;
//wire [31:0] wInstr;
//wire [1:0] ALUOp,OrigALU, Mem2Reg;
//wire MemWrite, MemRead, RegWrite;
//wire [4:0] wRegDispSelect;
//wire [10:0] wOpcode;
//
// 
///* LEDs sinais de controle */
////assign LEDG[7:0] =	PC[9:2];
//assign LEDR[4] =	CLK;
//assign LEDR[1:0] =	Mem2Reg;
//assign LEDR[3:2] =	OrigALU;
//assign LEDR[9:8] =	ALUOp;
//
//assign LEDR[6] =	RegWrite;
//assign LEDR[7] =	MemWrite;
//assign LEDR[5] =	MemRead;
//		
///* para apresentacao nos displays */
//assign extOpcode = {21'b0,wOpcode};
//
//
///* $a0 initial content, with signal extention */
//assign wRegA0 = {{56{SW[7]}},SW[7:0]};
//
///*
//
//
///* 7 segment display register content selection /
//assign wRegDispSelect =	SW[17:13];
//
//
//
//assign wOutput	= SW[12] ?
//				(SW[17] ?
//					PC :
//					(SW[16] ?
//						wInstr :
//						(SW[15] ?
//							extOpcode :
//							(SW[14] ?
//								wDebug:
//								32'h08888880)
//							)
//						)
//					
//				):
//				wRegDisp;
//				
//*/
///* Clocks */
//assign CLK	= CLKSelectAuto ?
//				(CLKSelectFast ?
//					CLKAutoFast :
//					CLKAutoSlow) :
//				CLKManual;
//
///* Clock inicializacao */
//initial
//begin
//	CLKManual	<= 1'b0;
//	CLKAutoSlow	<= 1'b0;
//	CLKAutoFast	<= 1'b0;
//	CLKSelectAuto	<= 1'b0;
//	CLKSelectFast	<= 1'b0;
//	CLK_5 <= 1'b0;
//end
//
//always @(posedge KEY[3])
//begin
//	CLKManual <= ~CLKManual;       // Manual
//end
//
//always @(posedge KEY[2])
//begin
//	CLKSelectAuto <= ~CLKSelectAuto;
//end
//
//always @(posedge KEY[1])
//begin
//	CLKSelectFast <= ~CLKSelectFast;
//end
//
//always @(posedge clock50_ctrl)
//begin
//
//	if(CLKCount5 == 32'd4)   // Clock da memoria
//	begin
//		CLK_5 = ~CLK_5;
//		CLKCount5 = 0;
//	end
//	else
//	begin
//		CLKCount5 = CLKCount5 + 1;
//	end
//
//	if (CLKCount == 32'd9999999)	// Slow
//	begin
//		CLKAutoSlow = ~CLKAutoSlow;
//		CLKCount = 0;
//	end
//	else
//	begin
//		CLKCount = CLKCount + 1;
//	end
//	
//	if (CLKCount2 == 32'd30)  //  Fast
//	begin
//		CLKAutoFast = ~CLKAutoFast;
//		CLKCount2 = 0;
//	end
//	else
//	begin
//		CLKCount2 = CLKCount2 + 1;
//	end
//	
//end
//
//
///* Mono estável 10 segundos */
////mono Mono1 (CLOCK_50,~SW[10],clock50_ctrl,~KEY[0]);
//
//
///* MIPS Datapath instantiation */
//
//Datapath Datapath0 (
//	.iCLK(CLK),
//	.iCLKMem(CLK_5),
//	.iCLK50(CLOCK_50),
//	.iRST(~KEY[0]),
//	.wiRegA0(wRegA0), 
//	.wCInputA0En(SW[8]),
//	.wPC(PC),
//	.wCALUOp(ALUOp),
//	.wCMemWrite(MemWrite),
//	.wCMemRead(MemRead),
//	.wCRegWrite(RegWrite),
//	.wRegDispSelect(wRegDispSelect),
//	.wRegDisp(wRegDisp),
//	.wOpcode(wOpcode),
//	.woInstr(wInstr),
//	.wCOrigALU(OrigALU),
//	.wCMem2Reg(Mem2Reg),
//	.wDebug(wDebug)	
//	);
//
//	
///* 7 segment display instantiations */
//
////assign HEX0_DP=1'b1;
////assign HEX1_DP=1'b1;
////assign HEX2_DP=1'b1;
////assign HEX3_DP=1'b1;
////assign HEX4_DP=1'b1;
////assign HEX5_DP=1'b1;
////assign HEX6_DP=1'b1;
////assign HEX7_DP=1'b1;
//
//Decoder7 Dec0 (
//	.In(wOutput[3:0]),
//	.Out(HEX0)
//	);
//
//Decoder7 Dec1 (
//	.In(wOutput[7:4]),
//	.Out(HEX1)
//	);
//
//Decoder7 Dec2 (
//	.In(wOutput[11:8]),
//	.Out(HEX2)
//	);
//
//Decoder7 Dec3 (
//	.In(wOutput[15:12]),
//	.Out(HEX3)
//	);
//
//Decoder7 Dec4 (
//	.In(wOutput[19:16]),
//	.Out(HEX4)
//	);
//
//Decoder7 Dec5 (
//	.In(wOutput[23:20]),
//	.Out(HEX5)
//	);
//
//Decoder7 Dec6 (
//	.In(wOutput[27:24]),
//	.Out(HEX6)
//	);
//
//Decoder7 Dec7 (
//	.In(wOutput[31:28]),
//	.Out(HEX7)
//	);
//
//endmodule

//LABORATORIO 3 - OAC - CARLA KOIKE
//ALUNOS: 	ALDEGUNDES
//				DAVID
//				ESTEVAM CARDOSO 			13/0044342
//				JOAO
//				LUISA
//
//
//KEY3 Funciona como Clock manual
//KEY2 Muda entre clock manual ou automatico
//KEY1 Muda entre clock rapido ou lento
//KEY0 Reseta?
//
//Selecionando o que mostrar no display SW[2:0]
//Selecionando o Registrador a ser mostrado SW[7:3]
//
//Falta usar os Switches 8 e 9...
//
//
//
module TopDE (CLK_50, 
			  KEY, 
			  HEX0, //HEX0_DP, 
			  HEX1, //HEX1_DP, 
			  HEX2, //HEX2_DP,
			  HEX3, //HEX3_DP,
			  HEX4, //HEX4_DP,
			  HEX5, //HEX5_DP,
			  HEX6, //HEX6_DP,
			  HEX7, //HEX7_DP,
			  LEDR, 
			  SW,
			  PC,
			  wInstr);

/* I/O type definition */
input CLK_50;//Clock na placa 50MHz
input [3:0] KEY;//Botoes da placa (4)
input [9:0] SW;//Switches da placa (10)
output [9:0] LEDR;//LEDs vermelhos
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;//Display de 7 segmentos (8)
output wire [63:0] PC;
output wire [31:0] wInstr;

/* Local Clock signals */
reg CLKManual, CLKAutoSlow , CLKAutoFast, CLKSelectAuto, CLKSelectFast, CLK_5;
wire CLK;

integer CLKCount, CLKCount2, CLKCount5;

reg [63:0] wOutput_decide;

/* Local wires */
wire [63:0]  wRegDisp, extOpcode, wOutput, ALUresult;
wire [1:0] ALUOp,OrigALU, RegSrc, Mem2Reg, OrigPC;
wire MemWrite, MemRead, RegWrite;
wire [4:0] wRegDispSelect; // Seleciona quai registrador para vizualizar 
wire [10:0] wOpcode;

 
/* LEDs sinais de controle */
assign LEDR[1:0] =	Mem2Reg;
assign LEDR[3:2] =	OrigALU;
assign LEDR[5:4] =	RegSrc;
assign LEDR[7:6] =	OrigPC;
assign LEDR[9:8] =	ALUOp;
		
/* para apresentacao nos displays */
assign extOpcode = {21'b0,wOpcode};         ////// arrumar aqui !!!!!!!!!!!

assign ALURresult = 63'h5;

//Selecionando o Registrador a ser mostrado SW[7:3]
assign wRegDispSelect =	SW[7:3];//5 bits 32 registradores

//Selecionando o que mostrar no display SW[2:0]
always @(wOutput_decide,SW)
begin
	case(SW[2:0])//8 opcoes
		3'b000:
			wOutput_decide <= wRegDisp;
		3'b001:
			wOutput_decide <= PC;
		3'b010:
			wOutput_decide <= extOpcode;
		3'b011:
			wOutput_decide <= wInstr;
		3'b100:
			wOutput_decide <= ALUresult;
		3'b101:
			wOutput_decide <= extOpcode;
		default:
			begin
			wOutput_decide <= wRegDisp;
			end
	endcase
end

assign wOutput	= wOutput_decide;

//
//
//
/* Clocks */
assign CLK	= CLKSelectAuto ?
				 (CLKSelectFast ?
				  CLKAutoFast :
				  CLKAutoSlow) :
				  CLKManual;
//
//
//
/* Clock inicializacao */
initial
begin
	CLKManual	<= 1'b0;
	CLKAutoSlow	<= 1'b0;
	CLKAutoFast	<= 1'b0;
	CLKSelectAuto	<= 1'b0;//Começa manual
	CLKSelectFast	<= 1'b0;//Começa lento
	CLK_5 <= 1'b0;
	
end
//
//

//
always @(posedge KEY[3])
begin
	CLKManual <= ~CLKManual;       //KEY3 Funciona como Clock manual
end

always @(posedge KEY[2])			 //KEY2 Muda entre clock manual ou automatico 
begin
	CLKSelectAuto <= ~CLKSelectAuto;
end

always @(posedge KEY[1])			 //KEY1 Muda entre clock rapido ou lento
begin
	CLKSelectFast <= ~CLKSelectFast;
end
//
//
//
always @(posedge CLK_50)
begin

	if(CLKCount5 == 32'd99999)   // Clock da memoria 500Hz (32'd99999)
	begin
		CLK_5 = ~CLK_5;
		CLKCount5 = 0;
	end
	else
	begin
		CLKCount5 = CLKCount5 + 1;
	end

	if (CLKCount == 32'd9999999)	// Clock lento do processador 5Hz (Slow)
	begin
		CLKAutoSlow = ~CLKAutoSlow;
		CLKCount = 0;
	end
	else
	begin
		CLKCount = CLKCount + 1;
	end
	
	if (CLKCount2 == 32'd999999)  //  Clock rapido do pocessador 50Hz Fast
	begin
		CLKAutoFast = ~CLKAutoFast;
		CLKCount2 = 0;
	end
	else
	begin
		CLKCount2 = CLKCount2 + 1;
	end
	
end



// ARM Datapath instantiation

Datapath Datapath0 (
	.iCLK(CLK),
	.iCLKMem(CLK_5),
	.iCLK50(CLK_50),
	.iRST(KEY[0]),					//Será que está certo ~KEY[0]??
	
	.wPC(PC),
	.wCALUOp(ALUOp),
	.wCMemWrite(MemWrite),
	.wCMemRead(MemRead),
	.wCRegWrite(RegWrite),
	//.wCRegSrc(RegSrc),//era Dst mudei para Src
	
	.wRegDispSelect(wRegDispSelect),
	.wRegDisp(wRegDisp),
	.wOpcode(wOpcode),
	.woInstr(wInstr),
	.wCOrigALU(OrigALU),
	.wCMem2Reg(Mem2Reg)
//	.wCOrigPC(OrigPC),
	//.wALUresult(ALUresult)
	);

Decoder7 Dec0 (
	.In(wOutput[3:0]),
	.Out(HEX0)
	);

Decoder7 Dec1 (
	.In(wOutput[7:4]),
	.Out(HEX1)
	);

Decoder7 Dec2 (
	.In(wOutput[11:8]),
	.Out(HEX2)
	);

Decoder7 Dec3 (
	.In(wOutput[15:12]),
	.Out(HEX3)
	);

Decoder7 Dec4 (
	.In(wOutput[19:16]),
	.Out(HEX4)
	);

Decoder7 Dec5 (
	.In(wOutput[23:20]),
	.Out(HEX5)
	);

Decoder7 Dec6 (
	.In(wOutput[27:24]),
	.Out(HEX6)
	);

Decoder7 Dec7 (
	.In(wOutput[31:28]),
	.Out(HEX7)
	);

endmodule

