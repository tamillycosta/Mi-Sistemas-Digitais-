module mulEscMatrix(MatA, Esc, MatOut, Overflow);
	input		[199:0]	MatA;
	input		[7:0]		Esc;
	output 	[199:0]	MatOut;
	output 				Overflow;
	
	assign MatOut = Esc * MatA;
	
endmodule