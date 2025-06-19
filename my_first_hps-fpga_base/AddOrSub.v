module AddOrSub(MatA, MatB, Select, MatOut, Overflow, clk);
	input [199:0] MatA, MatB;
	input Select;
	output [199:0] MatOut;
	output Overflow;
	input clk ;
	wire [199:0] negMatB;
	wire [199:0] addMatB;
	
	negateMatrix neg(MatB, negMatB, negOverflow);
	sumMatrix sum(MatA, addMatB, MatOut,  addOverflow , clk);
	
	assign Overflow = (Select) ? (negOverflow | addOverflow) : (addOverflow);
	assign addMatB = (Select) ? negMatB : MatB;
endmodule