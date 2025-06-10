module registerBank25(clk, dataIn, clear, write, dataOut);
	input clk, write, clear;
	input [13:0] dataIn;
	output [199:0] dataOut;
	
	wire [7:0] dataRegOut[24:0];
	wire [24:0] regEnable;
	wire  [7:0] regDataIn[24:0];
	wire [7:0] colOut[5:0];
	wire [7:0] rowOutNotUsed[4:0];
	wire regclk;

	assign regclk = clk & write;

	assign regEnable = 25'h0000001 << ((dataIn[5:3] * 5) + dataIn[2:0]); //criar flag pra erro ao passar os parametros
	
	assign dataOut = {dataRegOut[24][7:0], dataRegOut[23][7:0], dataRegOut[22][7:0], dataRegOut[21][7:0], dataRegOut[20][7:0], dataRegOut[19][7:0], dataRegOut[18][7:0], dataRegOut[17][7:0], dataRegOut[16][7:0], dataRegOut[15][7:0], dataRegOut[14][7:0], dataRegOut[13][7:0], dataRegOut[12][7:0], dataRegOut[11][7:0], dataRegOut[10][7:0], dataRegOut[9][7:0], dataRegOut[8][7:0], dataRegOut[7][7:0], dataRegOut[6][7:0], dataRegOut[5][7:0], dataRegOut[4][7:0], dataRegOut[3][7:0], dataRegOut[2][7:0], dataRegOut[1][7:0], dataRegOut[0][7:0]};

	//dois demux onde um tem 8 sidas, que vao para outros 8 que tem mais 8 saidas
	demux3b row(dataIn[5:3], dataIn[13:6], colOut[0], colOut[1], colOut[2], colOut[3], colOut[4], colOut[5]);
	demux3b col0(dataIn[2:0], colOut[0], regDataIn[0], regDataIn[1], regDataIn[2], regDataIn[3], regDataIn[4], rowOutNotUsed[0]);
	demux3b col1(dataIn[2:0], colOut[1], regDataIn[5], regDataIn[6], regDataIn[7], regDataIn[8], regDataIn[9], rowOutNotUsed[1]);
	demux3b col2(dataIn[2:0], colOut[2], regDataIn[10], regDataIn[11], regDataIn[12], regDataIn[13], regDataIn[14], rowOutNotUsed[2]);
	demux3b col3(dataIn[2:0], colOut[3], regDataIn[15], regDataIn[16], regDataIn[17], regDataIn[18], regDataIn[19], rowOutNotUsed[3]);
	demux3b col4(dataIn[2:0], colOut[4], regDataIn[20], regDataIn[21], regDataIn[22], regDataIn[23], regDataIn[24], rowOutNotUsed[4]);
	
	genvar i;
	generate
		for(i = 0; i<25; i = i + 1) begin:register
			reg8b regis(regclk, clear, regEnable[i], regDataIn[i], dataRegOut[i]);
		end
	endgenerate
	
endmodule