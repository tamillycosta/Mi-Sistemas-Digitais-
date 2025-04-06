// modulo responssavel por selecionar o calculo de determinante baseado no tamanho da matriz 

module determinante (
			input clk,
			input [199:0] matriz1, 
			input [7:0] tamanho,
			output reg [7:0] resultado
	
); 

	 reg signed [7:0] matrizE [0:1][0:1]; //MATRIZ 2X2
	 reg signed [7:0] matrizJ[0:3][0:3];  // MATRIX 4X4
	 reg signed [7:0] matrizA[0:2][0:2];  // Matriz 3x3 armazenada em registradores
	 
	 reg signed  [7:0] tempResult;
	 
	 reg signed [15:0] det_temp;
	 
   reg signed [31:0] det_temp1, det_temp2, det_temp3, det_temp4;  // 32 bits para cálculos intermediários
	
	wire signed [7:0] result4x4;
	wire signed [7:0] result5x5;
	
	Determinante4x4(
		matriz1,
		result4x4,
		clk,
		tamanho
	);
	
	
	 matriz_deter5x5(
		matriz1,
		result5x5,
		clk,
		tamanho
	 
	 );
	
	
	integer i, j, k;
	

	always @(*) begin
	
	 // DETERMINATE 2X2
		if(tamanho == 8'b00000010) begin 
			 for (i = 0; i < 2; i = i + 1) begin
                for (j = 0; j < 2; j = j + 1) begin
                    matrizE[i][j] = matriz1[(i*2 + j) * 8 +: 8];
                end
            end
				
				 tempResult = (matrizE[0][0] * matrizE[1][1]) - (matrizE[0][1] * matrizE[1][0]);
				 resultado = (tempResult > 127) ? 127 : (tempResult < -128) ? -128 : tempResult;
        end
		  
		  
		 // DETERMINATE 3X3
		  else if (tamanho == 8'b00000011) begin 
				 for (i = 0; i < 3; i = i + 1) begin 
					for (j = 0; j < 3; j = j + 1) begin
						 matrizA[i][j] = matriz1[(i * 3 + j) * 8 +: 8];
					
			end
		  end
		  
		  det_temp = 
            (($signed(matrizA[0][0]) * $signed(matrizA[1][1]) * $signed(matrizA[2][2])) + 
            ($signed(matrizA[0][1]) * $signed(matrizA[1][2]) * $signed(matrizA[2][0])) + 
            ($signed(matrizA[0][2]) * $signed(matrizA[1][0]) * $signed(matrizA[2][1]))) - 
            (($signed(matrizA[0][1]) * $signed(matrizA[1][0]) * $signed(matrizA[2][2])) +
            ($signed(matrizA[0][0]) * $signed(matrizA[1][2]) * $signed(matrizA[2][1])) + 
            ($signed(matrizA[0][2]) * $signed(matrizA[1][1]) * $signed(matrizA[2][0])));
				
				 // **Tratamento de truncagem**
        if (det_temp > 127) begin
            resultado = 127;  
        end 
        else if (det_temp < -128) begin
            resultado = -128; 
        end 
        else begin
            resultado = det_temp[7:0];  
        end
		  
			end 
		  
		  // matriz 4x4
		  else if(tamanho == 8'b00000100) begin 
				resultado = result4x4;
			
			end
			
			else  if (tamanho == 8'b00000101) begin  
				resultado = result5x5;
			end 
		  
		  
	  end 
	  
	  
endmodule