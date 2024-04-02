`timescale 1ns / 1ps

module CSA #(parameter int sizeCSA = 22, int sizeRCA = 4) (
    input logic [sizeCSA-1:0] A,
    input logic [sizeCSA-1:0] B,
    input logic Carry_i,
    output logic [sizeCSA-1:0] S,
    output logic Carry_o
    );

parameter int tempSize = ((sizeCSA / sizeRCA) + 1) * sizeRCA;
logic carrySel[(tempSize/sizeRCA)-1 : 0];

logic [tempSize-1 : 0] A_temp;
logic [tempSize-1 : 0] B_temp;
logic [tempSize-1 : 0] S_temp;

assign A_temp[sizeCSA-1:0] = {2'b00, A[(sizeCSA-1):0]};;
assign B_temp[sizeCSA-1:0] = {2'b00, B[(sizeCSA-1):0]};;

CS_block #(.sizeRCA(sizeRCA)) firstBlock  (
            .A(A_temp[sizeRCA - 1 : 0]),
            .B(B_temp[sizeRCA - 1 : 0]),
            .sel(Carry_i),
            .S(S_temp[sizeRCA - 1 : 0]),
            .Carry_o(carrySel[0])
        );

genvar i;
generate
    for (i = 1; i <= (tempSize/sizeRCA)-1; i=i+1) begin : STAGE_1toN

        CS_block #(.sizeRCA(sizeRCA)) RCA0  (
            .A(A_temp[((i * sizeRCA)+(sizeRCA - 1)) : i * sizeRCA]),
            .B(B_temp[((i * sizeRCA)+(sizeRCA - 1)) : i * sizeRCA]),
            .sel(carrySel[i-1]),
            .S(S_temp[((i * sizeRCA)+(sizeRCA - 1)) : i * sizeRCA]),   
            .Carry_o(carrySel[i])
        );

    end   
endgenerate

assign Carry_o = carrySel[(sizeCSA/sizeRCA)-1];
assign S[sizeCSA-1 : 0] = S_temp[sizeCSA-1 : 0];
    
endmodule
