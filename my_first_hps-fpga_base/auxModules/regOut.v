module regOut (
    input clk,
    input write,
    input rst,
    input [199:0] dataIn,
    input [5:0] addr,
    output [7:0] data
);
    
    wire [7:0] dataOut[24:0];
    wire [7:0] dataToOutput[4:0];

    genvar i;

    mux3b col0(addr[2:0], dataOut[0], dataOut[1], dataOut[2], dataOut[3], dataOut[4], dataToOutput[0]);
    mux3b col1(addr[2:0], dataOut[5], dataOut[6], dataOut[7], dataOut[8], dataOut[9], dataToOutput[1]);
    mux3b col2(addr[2:0], dataOut[10], dataOut[11], dataOut[12], dataOut[13], dataOut[14], dataToOutput[2]);
    mux3b col3(addr[2:0], dataOut[15], dataOut[16], dataOut[17], dataOut[18], dataOut[19], dataToOutput[3]);
    mux3b col4(addr[2:0], dataOut[20], dataOut[21], dataOut[22], dataOut[23], dataOut[24], dataToOutput[4]);
    mux3b row(addr[5:3], dataToOutput[0], dataToOutput[1], dataToOutput[2], dataToOutput[3], dataToOutput[4], data);

    generate
        for(i = 0; i < 25; i = i + 1) begin:registers
            reg8b register(clk, rst, write, dataIn[(8*i)+7:(8*i)], dataOut[i]);
        end
    endgenerate


endmodule