module hw_top #(
    parameter N = 11
);

    mul_if #(N) intf;

    multiplier #(N) dut (.A(intf.A), .B(intf.B), .result(intf.result));


endmodule