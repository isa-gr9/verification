interface mul_if #(parameter N = 11);

    logic [N-1:0] A;
    logic [N-1:0] B;
    logic [2*N - 1 : 0] result;
    logic clk;
    logic rst;
    // modport port_in (input A, B);
    // modport port_out (output result);


    initial begin
        clk         =    1'b0;
        rst         =    1'b1;
        #22 rst     =    1'b0;
    end

    always #5 clk = ~clk;

endinterface //mantissa_if