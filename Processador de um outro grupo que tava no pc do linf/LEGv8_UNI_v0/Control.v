/*
 * Controle
 *
 */
 
 module Control(
	iCLK,
	iOp,
	oReg2Loc,
	oALUSrc,
	oMemtoReg,
	oRegWrite,
	oMemRead,
	oMemWrite,
	oBranch,
	oUBranch,
	oOpALU,
	oRegDst
);

/* I/O type definition */
input wire iCLK;
input wire [10:0] iOp;
output wire  oReg2Loc,oMemtoReg,oRegWrite,oMemRead,oMemWrite,oBranch, oUBranch, oRegDst;
output wire[1:0] oOpALU, oALUSrc;
initial
begin
	oReg2Loc <= 1'b0;
	oALUSrc <= 2'b00;
	oMemtoReg <= 1'b0;
	oRegWrite <= 1'b0;
	oMemRead <= 1'b0;
	oMemWrite <= 1'b0;
	oBranch <= 1'b0;
	oUBranch <= 1'b0;
	oOpALU <= 2'b00;
	oRegDst <= 1'b0;
end

always @(iOp)
begin
	case(iOp)
			// ACESSO A MEMORIA	
		OPCSTUR:
			begin
				oReg2Loc <= 1'b1;
				oALUSrc <= 2'b01;
				oMemtoReg <= 1'bx;
				oRegWrite <= 1'b0;
				oMemRead <= 1'b0;
				oMemWrite <= 1'b1;
				oBranch <= 1'b0;
				oUBranch <= 1'b0;
				oOpALU <= 2'b00;
				oRegDst <= 1'b0;
			end
			
		OPCLDUR:
			begin
				oReg2Loc <= 1'bx;
				oALUSrc <= 2'b01;
				oMemtoReg <= 1'b1;
				oRegWrite <= 1'b1;
				oMemRead <= 1'b1;
				oMemWrite <= 1'b0;
				oBranch <= 1'b0;
				oUBranch <= 1'b0;
				oOpALU <= 2'b00;	
				oRegDst <= 1'b0;
				oRegDst <= 1'b0;
			end
			// SALTOS CONDICIONAL E INCONDICIONAL
		OPCCBZ:
			begin
				oReg2Loc <= 1'b1;
				oALUSrc <= 2'b00;
				oMemtoReg <= 1'bx;
				oRegWrite <= 1'b0;
				oMemRead <= 1'b0;
				oMemWrite <= 1'b0;
				oBranch <= 1'b1;
				oUBranch <= 1'b0;
				oOpALU <= 2'b01;
				oRegDst <= 1'b0;
			end

		OPCB:
			begin
				oReg2Loc <= 1'b1;
				oALUSrc <= 2'b00;
				oMemtoReg <= 1'bx;
				oRegWrite <= 1'b0;
				oMemRead <= 1'b0;
				oMemWrite <= 1'b0;
				oBranch <= 1'b0;
				oUBranch <= 1'b1;
				oOpALU <= 2'b01;
				oRegDst <= 1'b0;
			end
		
		OPCBL:
			begin
				oReg2Loc <= 1'b1;
				oALUSrc <= 2'b10;
				oMemtoReg <= 1'b0;
				oRegWrite <= 1'b1;
				oMemRead <= 1'b0;
				oMemWrite <= 1'b0;
				oBranch <= 1'b0;
				oUBranch <= 1'b1;
				oOpALU <= 2'b01;
				oRegDst <= 1'b1;
			end
		
		OPCBR:
			begin
				oReg2Loc <= 1'b1;
				oALUSrc <= 2'b00;
				oMemtoReg <= 1'b0;
				oRegWrite <= 1'b0;
				oMemRead <= 1'b0;
				oMemWrite <= 1'b0;
				oBranch <= 1'b0;
				oUBranch <= 1'b1;
				oOpALU <= 2'b10;
				oRegDst <= 1'b0;
			end
			// INSTRUCOES TIPO R
			
		OPCADD, OPCSUB, OPCAND, OPCORR:
			begin
				oReg2Loc <= 1'b0;
				oALUSrc <= 2'b00;
				oMemtoReg <= 1'b0;
				oRegWrite <= 1'b1;
				oMemRead <= 1'b0;
				oMemWrite <= 1'b0;
				oBranch <= 1'b0;
				oUBranch <= 1'b0;
				oOpALU <= 2'b10;
				oRegDst <= 1'b0;
			end
			
		default: // Instrucao Nao reconhecida
			begin
				oReg2Loc <= 1'b0;
				oALUSrc <= 2'b00;
				oMemtoReg <= 1'b0;
				oRegWrite <= 1'b0;
				oMemRead <= 1'b0;
				oMemWrite <= 1'b0;
				oBranch <= 1'b0;
				oUBranch <= 1'b0;
				oOpALU <= 2'b00;
				oRegDst <= 1'b0;
			end
	endcase
end

endmodule

