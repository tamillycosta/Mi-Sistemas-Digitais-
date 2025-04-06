module matriz_deter5x5(
    input [199:0] matriz,
    output reg signed [7:0] resultado,
    input clock,
    input [7:0] tamanho
);

integer i, j, k;
reg [2:0] estado; //contagem para os ciclos de clock da operação
reg signed[7:0] num;
reg signed [7:0] matrizE[0:3][0:3]; //matriz para armazenar as matrizes 4x4 de dentro da 5x5
reg signed [7:0] matrizA[0:4][0:4];  // Matriz 5x5 para armazenar os dados de entrada
//  registradores de 32 bits para cálculos intermediários
reg signed [31:0] temp [0:4];  
reg signed [31:0] det_temp;
reg signed [31:0] det_temp1, det_temp2, det_temp3, det_temp4;  


initial begin
    estado = 0;
    det_temp = 0;
end
always @(posedge clock) begin
    if (tamanho == 8'b00000101) begin  
        if(estado==0)begin
        // Carregar os valores da entrada para a matriz interna
        for (i = 0; i < 5; i = i + 1) begin
                for (j = 0; j < 5; j = j + 1) begin
                    matrizA[i][j] = matriz[(5*i+j)*8 +: 8];
                   
                end
            end


           
            //garante que os valores temporarios sejam reinicializados sempre que a conta recomeça
            temp[0]=0;
            temp[1]=0;
            temp[2]=0;
            temp[3]=0;
            temp[4]=0;
        end

        //numero da primeira linha para o teorema de laplace
        num=matrizA[0][estado];

        //separa a matriz 5x5 em uma matriz 4x4 sem usar a linha e coluna do lumero selecionado
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


        //calculo da determinante da matriz 4x4 feito em 1 ciclo de clock
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

        // Soma os termos da expansão de Laplace da matriz 4x4
        temp[estado] = det_temp1 + det_temp2 + det_temp3 + det_temp4;

       




        if(estado == 4)begin
            //soma os 5 valores do teorema de laplace para achar a determinante da matriz 5x5
            det_temp = temp[0]-temp[1]+temp[2]-temp[3]+temp[4];

            //trata o overflow
            if (det_temp > 127) begin
                resultado = 127;  
                
            end 
            else if (det_temp < -128) begin
                resultado = -128; 
              
            end 
            else begin
                resultado = det_temp[7:0];  
            end
            //reinicia a conta
            estado = 0;

        end else begin
            estado = estado + 1;
        end
    end
end

endmodule
