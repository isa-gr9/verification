/*
 * File: mul_if.sv
 * ----------------------------------------
 * Interface with the MUL wrapper in 'mul_wrap.sv'.
 */


interface mul_if #(parameter DWIDTH = 11);

    /* INTERFACE SIGNALS */
    logic [DWIDTH-1:0]  mul_a;
    logic [DWIDTH-1:0]  mul_b;
    logic [2*DWIDTH-1:0]  mul_res;
    logic clk;

    /* INTERFACE SIGNALS MODE MAPPING */

    modport mul_port (
        input   mul_a,
        input   mul_b,
        output  mul_res
    );

    /* Interface port at driver side (unused since the driver is a class) */
    modport driver_port (  
        output  mul_a,
        output  mul_b,
        input   mul_res
    );

    initial begin: init
        clk     = 1'b1;
    end

    // Generate clock
    always #5ns begin: clk_gen
        clk = ~clk;
    end
    // ----------
    // ASSERTIONS
    // ----------
    `ifndef SYNTHESIS
    `include "mul_if_sva.svh"
    `endif /* SYNTHESIS */

endinterface // mul_if
