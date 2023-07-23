/*
 * DataMemory.v
 *
 * Main processor data memory bank.
 * Stores information in 16K x 32bit for User and 2K x 32bit for System.
 */
module DataMemory (iCLK, iCLKMem, iAddress, iWriteData, iMemRead, iMemWrite, oMemData);


/* I/O type definition */
input wire iCLK, iCLKMem, iMemRead, iMemWrite;
input wire [63:0] iAddress, iWriteData;
output wire [63:0] oMemData;

reg MemWrited;
wire wMemWrite, wMemWriteMB0, wMemWriteMB1;
wire [63:0] wMemDataMB0, wMemDataMB1;


/*
 * Avoids writing twice in a CPU cycle, since the memory is not necessarily
 * synchronous.
 */
always @(iCLK)
begin
	MemWrited <= iCLK;
end

assign wMemWrite = (iMemWrite && ~MemWrited);
assign wMemWriteMB0 = (wMemWrite && (iAddress<64'h00004000));
assign wMemWriteMB1 = (wMemWrite && (iAddress>=64'h00004000) && (iAddress<64'h00004800));

assign oMemData = (iAddress < 64'h00004000 ? wMemDataMB0 :
						  (iAddress<64'h00004800)? wMemDataMB1 : ZERO);


UserDataBlock MB0 (
	.address(iAddress[15:2]),
	.clock(iCLKMem),
	.data(iWriteData),
	.wren(wMemWriteMB0),
	.q(wMemDataMB0)
	);


endmodule

