module matriz_deter5x5(
    input [199:0] matriz,  // Entrada da matriz como vetor de 200 bits
    output reg signed [7:0] resultado,
    input clock,
    input [7:0] tamanho
);

integer i, j, k, l;
reg [2:0] estado;
reg signed[7:0] num;
reg signed [7:0] matrizE[0:3][0:3];
reg signed [7:0] matrizA[0:4][0:4];  // Matriz 4x4 armazenada em registradores
reg signed [31:0] temp [0:4];  // 32 bits para cálculos intermediários
reg signed [31:0] det_temp;
reg signed [31:0] det_temp1, det_temp2, det_temp3, det_temp4;  // 32 bits para cálculos intermediários


initial begin
    estado = 0;
    det_temp = 0;
end
always @(posedge clock) begin
    if (tamanho == 8'b00000101) begin  
        if(estado==0)begin
        // Carregar os valores da entrada para a matriz interna
  $display("truncou menos%0d", det_temp);
        for (i = 0; i < 5; i = i + 1) begin
                for (j = 0; j < 5; j = j + 1) begin
                    matrizA[i][j] = matriz[(5*i+j)*8 +: 8];
                   
                end
            end


           
            temp[0]=0;
            temp[1]=0;
            temp[2]=0;
            temp[3]=0;
            temp[4]=0;
        end

        
        num=matrizA[0][estado];

        for(i=0; i<4;i=i+1)begin
            k=0;
            for(j=0; j<4; j=j+1)begin
                if(k==estado)begin
                    k = k + 1;
                end
                matrizE[i][j]=matrizA[i+1][k];
                k=k+1;
            end
        end


        det_temp1 = 
            matrizE[0][0] * (
                (matrizE[1][1] * matrizE[2][2] * matrizE[3][3]) +
                (matrizE[1][2] * matrizE[2][3] * matrizE[3][1]) +
                (matrizE[1][3] * matrizE[2][1] * matrizE[3][2]) -
                (matrizE[1][3] * matrizE[2][2] * matrizE[3][1]) -
                (matrizE[1][1] * matrizE[2][3] * matrizE[3][2]) -
                (matrizE[1][2] * matrizE[2][1] * matrizE[3][3])
            );

        det_temp2 = 
            -matrizE[0][1] * (
                (matrizE[1][0] * matrizE[2][2] * matrizE[3][3]) +
                (matrizE[1][2] * matrizE[2][3] * matrizE[3][0]) +
                (matrizE[1][3] * matrizE[2][0] * matrizE[3][2]) -
                (matrizE[1][3] * matrizE[2][2] * matrizE[3][0]) -
                (matrizE[1][0] * matrizE[2][3] * matrizE[3][2]) -
                (matrizE[1][2] * matrizE[2][0] * matrizE[3][3])
            );

        det_temp3 = 
            matrizE[0][2] * (
                (matrizE[1][0] * matrizE[2][1] * matrizE[3][3]) +
                (matrizE[1][1] * matrizE[2][3] * matrizE[3][0]) +
                (matrizE[1][3] * matrizE[2][0] * matrizE[3][1]) -
                (matrizE[1][3] * matrizE[2][1] * matrizE[3][0]) -
                (matrizE[1][0] * matrizE[2][3] * matrizE[3][1]) -
                (matrizE[1][1] * matrizE[2][0] * matrizE[3][3])
            );

        det_temp4 = 
            -matrizE[0][3] * (
                (matrizE[1][0] * matrizE[2][1] * matrizE[3][2]) +
                (matrizE[1][1] * matrizE[2][2] * matrizE[3][0]) +
                (matrizE[1][2] * matrizE[2][0] * matrizE[3][1]) -
                (matrizE[1][2] * matrizE[2][1] * matrizE[3][0]) -
                (matrizE[1][0] * matrizE[2][2] * matrizE[3][1]) -
                (matrizE[1][1] * matrizE[2][0] * matrizE[3][2])
            );

        // Soma os termos da expansão de Laplace
        temp[estado] = det_temp1 + det_temp2 + det_temp3 + det_temp4;

       



        // **Tratamento de truncagem**
        if(estado == 4)begin
            det_temp = temp[0]-temp[1]+temp[2]-temp[3]+temp[4];
            if (det_temp > 127) begin
                resultado = 127;  
                
            end 
            else if (det_temp < -128) begin
                resultado = -128; 
              
            end 
            else begin
                resultado = det_temp[7:0];  
            end
          

            estado = 0;
        end else begin
            estado = estado + 1;
        end
    end
end

endmodule
