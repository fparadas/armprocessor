
module TopDE (
			  iCLK_50, 
			  KEY, 
			  HEX0, 
			  HEX1, 
			  HEX2,
			  HEX3,
			  HEX4,
			  HEX5,
			  LEDR,
			  SW,
			  //PC,
			  //RST
			  );

/* I/O type definition */
input iCLK_50;
input [3:0] KEY; //usamos para escolher o clock, e o 0 para dar reset
input [9:0] SW; // usamos as chaves 0,1,2 para escolher uma das opçoes de visualização no display de 7 segmentos
output [9:0] LEDR;// usamos para ver todos os bits de controle
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;


/* Local Clock signals */
reg CLKManual, CLKAutoSlow, CLKSelectAuto, CLKSelectFast, CLKAutoFast, CLK_5;
wire CLK, clock50_ctrl;

integer CLKCount, CLKCount2, CLKCount5;


/* Local wires */
wire[63:0] PC,RegResultULA; 
wire[23:0] PCLS;//colocar aqui os 24 bits menos significatiovos de PC
wire [31:0] wInstruction;
wire[4:0] DispReg;//Input do datapath wDispReg que usa as chaves para selecionar o reg a ser mostrado
wire [63:0] DataDispReg;// Valor contido no registrador escolhido
wire[23:0] OUT_DISP;
 


assign PCLS = PC[23:0];
assign DispReg = SW[9:5];

				
/* Clocks */

assign LEDR = {Reg2Loc, ALUSrc, Mem2Reg, RegWrite, MemRead, MemWrite, Branch, UncondBranch, ALUOp};// cada ledr é um sinal de controle 


always @(OUT_DISP, SW)
begin
	case(SW[2:0])
		3'b000:
			OUT_DISP <= PCLS; //ver os primeiros 24 bits de PC
		3'b001:
			OUT_DISP <= wInstruction[23:0];// ver os primeiros 24 bits de da instrução
		3'b010:
			OUT_DISP <= {{16'd0},wInstruction[31:24]};// ver os ultimos 8 bits de da instrução
		3'b011:
			OUT_DISP <= DataDispReg[23:0];// ver os primeiros 24 bits do registrador selecionado
		3'b100:
			OUT_DISP <= RegResultULA[23:0];//ver os primeiros 24 bits do reultado da ULA
//		3'b101:
//			wOutput_decide <= extOpcode;
//		default:
//			begin
//			OUT_DISP <= RegDisp;
//			end
	endcase
end



assign CLK	= CLKSelectAuto ?
				(CLKSelectFast ?
					CLKAutoFast :
					CLKAutoSlow) :
				CLKManual;

/* Clock inicializacao */
initial
begin
	CLKManual	<= 1'b0;
	CLKAutoSlow	<= 1'b0;
	CLKAutoFast	<= 1'b0;
	CLKSelectAuto	<= 1'b0;
	CLKSelectFast	<= 1'b0;
	CLK_5 <= 1'b0;
end

always @(posedge KEY[3])
begin
	CLKManual <= ~CLKManual;       // Manual
end

always @(posedge KEY[2])
begin
	CLKSelectAuto <= ~CLKSelectAuto;
end

always @(posedge KEY[1])
begin
	CLKSelectFast <= ~CLKSelectFast;
end

always @(posedge clock50_ctrl)
begin

	if(CLKCount5 == 32'd4)   // Clock da memoria
	begin
		CLK_5 = ~CLK_5;
		CLKCount5 = 0;
	end
	else
	begin
		CLKCount5 = CLKCount5 + 1;
	end

	if (CLKCount == 32'd9999999)	// Slow
	begin
		CLKAutoSlow = ~CLKAutoSlow;
		CLKCount = 0;
	end
	else
	begin
		CLKCount = CLKCount + 1;
	end
	
	if (CLKCount2 == 32'd30)  //  Fast
	begin
		CLKAutoFast = ~CLKAutoFast;
		CLKCount2 = 0;
	end
	else
	begin
		CLKCount2 = CLKCount2 + 1;
	end
	
end

//
///* Mono est�vel 10 segundos */
//mono Mono1 (iCLK_50,~SW[9],clock50_ctrl,~KEY[0]);]



datapath Datapath0 (
	.iCLK(CLK),
	.iCLKMem(CLK_5),
	.iCLK_50(iCLK_50),
	.iRST(~KEY[0]),
	.wPC(PC),
	.wRegResultULA(RegResultULA),
	.wCReg2Loc(Reg2Loc),
	.wCALUSrc(ALUSrc),
	.wCMem2Reg(Mem2Reg),
	.wCRegWrite(RegWrite),
	.wCMemRead(MemRead),
	.wCMemWrite(MemWrite),
	.wCBranch(Branch),
	.wCUncondBranch(UncondBranch),
	.wCALUOp(ALUOp),
	.wDispReg(DispReg),
	.wDataDispReg(DataDispReg)
);
	
	

Decoder7 Dec0 (
	.In(OUT_DISP[3:0]),
	.Out(HEX0)
	);

Decoder7 Dec1 (
	.In(OUT_DISP[7:4]),
	.Out(HEX1)
	);

Decoder7 Dec2 (
	.In(OUT_DISP[11:8]),
	.Out(HEX2)
	);

Decoder7 Dec3 (
	.In(OUT_DISP[15:12]),
	.Out(HEX3)
	);

Decoder7 Dec4 (
	.In(OUT_DISP[19:16]),
	.Out(HEX4)
	);

Decoder7 Dec5 (
	.In(OUT_DISP[23:20]),
	.Out(HEX5)
	);



endmodule
