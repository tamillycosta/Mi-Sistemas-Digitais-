module mux3b(
    input [2:0] sel,
    input [7:0] a, b, c, d, e,
    output reg [7:0] data
);

    always @(*) begin
        if (sel == 3'b000) begin
            data <= a;
        end else if (sel == 3'b001) begin
            data <= b;
        end else if (sel == 3'b010) begin
            data <= c;
        end else if (sel == 3'b011) begin
            data <= d;
        end else if (sel == 3'b100) begin
            data <= e;
        end
    end
endmodule