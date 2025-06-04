module mul8bc2_escalar (
  input  signed [7:0] a,
  input  signed [7:0] b,
  output reg signed [7:0] result,
  output reg overflow
);
  
  // Implementação usando shifts e somas (sem multiplicadores dedicados)
  reg signed [15:0] mult_result;
  reg [7:0] abs_a, abs_b;
  reg sign_result;
  integer i;
  
  always @(*) begin
    // Determinar sinal do resultado
    sign_result = a[7] ^ b[7];
    
    // Valores absolutos
    abs_a = a[7] ? (~a + 1) : a;
    abs_b = b[7] ? (~b + 1) : b;
    
    // Multiplicação por shifts e somas
    mult_result = 16'b0;
    for (i = 0; i < 8; i = i + 1) begin
      if (abs_b[i])
        mult_result = mult_result + (abs_a << i);
    end
    
    // Aplicar sinal
    if (sign_result)
      mult_result = ~mult_result + 1;
    
    // Verificar overflow e saturar
    if (mult_result > 127) begin
      result = 127;
      overflow = 1'b1;
    end
    else if (mult_result < -128) begin
      result = -128;
      overflow = 1'b1;
    end
    else begin
      result = mult_result[7:0];
      overflow = 1'b0;
    end
  end
  
endmodule