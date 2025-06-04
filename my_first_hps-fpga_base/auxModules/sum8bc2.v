module sum8bc2 (inA, inB, outS, overflow);
    input [7:0] inA, inB;
    output [7:0] outS;
    output overflow;
    wire [7:0] normal_result;
    wire positive_overflow, negative_overflow;
    
    assign normal_result = inA + inB;
    
    // Detecta os dois tipos de overflow
    assign positive_overflow = (~inA[7] & ~inB[7] & normal_result[7]);  // Overflow positivo
    assign negative_overflow = (inA[7] & inB[7] & ~normal_result[7]);   // Overflow negativo  
    assign overflow = positive_overflow | negative_overflow;
    
    // Saturação diferenciada por tipo de overflow
    assign outS = positive_overflow ? 8'b01111111 :      // +127 para overflow positivo
                  negative_overflow ? 8'b10000000 :      // -128 para overflow negativo
                  normal_result;                         // Resultado normal
    
endmodule