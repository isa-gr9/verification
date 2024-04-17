`timescale 1ns / 1ps

module RCA #(parameter int N = 4) (
    input logic [N-1:0] A,
    input logic [N-1:0] B,
    input logic Carry_i,
    output logic [N-1:0] S,
    output logic Carry_o
);
  
logic [N-1:0] STMP;
logic [N:0] CTMP;



genvar i;
generate
    for(i = 1; i < N + 1; i = i+1)
    begin 
        fullAdder FA (
            .a(A[i-1]),
            .b(B[i-1]),
            .Cin(CTMP[i-1]),
            .s(STMP[i-1]),
            .Co(CTMP[i])
            );
    end
endgenerate

assign CTMP[0] = Carry_i;
assign S = STMP;
assign Carry_o = CTMP[N];

 
endmodule

