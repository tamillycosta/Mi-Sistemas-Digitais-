module demux1b (
    input s,
    input [13:0] dataIn,
    output [13:0] dataOut1,
    output [13:0] dataOut2
);

    assign dataOut1 = (~s) ? dataIn : 14'b0;
    assign dataOut2 = (s) ? dataIn : 14'b0;
endmodule