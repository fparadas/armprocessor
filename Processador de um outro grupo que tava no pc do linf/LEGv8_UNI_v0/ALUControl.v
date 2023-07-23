/*
 * ALUcontrol.v
 *
 * Arithmetic Logic Unit control module.
 * Generates control signal to the ALU depending on the opcode and the funct field in the
 * current operation and on the signal sent by the processor control module.
 *
 * ALUOp	|	Control signal
 * -------------------------------------------
 * 00		|	The ALU performs an add operation.
 * 01		|	The ALU performs a subtract operation.
 * 10		|	The funct field determines the ALU operation.
 * 11		|	The opcode field determines the ALU operation.
 */
 
module ALUControl (iOpcode, iALUOp, oControlSignal);


/* I/O type definition */
input wire [10:0] iOpcode;
input wire [1:0] iALUOp;
output reg [3:0] oControlSignal;

always @(iALUOp)
begin
	case (iALUOp)
		2'b00:
			oControlSignal <=	OPADD;
		2'b01:
			oControlSignal <=	OPLUI;
		2'b10:
			begin
				case ({iOpcode[9],iOpcode[8],iOpcode[3]})
					3'b001:
						oControlSignal <= OPADD;
					3'b101:
						oControlSignal <= OPSUB;
					3'b000:
						oControlSignal <= OPAND;
					3'b010:
						oControlSignal <= OPOR;
					default:
						oControlSignal <= 4'b0000;
				endcase
			end
	endcase
end

endmodule
