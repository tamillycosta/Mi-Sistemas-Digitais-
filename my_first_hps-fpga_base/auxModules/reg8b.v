module reg8b(clk, rst, en, d, q);
	input clk, rst, en;
	input [7:0] d;
	output reg [7:0] q;
	
	always @(posedge clk, posedge rst) begin
		if(rst) begin
			q <= 8'b0;
		end else if (en) begin
			q <= d;
		end
	end
	

endmodule