module fullAdder (
  input logic a, b, Cin,
  output logic s, Co
);

  assign s = a ^ b ^ Cin;
  assign Co = (a & b) | (b & Cin) | (a & Cin);

endmodule