module mac8bc2(
    inA, inB, en, clk, result, overflow, done
);

    input  [39:0] inA, inB; //linha de a e coluna de b
    input clk, en;
    output [7:0] result; //exatamente um numero da matriz c
    output overflow;
    output reg done;

    reg rst;
    
    reg signed [7:0] acc; //acumulador

    wire [39:0] mul_partial; //resultado da multiplicação de cada par de elementos
    wire [7:0] sum_result; //resultado da soma
    wire [8:0] overflow_op; //se houve overflow em uma das duas operações
    
    reg [7:0] mul_result; //registrador auxiliar para fazer a soma dos resultadores

    reg [2:0] count; //contador

    genvar i;
    generate
        for (i=0; i < 5; i = i+1) begin: mac_s
            mul8bc2 macs(inA[(8*i)+7:(8*i)], inB[(8*i)+7:(8*i)], mul_partial[(8*i)+7:(8*i)], overflow_op[i]);
        end
    endgenerate

    sum8bc2 accumulator(acc, mul_result, sum_result, overflow_op[5]);

    //overflow nas operações de soma
    assign overflow_op[6] = overflow_op[5]; 
    assign overflow_op[7] = overflow_op[6] & overflow_op[5];
    assign overflow_op[8] = overflow_op[7] & overflow_op[6] & overflow_op[5];

    //MAC com maquina de estados
    always @(posedge clk ) begin

        //reseta todos os valores
        if (rst) begin 
            acc <= 0;
            mul_result <= 0;
            count <= 0;
            rst <= 1'b0;
            done <= 1'b0;

            
        end else if (en) begin

            //acumulador recebe a ultima soma
            acc <= sum_result;

            //separa os bits para a primeira soma
            if (count == 3'b0) begin
                mul_result <= mul_partial[7:0];
                count <= count + 1;

            //separa os bits para a segunda soma
            end else if (count == 3'b001) begin
                mul_result <= mul_partial[15:8];
                count <= count + 1;
            
            //separa os bits para a terceira soma
            end else if (count == 3'b010) begin
                mul_result <= mul_partial[23:16];
                count <= count + 1;
            
            //realiza a quarta soma
            end else if (count == 3'b011) begin
                mul_result <= mul_partial[31:24];
                count <= count + 1;

            //separa os bits para a quinta soma
            end else if (count == 3'b100) begin
                mul_result <= mul_partial[39:32];
                count <= count + 1;
            
            //enquanto não houver um reset, mantem o valor da ultima soma realizada
            end else if (count == 3'b101) begin
                mul_result = 8'b0;
                done <= 1'b1;
                rst <= 1'b1;
            end
        end
    end
    

    
    assign result = acc;

    assign overflow = |overflow_op;
    
    
endmodule