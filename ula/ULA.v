module ULA (
	input clk,
    input [199:0] matriz1, 
    input [199:0] matriz2, 
	input [7:0] escalar,
	input [7:0] tamanho,
    input [2:0] opcode,
    output reg [199:0] resultado
);
    integer i, j, k;
	 // usadas na operacao de multiplicacao e inversao
  
	 reg signed [7:0] matrizE [0:1][0:1];
	 reg signed [7:0] matrizA[0:2][0:2];  // Matriz 3x3 armazenada em registradores
	 reg signed [15:0] det_temp;
	 
    reg signed [7:0] temp;
	 

	  
	  wire signed [199:0] matrizDeterminante;
	 
	 
	  wire signed [199:0] matrizC;
	  
	 
	 multiplicador ( 
		opcode,
		clk,
		matriz1,
		matriz2,
		matrizC
	 
	 );
	 
	 
	 determinante(
		clk,
		matriz1,
		tamanho,
		matrizDeterminante
	 );
	 
	 
	 
	 
    always @(*) begin
      

        // Lógica da ULA baseada no opcode
        case (opcode)
            3'b000: begin // Soma de matrizes
                for (i = 0; i < 25; i = i + 1) begin
							 temp = matriz1[i * 8 +: 8] + matriz2[i * 8 +: 8]; 
						  
						   // tratamento de overflow
						    resultado[(i*8) +: 8] = (temp > 127) ? 127 : (temp < -128) ? -128 : temp;
                   	  
						  
                end
					 
            end

            3'b001: begin // Subtração de matrizes
                for (i = 0; i < 25; i = i + 1) begin
							temp = $signed(matriz1[i * 8 +: 8]) - $signed(matriz2[i * 8 +: 8]); 
						  
						  // tratamento de overflow
						   resultado[(i*8) +: 8] = (temp > 127) ? 127 : (temp < -128) ? -128 : temp;
						  
                end
            end
				
				
				 3'b010: begin // multiplicacao matriz
                for (i = 0; i < 25; i = i + 1) begin
                     resultado[i * 8 +: 8] =  matrizC[i * 8 +: 8]; 
							
							 
                end
            end

            
            3'b011: begin // Multiplicação por escalar
                for (i = 0; i < 25; i = i + 1) begin
							temp =  matriz1[i * 8 +: 8] * escalar;
                     resultado[(i*8) +: 8] = (temp > 127) ? 127 : (temp < -128) ? -128 : temp;
                end
            end
				
				 
				3'b100 : begin // transposicao
					  for (i = 0; i < 5; i = i + 1) begin
                        for (j = 0; j < 5; j = j + 1) begin
                            //coloca o numero da posição [i][j] da matriz na posição [j][i] do resultado,
                            //trocando linha pela coluna e vice versa
                            resultado[8*(i + 5*j) +: 8] = matriz1[8*(j + 5*i) +: 8]; 
                        end
                end
            end
					
					
		3'b101: begin // oposta 
			for(i = 0; i < 25; i = i + 1) begin
            temp = -$signed(matriz1[(i*8) +: 8]);
            resultado[(i*8) +: 8] = (temp > 127) ? 127 : (temp < -128) ? -128 : temp;
        end
		end 
		
	
	 3'b110 : begin // determinate 
		
			  for (i = 0; i < 25; i = i + 1) begin
                     resultado[i * 8 +: 8] = matrizDeterminante[i * 8 +: 8]; 
							 
                end
			
        
		end 

            default: resultado = 200'b0; 
        endcase
    end
endmodule