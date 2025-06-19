module demux3b (
    input [2:0] s,
    input [7:0] dataIn,
    output [7:0] dataOut0,
    output [7:0] dataOut1,
    output [7:0] dataOut2,
    output [7:0] dataOut3,
    output [7:0] dataOut4,
    output [7:0] dataOut5
);
    assign dataOut0 = (s == 3'b000) ? dataIn:8'b0;
    assign dataOut1 = (s == 3'b001) ? dataIn:8'b0;
    assign dataOut2 = (s == 3'b010) ? dataIn:8'b0;
    assign dataOut3 = (s == 3'b011) ? dataIn:8'b0;
    assign dataOut4 = (s == 3'b100) ? dataIn:8'b0;
    assign dataOut5 = (s > 3'b100) ? 8'b0:8'b0;

endmodule