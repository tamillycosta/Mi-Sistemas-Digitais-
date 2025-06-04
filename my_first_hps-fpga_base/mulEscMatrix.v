module mulEscMatrix(MatA, Esc, MatOut, Overflow);
	input		[199:0]	MatA;
	input		[7:0]		Esc;
	output 	[199:0]	MatOut;
	output 				Overflow;
	
	// Instanciar 25 multiplicadores com saturação
	wire [7:0] mult_results [0:24];
	wire mult_overflows [0:24];
	reg [199:0] MatOut_reg;
	reg Overflow_reg;
	integer i;
	
	// Gerar 25 instâncias do multiplicador
	genvar j;
	generate
		for (j = 0; j < 25; j = j + 1) begin : mult_gen
			mul8bc2_escalar mult_inst (
				.a(MatA[j*8 +: 8]),
				.b(Esc),
				.result(mult_results[j]),
				.overflow(mult_overflows[j])
			);
		end
	endgenerate
	
	// Combinar resultados
	always @(*) begin
		Overflow_reg = 1'b0;
		for (i = 0; i < 25; i = i + 1) begin
			MatOut_reg[i*8 +: 8] = mult_results[i];
			if (mult_overflows[i])
				Overflow_reg = 1'b1;
		end
	end
	
	assign MatOut = MatOut_reg;
	assign Overflow = Overflow_reg;
	
endmodule