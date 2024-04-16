/*
 * File: fpu_tb.sv
 * ----------------------------------------
 * Testbench for the FPU. It provides to the
 * tester objects a connection point to the DUT using the
 * FPU interface described in 'fpu_if.sv').
 */

/* Include the FPU tester classes */
`include "fpu_tester.svh"
`include "../src/fpnew_top.sv"
/* Import FPU package namespace */
import fpnew_pkg::*;
import cf_math_pkg::*;

/* Testbench code */
module fpu_tb;


    parameter WIDTH        = 16;
    parameter NUM_OPERANDS = 3;

    /* Instantiate FPU interface */
    fpu_if #(WIDTH, NUM_OPERANDS)    fpuif();

    /* Instantiate FPU wrapper */
    fpu_wrap #(WIDTH, NUM_OPERANDS)  fpuw(fpuif.fpu_port);

    /* Declare a quiet tester object */
    fpu_tester #(WIDTH, NUM_OPERANDS) tst;

    /* Number of test cycles */
    int unsigned    num_cycles = 10;
    int unsigned    err_num = 0;

    /* Run the test */
    initial begin
        /* Instantiate the tester objects */
        tst = new(fpuif);

        // Set the number of cycles to test
        if (0 != $value$plusargs("n%d", num_cycles))
            $display("[CONFIG] Number of test cycles set to %0d", num_cycles);

        /* Run the quiet test */
        $display("\nTEST #1 - Launching ALU quiet test...");
        tst.run_test(num_cycles);
        $display("TEST #1 - Test completed!");
        $display("TEST #1 - Functional coverage: %.2f%%", tst.get_cov());

        
        // Print functional coverage
        $display("\nTOTAL FUNCTIONAL COVERAGE: %.2f%%", tst.get_cov());
        


        // Print the number of errors
        err_num = fpuif.get_err_num();
        $display("");
        if (err_num > 0) begin
            $error("### TEST FAILED with %0d errors", err_num);
        end else $display("### TEST PASSED!");

        /* Terminate the simulation */
        $display("");
        $stop;
    end
endmodule
