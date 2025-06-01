module sum8bc2 (inA, inB, outS, overflow);
	input [7:0] inA, inB;
	output [7:0] outS;
	output overflow;
	
	assign outS = inA + inB;
	assign overflow = (~inA[7] & ~inB[7] & outS[7]) | (inA[7] & inB[7] & ~outS[7]);
endmodule