module negate8bc2(inA, outN, overflow);
    input [7:0] inA;
    output [7:0] outN;
    output overflow;
    
    wire [7:0] normal_result;
    
    assign normal_result = ~inA + 1'b1;
    assign overflow = inA[7]&(&(~inA[6:0]));  // Detecta inA = -128
    
    // CORREÇÃO: Quando overflow, retorna +127 (máximo positivo possível)
    assign outN = overflow ? 8'b01111111 : normal_result;  // 01111111 = +127
    
endmodule