`timescale 1 ns / 1 ns

module daddaTree (
  input logic [5:0][13:0] ops, //operands to be summed
  output logic [21:0] product // final sum 
);

logic [5:0][21:0] M0;
logic [5:0][21:0] M1;
logic [3:0][21:0] M2;
logic [2:0][21:0] M3;
logic [21:0] op1;
logic [22:0] op2;
logic [22:0] csa_result;
logic [22:0] result;   //just to debug


genvar i;


//MO generation
generate 
  for (i = 0; i<=5; i= i+1) begin 

    if (i == 5)
    assign M0[i][21 : 10]  = ops[i]; //in each line of M0, put a partial product (saved in "ops" matrix)
    else begin
    assign M0[i][13 + 2*i : 0 + 2*i]  = ops[i]; //in each line of M0, put a partial product (saved in "ops" matrix)
    assign M0[i+1][2*i +1] = 0; //shift each partProd
    end

    // necessary S that has to be added to each line, to represent the partProd in 2's complement
    if (i == 0) 
      assign M0[i+1][2*i] = ops[i][12]; // take the sign bit from the partial product matrix as it is
    else begin
    assign M0[i+1][2*i] = ~ops[i][12]; //take the sign bit from the partial product matrix and complement it
    end    


  end
endgenerate

//filling with 0s
assign M0[0][21:14]  = 0;
assign M0[1][21:16]  = 0;
assign M0[2][21:18]  = 0;
assign M0[2][1:0]  = 0;
assign M0[3][21:20]  = 0;
assign M0[3][3:0]  = 0;
assign M0[4][5:0]  = 0;
assign M0[5][7:0]  = 0;


// M1 generation: adjust the elements positions (form a V-shape)
assign M1[0][14]    = ~ops[0][12]; // add the final ~S bit to the first partial product
assign M1[0][13:0]  = M0[0][13:0];
assign M1[0][21:15] = M0[5][21:15];
assign M1[1][15:0]  = M0[1][15:0];
assign M1[1][21:16] = M0[4][21:16];
assign M1[2][17:0]  = M0[2][17:0];
assign M1[2][19:18] = M0[3][19:18];
assign M1[2][21:20] = 0;
assign M1[3][17:0]  = M0[3][17:0];
assign M1[3][21:18]  = 0;
assign M1[4][15:0]  = M0[4][15:0];
assign M1[4][21:16]  = 0;
assign M1[5][14:0]  = M0[5][14:0];
assign M1[5][21:15]  = 0;

 
// START COMPRESSING THE MATRIX 
// l= 6 -> set of central adders 
generate
    for (i = 8; i<= 15; i=i+1) begin

      if (i < 10 || i > 14) begin
      fullAdder FA0 (M1[0][i], M1[1][i], M1[2][i], M2[0][i], M2[1][i+1]);
      halfAdder HA0 (M1[3][i], M1[4][i], M2[2][i], M2[3][i+1]);
      end
      else begin
      fullAdder FA1 (M1[0][i], M1[1][i], M1[2][i], M2[0][i], M2[1][i+1]);
      fullAdder FA2(M1[3][i], M1[4][i], M1[5][i], M2[2][i], M2[3][i+1]);
      end 

    end
endgenerate

//l = 6 -> non regular adders
halfAdder HA1 (M1[0][6], M1[1][6], M2[0][6], M2[1][7]);
halfAdder HA2 (M1[0][7], M1[1][7], M2[0][7], M2[1][8]);
fullAdder FA3 (M1[0][16], M1[1][16], M1[2][16], M2[0][16], M2[1][17]);
halfAdder HA3 (M1[0][17], M1[1][17], M2[0][17], M2[3][18]);
 

//l = 6 -> forming the next level matrix
assign M2[0][21:18] = M1[0][21:18]; //LEFT
assign M2[1][21:18] = M1[1][21:18]; //LEFT
assign M2[2][21:17] = M1[2][21:17]; //LEFT
//assign M2[2][18:17] = '0;
assign M2[0][5:0]   = M1[0][5:0]; //RIGHT
assign M2[1][5:0]   = M1[1][5:0]; //RIGHT
assign M2[2][7:0]   = M1[2][7:0]; //RIGHT
assign M2[3][7:0]   = M1[3][7:0]; //RIGHT

//single elements copying
assign M2[1][6]   = M1[4][6]; //RIGHT
assign M2[3][8]     = M1[5][8]; 
assign M2[3][17]    = M1[3][17]; 
assign M2[2][16]    = M1[3][16]; 
assign M2[3][21:19] = M1[3][21:19]; //LEFT




// l = 4 -> set of central adders
generate 
  for (i = 6; i<= 18; i = i+1) begin: M2ADD
    fullAdder FA4 (M2[0][i], M2[1][i], M2[2][i], M3[0][i], M3[1][i+1]);
  end
endgenerate

// l = 4 ->  non regular adders
halfAdder HA4 (M2[0][4], M2[1][4], M3[0][4], M3[1][5]);
halfAdder HA5 (M2[0][5], M2[1][5], M3[0][5], M3[1][6]);
//halfAdder HA6 (M2[0][18], M2[1][18], M3[0][18], M3[1][19]);
halfAdder HA7 (M2[0][19], M2[1][19], M3[0][19], M3[2][20]);


// l = 4 -> forming the next level matrix

assign M3[0][3:0]   = M2[0][3:0];
assign M3[1][3:0]   = M2[1][3:0];
assign M3[2][5:0]   = M2[2][5:0];
assign M3[1][4]     = M2[3][4];

//assign M3[2][5:4]   = M2[2][5:4];
assign M3[0][21:20] = M2[0][21:20];
assign M3[1][21:20] = M2[1][21:20];
//assign M3[2][16]    = M2[2][16];
assign M3[2][19]  = M2[2][19];
assign M3[2][21]    = '0;
assign M3[2][18:6] = M2[3][18:6];


// l = 3 -> set of central adders
generate
  for (i=4; i<= 20; i = i+1) begin: M3ADD
    fullAdder FA5 (M3[0][i], M3[1][i], M3[2][i], op1[i], op2[i+1]);
end
endgenerate

// l = 3 -> non regular addersS
halfAdder HA8 (M3[0][2], M3[1][2], op1[2], op2[3]);
halfAdder HA9 (M3[0][3], M3[1][3], op1[3], op2[4]);
halfAdder HA10 (M3[0][21], M3[1][21], op1[21], op2[22]);

 // forming fastAdd
assign op1[1:0] = M3[0][1:0];

assign op2[0]   = M3[1][0];
assign op2[1]   = 0;
assign op2[2]   = M3[2][2];


// final sum (2 operands) adder instantiation
CSA #(.sizeCSA(22), .sizeRCA(4)) CSA0 (.A(op1[21:0]), .B(op2[21:0]), .Carry_i(1'b0), .S(csa_result[21:0]), .Carry_o(csa_result[22]));

assign product[21:0] = csa_result[21:0];
//assign result = op1 + op2;



endmodule
