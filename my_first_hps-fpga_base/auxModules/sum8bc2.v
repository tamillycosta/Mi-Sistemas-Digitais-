module sum8bc2 (inA, inB, outS);
    input [7:0] inA, inB;
    output [15:0] outS;
    
    wire signed [15:0] full_result;
    wire signed [7:0] inA_signed, inB_signed;
    
    assign inA_signed = inA;
    assign inB_signed = inB;
    assign full_result = inA_signed * inB_signed;
    assign outS = full_result;
endmodule
