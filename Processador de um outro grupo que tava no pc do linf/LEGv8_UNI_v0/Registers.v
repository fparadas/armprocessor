/*
 * Registers.v
 *
 * Banco de registradores principais do processador
 * Armazena informacoes em registradores de 63 bits
 * 31 Registradores estao disponiveis para a leitura e 32 para escrita
 * Stores information in 32-bit registers. 31 registers are available for
 *
 * Also allows for two simultaneous data reads, has a write enable signal
 * input, is clocked and has an asynchronous reset signal input.
 */
 
module Registers (iCLK, iCLR, iReadRegister1, iReadRegister2, iWriteRegister,
	iWriteData, iRegWrite, oReadData1, oReadData2, iRegDispSelect, oRegDisp,iRegA0,iA0en);


input wire [4:0] iReadRegister1, iReadRegister2, iWriteRegister,
	iRegDispSelect;
input wire iCLK, iCLR, iRegWrite, iA0en;
	
input wire [63:0] iWriteData, iRegA0;
output wire [63:0] oReadData1, oReadData2, oRegDisp;


/* Banco de Registradores de 64 Bits */
reg [31:0] registers[63:0];

integer i;

/* Inicializa os 64 registradores com 0*/
initial
begin
	for (i = 0; i <= 31; i = i + 1)
	begin
		registers[i] = 64'b0;
	end
	// TODO = ARRUMAR APOS ARQUIVO DE MEMORIA
	registers[5'd28] = 64'd65400;  // $sp
end


/* Output definition */
assign oReadData1 =	registers[iReadRegister1];
assign oReadData2 =	registers[iReadRegister2];

assign oRegDisp =	registers[iRegDispSelect];


/* Main block for writing and reseting */
always @(posedge iCLK)
begin
	if (iCLR)
	begin
		for (i = 1; i <= 31; i = i + 1)
		begin
			registers[i] = 64'b0;
		end
		// TODO = ARRUMAR APOS ARQUIVO DE MEMORIA
		registers[5'd28] = 64'd65400;
	end
	else if (iCLK && iRegWrite)
	begin
		if (iWriteRegister != 5'b0)
		begin
			registers[iWriteRegister] =	iWriteData;
		end
	end

	/* Writing contents of iRegA0 into $a0 */
	// COMENTADO PORQUE PROVAVELMENTE EH USADO PARA SYSCALL
   //	if(iA0en)
   //		registers[5'd4] = iRegA0;
end

endmodule

