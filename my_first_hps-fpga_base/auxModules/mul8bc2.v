module mul8bc2 (
  input  signed [7:0] a,
  input  signed [7:0] b,
  output reg signed [7:0] result,
  output reg overflow
);
  integer i;
  reg [7:0] abs_a, abs_b;
  reg [15:0] partial_sum;
  reg sign;
  reg signed [15:0] final_result;

  always @(*) begin
    // Valor absoluto
    abs_a = a[7] ? (~a + 1) : a;
    abs_b = b[7] ? (~b + 1) : b;

    // Sinal do resultado
    sign = a[7] ^ b[7];

    // Multiplicação por shift-and-add
    partial_sum = 16'd0;
    for (i = 0; i < 8; i = i + 1)
      if (abs_b[i])
        partial_sum = partial_sum + (abs_a << i);

    // Aplica o sinal
    final_result = sign ? (~partial_sum + 1) : partial_sum;
    result = final_result;

    // Verifica se o resultado cabe em signed [7:0]
    if (final_result < -16'sd128 || final_result > 16'sd127)
      overflow = 1;
    else
      overflow = 0;
  end
endmodule
