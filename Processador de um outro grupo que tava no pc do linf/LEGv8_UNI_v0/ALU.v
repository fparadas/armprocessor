/*Unidade logica aritmetica 32 bits com xor, sll ,srl*/

module ALU (Op, A, B, Out, Zero, Overflow, Shamt);

	input [3:0] Op;
	input [63:0] A,B;
	input [5:0] Shamt;
	output reg [63:0] Out;
	output Zero;
	output Overflow;
	
	assign Zero = (Out == 0);
	
	wire tmp = A < B ? 1'b1: 1'b0;
	
	always @(Op,A,B)
		case(Op)
			OPAND:
				Out <= A & B;	
				
			OPOR:
				Out <= A | B;
				
			OPADD:
				begin
					Out <= A + B;
					Overflow <= ((A[63] == 0 && B[63] == 0 &&  Out[63] == 1) || (A[63] == 1 && B[63] == 1 && Out[63] == 0)); 
				end
			
			OPSLL:
				Out <= (B << Shamt);
			
			OPSUB:
				begin
					Out <= A - B;
					Overflow <= ((A[63] == 0 && B[63] == 1 && Out[63]== 1)|| (A[63] == 1 && B[63] == 0 && Out[63] == 0));
				end
			
			OPXOR:
				Out <= A ^ B;
			
			OPSRL:
				Out <= (B >> Shamt);
			
			OPNOR:
				Out <= ~(A | B);
				
			OPLUI:
				Out <= B;
			
			default: 
				Out <= 0;
		endcase
endmodule
