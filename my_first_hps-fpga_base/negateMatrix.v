module negateMatrix(MatB, MatOut, Overflow);
	input 	[199:0]	MatB;
	output 	[199:0] 	MatOut;
	output 				Overflow;
	
	wire [25:0] singOverflow;
	
	assign Overflow = |singOverflow;
	
	genvar i;
	generate
		for (i = 0; i < 25; i = i + 1) begin: adder
			negate8bc2 neg(MatB[(8*i)+7:(8*i)], MatOut[(8*i)+7:(8*i)], singOverflow[i]);
		end
	endgenerate	
	
endmodule










