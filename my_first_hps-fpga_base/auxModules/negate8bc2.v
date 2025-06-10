module negate8bc2(inA, outN, overflow);
	input [7:0] inA;
	output [7:0] outN;
	output overflow;
	
	assign outN = ~inA + 1'b1;
	assign overflow = inA[7]&(&(~inA[6:0]));
endmodule