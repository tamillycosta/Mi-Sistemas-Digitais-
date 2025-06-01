module sumMatrix(MatA, MatB, Overflow, MatOut);
	input 	[199:0]	MatA, MatB;
	output 				Overflow;
	output	[199:0]	MatOut;
	
	wire [24:0] singOverflow;
	
	assign Overflow = |singOverflow;
	
	genvar i;
	generate
		for (i = 0; i < 25; i = i + 1) begin: adder
			sum8bc2 sum(MatA[(8*i)+7:(8*i)], MatB[(8*i)+7:(8*i)], MatOut[(8*i)+7:(8*i)], singOverflow[i]);
		end
	endgenerate	
endmodule