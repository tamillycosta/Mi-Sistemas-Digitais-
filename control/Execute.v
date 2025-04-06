module Execute(
    input clk,
    input [2:0] opcode,
    input [199:0] OperandA,
    input [199:0] OperandB,
	
    input [7:0] matriz_size,
	 
    output [199:0] result
	
	 
);

	 reg signed [7:0] num;
    reg [199:0] matriz1, matriz2;


    always @(*) begin
        case (opcode)
            3'b000, 3'b001, 3'b010 : begin 
                matriz1 = OperandA;
                matriz2 = OperandB;
               num = 8'b0; // Não utilizado
            end
            3'b011: begin 
                matriz1 = OperandA;
                num = OperandB[7:0];
            end
				 3'b100, 3'b101, 3'b110: begin 
                matriz1 = OperandA;
                matriz2 = 200'b0;
                num = 8'b0;
            end
            3'b111: begin // Caso de opcode inválidos(sinaliza o fim das operacoes)
                matriz1 = 200'b0;
                matriz2 = 200'b0;
               num = 8'b0;
					 
            end
        endcase

    end

    // Instância da ULA
    ULA ula_inst (
		  .clk(clk),
        .matriz1(matriz1),
        .matriz2(matriz2),  
		  .escalar(num),
        .opcode(opcode),
		  .tamanho(matriz_size),
		  .resultado(result),
    );
	 
	 
	

endmodule
