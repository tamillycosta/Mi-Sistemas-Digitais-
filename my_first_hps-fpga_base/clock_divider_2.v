module clock_divider_2 (
    input  wire clk_in,     // Clock de entrada: 50 MHz
    input  wire rst,        // Reset síncrono
    output reg  clk_out     // Clock dividido: 25 MHz
);

    always @(posedge clk_in) begin
        if (rst)
            clk_out <= 0;
        else
            clk_out <= ~clk_out; // Inverte a cada borda de subida
    end

endmodule
