module debouncer (
    input  wire clk,        // Clock do sistema
    input  wire rst,        // Reset síncrono
    input  wire btn_in,     // Sinal bruto do botão (com bounce)
    output reg  btn_out     // Sinal debounced
);

    // Parâmetro: número de bits do contador (ajusta tempo de debounce)
    parameter N = 19; // ~10ms a 50MHz

    reg [N-1:0] counter = 0;
    reg btn_sync_0, btn_sync_1;
    reg btn_stable;  // Estado estável do botão

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Resetar todos os registros
            btn_sync_0 <= 0;
            btn_sync_1 <= 0;
            btn_out <= 0;
            counter <= 0;
            btn_stable <= 0;
        end else begin
            // Sincronizar o sinal de entrada do botão com o clock
            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0;

            // Verificar se o estado do botão mudou
            if (btn_sync_1 != btn_stable) begin
                // Se houver mudança no sinal, começar a contar
                counter <= counter + 1;
                if (counter == {N{1'b1}}) begin
                    // Se o contador atingir o valor máximo (debounce completo)
                    btn_stable <= btn_sync_1;
                    counter <= 0;
                end
            end else begin
                counter <= 0; // Resetar o contador se não houver mudança
            end

            // Atualizar a saída do botão (1 enquanto pressionado, 0 enquanto solto)
            if (btn_stable == 1) begin
                btn_out <= 1;
            end else begin
                btn_out <= 0;
            end
        end
    end

endmodule
