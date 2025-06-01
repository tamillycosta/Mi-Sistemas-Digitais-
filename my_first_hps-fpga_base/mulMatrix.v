module mulMatrix(MatA, MatB, Overflow, MatOut, clk, en, done);
	input 	[199:0]	MatA, MatB;
	input clk, en;
	output 				Overflow, done;
	output	[199:0]	MatOut;

	wire [24:0] singOverflow;
	wire [24:0] complete;
	assign Overflow = |singOverflow;
	assign done = &complete;

	genvar i, j;
	generate
		for (i = 0; i < 5; i = i + 1) begin: mac1
			for (j = 0; j < 5; j = j+1) begin: mac2
				mac8bc2 mac(MatA[(40*i)+39:(40*i)], 
				{MatB[(j*8)+167:(j*8)+160], MatB[(j*8)+127:(j*8)+120], MatB[(j*8)+87:(j*8)+80], MatB[(j*8)+47:(j*8)+40], MatB[(j*8)+7:(j*8)]}, 
				en,
				clk,
				MatOut[((8*j)+ 40 * i)+7:((8*j)+ 40 * i)],
				singOverflow[(i*5)+j],
				complete[(i*5)+j]);
			end
		end
	endgenerate	
endmodule