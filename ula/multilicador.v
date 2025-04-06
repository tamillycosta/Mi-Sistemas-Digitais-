module multiplicador(
    input [2:0] op,
    input clk,  
    input signed [199:0] Aa,
    input signed [199:0] Bb,
    output reg signed [199:0] Pp
);

    integer k, i, j, w;
    reg signed [7:0] a, b;
    reg signed [7:0] matrizA [0:4][0:4];
    reg signed [7:0] matrizB [0:4][0:4];
    reg signed [15:0] produto_completo;
	 
	 

    always @(posedge clk) begin
        if (op == 3'b010) begin
            //separa as entradas em matrizes para facilitar o trabalho com elas
            //inicia a saida com 0's
            for (i = 0; i < 5; i = i + 1) begin
                for (j = 0; j < 5; j = j + 1) begin
                    matrizA[i][j] = Aa[(5*i+j)*8 +: 8];
                    matrizB[i][j] = Bb[(5*i+j)*8 +: 8];
                    Pp[(5*i+j)*8 +: 8] = 0;
                end
            end


            for (i = 0; i < 5; i = i + 1) begin //Itera pela primeira matriz de entrada
                for(j = 0; j < 5; j = j + 1)begin //Itera pela segunda matriz de entrada
                    
                    //(re)inicia o valor do produto completo para cada posição da matriz de saida
                    produto_completo = 0;
                    for(k = 0; k < 5; k = k + 1)begin //Itera pelos valores da linha(em A) e coluna(em B)
                        a = matrizA[i][k];
                        b = matrizB[k][j];

                        // Multiplicação usando somas e deslocamento de bits
                        for (w = 0; w < 8; w = w + 1) begin
                            if (b[w]) 
                                produto_completo = produto_completo + (a << w);
                        end

                    // Armazena apenas os 8 bits menos significativos
						  
						   // tratamento de overflow
						   if(produto_completo > 127)  begin 
								 Pp[(5*i+j)*8 +: 8] = 127 ;
						  end else if (produto_completo < - 128) begin 
								  Pp[(5*i+j)*8 +: 8] = -128 ;
						  end else begin 
								 Pp[(5*i+j)*8 +: 8] = produto_completo[7:0];
						  end 
						  
						  
                   
                    end
                end
            end

        end else begin
            Pp = 0;  // Zera a saída quando o opcode não for o da multiplicação
        end
    end
endmodule