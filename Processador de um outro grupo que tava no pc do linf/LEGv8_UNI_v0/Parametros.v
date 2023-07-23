/* Parametros Gerais*/
parameter ON = 1'b1,
		    OFF = 1'b0,
		    ZERO = 64'b00000000,
		  
/* Operacoes da ULA */
			OPAND	= 4'b0000,	//0
			OPOR	= 4'b0001,	//1
			OPADD	= 4'b0010,	//2
			
			OPSLL	= 4'b0101,	//5
			OPSUB	= 4'b0110,	//6
			OPLUI	= 4'b0111,	//7
			OPXOR	= 4'b1000,	//8
			
			OPSRL	= 4'b1010,	//10
			OPNOR	= 4'b1100,	//12
			

/* Campo OPCODE */
			OPCLDUR		= 11'b11111000010,
			OPCSTUR		= 11'b11111000000,
			OPCORR		= 11'b10101010000,
			OPCCBZ		= 11'b10110100XXX,
			OPCB			= 11'b000101XXXXX,
			OPCBL			= 11'b100101XXXXX,
			OPCBR			= 11'b11010110000,
			OPCADD		= 11'b10001011000,
			OPCSUB		= 11'b11001011000,
			OPCAND		= 11'b10001010000;
			
			
			