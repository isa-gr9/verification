`timescale 1ns / 1ps

module multiplier #(parameter N = 11)(
  input logic [N-1:0] A,
  input logic [N-1:0] B,
  output logic [2*N - 1:0] result
);

logic [5 : 0][N:0] partProducts;
logic [5 : 0][N+2:0] ops;



// matrix1 creation -> partial product placement 
genvar i;
generate
  for (i = 0; i <= 5; i=i+1) begin : STAGE_1toN

    if (i == 0)

      LUT LUT0 (
        .sel({B[1:0], 1'b0}),
        .A_in(A),
        .out(partProducts[0][N:0])
      );

    else if (i == 5)
          LUT LUT5 (
            .sel({1'b0, B[N-1 : N-2]}),
            .A_in(A),
            .out(partProducts[5][N:0])
          );
    else 
    LUT LUTs (
      .sel(B[(2*i+1) : (2*i-1)]),
      .A_in(A),
      .out(partProducts[i][N:0])
    );
  end
endgenerate


//create the operators (ops) matrix (made of partial products properly complemented and sign-extended, still not added with S)

generate
  for (i = 0; i <= ((N-1)/2); i=i+1) begin

    assign ops[i][N:0] = partProducts[i][N:0];

    if (i == 0) assign ops[i][N+2:N+1] = {B[(2*i+1)],B[(2*i+1)]}; 
    else if (i <= 5) assign ops[i][N+2:N+1] = {1'b1, ~B[((2*i)+1)]};
  end
endgenerate


daddaTree dadda (.ops(ops), .product(result));



endmodule

