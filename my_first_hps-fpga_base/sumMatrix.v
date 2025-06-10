module sumMatrix(
    input [199:0] MatA, MatB,
    output reg [199:0] result,
    output reg overflow,
	  input clk
);

// Registradores para armazenar os resultados das multiplicações
reg signed [15:0] mult_results [0:24];
reg signed [19:0] total_sum;
reg [4:0] counter;
reg signed [7:0] matA_element, matB_element;
reg signed [15:0] mult_result;
reg rst;
// Extrair elementos das matrizes baseado no counter
always @(*) begin
    case (counter)
        5'd0:  begin matA_element = $signed(MatA[7:0]);     matB_element = $signed(MatB[7:0]); end
        5'd1:  begin matA_element = $signed(MatA[15:8]);    matB_element = $signed(MatB[15:8]); end
        5'd2:  begin matA_element = $signed(MatA[23:16]);   matB_element = $signed(MatB[23:16]); end
        5'd3:  begin matA_element = $signed(MatA[31:24]);   matB_element = $signed(MatB[31:24]); end
        5'd4:  begin matA_element = $signed(MatA[39:32]);   matB_element = $signed(MatB[39:32]); end
        5'd5:  begin matA_element = $signed(MatA[47:40]);   matB_element = $signed(MatB[47:40]); end
        5'd6:  begin matA_element = $signed(MatA[55:48]);   matB_element = $signed(MatB[55:48]); end
        5'd7:  begin matA_element = $signed(MatA[63:56]);   matB_element = $signed(MatB[63:56]); end
        5'd8:  begin matA_element = $signed(MatA[71:64]);   matB_element = $signed(MatB[71:64]); end
        5'd9:  begin matA_element = $signed(MatA[79:72]);   matB_element = $signed(MatB[79:72]); end
        5'd10: begin matA_element = $signed(MatA[87:80]);   matB_element = $signed(MatB[87:80]); end
        5'd11: begin matA_element = $signed(MatA[95:88]);   matB_element = $signed(MatB[95:88]); end
        5'd12: begin matA_element = $signed(MatA[103:96]);  matB_element = $signed(MatB[103:96]); end
        5'd13: begin matA_element = $signed(MatA[111:104]); matB_element = $signed(MatB[111:104]); end
        5'd14: begin matA_element = $signed(MatA[119:112]); matB_element = $signed(MatB[119:112]); end
        5'd15: begin matA_element = $signed(MatA[127:120]); matB_element = $signed(MatB[127:120]); end
        5'd16: begin matA_element = $signed(MatA[135:128]); matB_element = $signed(MatB[135:128]); end
        5'd17: begin matA_element = $signed(MatA[143:136]); matB_element = $signed(MatB[143:136]); end
        5'd18: begin matA_element = $signed(MatA[151:144]); matB_element = $signed(MatB[151:144]); end
        5'd19: begin matA_element = $signed(MatA[159:152]); matB_element = $signed(MatB[159:152]); end
        5'd20: begin matA_element = $signed(MatA[167:160]); matB_element = $signed(MatB[167:160]); end
        5'd21: begin matA_element = $signed(MatA[175:168]); matB_element = $signed(MatB[175:168]); end
        5'd22: begin matA_element = $signed(MatA[183:176]); matB_element = $signed(MatB[183:176]); end
        5'd23: begin matA_element = $signed(MatA[191:184]); matB_element = $signed(MatB[191:184]); end
        5'd24: begin matA_element = $signed(MatA[199:192]); matB_element = $signed(MatB[199:192]); end
        default: begin matA_element = 8'b0; matB_element = 8'b0; end
    endcase
end

// Multiplicação
always @(*) begin
    mult_result = matA_element * matB_element;
end

always @(posedge clk ) begin
    if (rst) begin
        counter <= 0;
        result <= 200'b0;
        overflow <= 0;
        total_sum <= 0;
        // Inicializar array de multiplicações
        mult_results[0] <= 0;  mult_results[1] <= 0;  mult_results[2] <= 0;  mult_results[3] <= 0;  mult_results[4] <= 0;
        mult_results[5] <= 0;  mult_results[6] <= 0;  mult_results[7] <= 0;  mult_results[8] <= 0;  mult_results[9] <= 0;
        mult_results[10] <= 0; mult_results[11] <= 0; mult_results[12] <= 0; mult_results[13] <= 0; mult_results[14] <= 0;
        mult_results[15] <= 0; mult_results[16] <= 0; mult_results[17] <= 0; mult_results[18] <= 0; mult_results[19] <= 0;
        mult_results[20] <= 0; mult_results[21] <= 0; mult_results[22] <= 0; mult_results[23] <= 0; mult_results[24] <= 0;
    end else begin
        // Armazenar resultado da multiplicação no array
        mult_results[counter] <= mult_result;
        
        // Quando termina as 25 multiplicações, soma tudo
        if (counter == 24) begin
            counter <= 0;
            // Soma todos os 25 resultados
            total_sum <= mult_results[0] + mult_results[1] + mult_results[2] + mult_results[3] + mult_results[4] +
                        mult_results[5] + mult_results[6] + mult_results[7] + mult_results[8] + mult_results[9] +
                        mult_results[10] + mult_results[11] + mult_results[12] + mult_results[13] + mult_results[14] +
                        mult_results[15] + mult_results[16] + mult_results[17] + mult_results[18] + mult_results[19] +
                        mult_results[20] + mult_results[21] + mult_results[22] + mult_results[23] + mult_results[24];
            
            // Verifica overflow e atualiza resultado
            overflow <= (total_sum > 127 || total_sum < -128);
            if (total_sum > 127) begin
                result[7:0] <= 8'b01111111;
            end else if (total_sum < -128) begin
                result[7:0] <= 8'b10000000;
            end else begin
                result[7:0] <= total_sum[7:0];
            end
            result[199:8] <= 192'b0;
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule