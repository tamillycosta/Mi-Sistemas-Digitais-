module ula(MatA, MatB, Esc, Op, Mat0, Overflow, clk, en, done);
	input		[199:0] 	MatA, MatB; //matrizes de entrada A e B
	input		[7:0] 	Esc; //escalar para as operaçoes com escalar
	input [1:0] Op; //operacao que sera realizada
	input clk, en; // clock, reset e sinal de enable
	output	reg [199:0]	Mat0; // matriz resultante da operaçao
	output reg Overflow;
	output done; //sinal de overflow e de fim da operaçao
	
	wire [199:0] resultMulEsc, resultMulMat, resultSum, resultSub; // matrizes temporarias para armazenar o resultado de cada operaçao
	
	wire [3:0] overflow; //bits de overflow para as 4 operaçoes

	wire [3:0] done_op; //sinal de finalizaçao para as 4 operacoes

	AddOrSub adder(MatA, MatB, 1'b0, resultSum, overflow[0]); //operaçao de soma
	AddOrSub subb(MatA, MatB, 1'b1, resultSub, overflow[1]); //operaçao de subtracao

	mulEscMatrix mulEsc(MatA, Esc, resultMulEsc, overflow[2]); //multiplicacao por escalar
	mulMatrix mulMat(MatA, MatB, overflow[3], resultMulMat, clk, en, done_op[3]); // multiplicacao de duas matrizes

	assign done = done_op[3];
	
	always @(posedge clk) begin
		if (Op == 2'b00 && en && done_op[3]) begin //caso seja operacao de soma
			Mat0 <= resultSum;
			Overflow <= overflow[0];
		end else if (Op == 2'b01 && en && done_op[3]) begin //caso seja operacao de subtraçao
			Mat0 <= resultSub;
			Overflow <= overflow[1];
		end else if (Op == 2'b10 && en && done_op[3]) begin //caso seja operacao de multiplicao por escalar
			Mat0 <= resultMulEsc;
			Overflow <= overflow[2];
		end else if (Op == 2'b11 && en && done_op[3])begin //caso seja multiplicaçao entre matrizes
			Mat0 <= resultMulMat;
			Overflow <= overflow[3];
		end
	end

endmodule