/*
 * File: mul_tb.sv
 * ----------------------------------------
 * Testbench for the mul in 'multiplier.sv'. It provides to the
 * tester objects a connection point to the DUT using the
 * multipler interface described in 'mul_if.sv').
 */

/* Include the mul tester classes */
`include "mul_tester.svh"
`include "mul_verbose_tester.svh"


/* Testbench code */
module mul_tb;

    /* Define data width */
    localparam DWIDTH   = 11;

    /* Instantiate MUL interface */
    mul_if #(DWIDTH)    mulif();

    /* Instantiate MUL wrapper */
    mul_wrap #(DWIDTH)  mw(mulif.mul_port);

    /* Declare a quiet tester object */
    mul_tester #(DWIDTH) tst;

    /* Declare a verbose tester object */
    mul_verbose_tester #(DWIDTH) vtst;

    /* Number of test cycles */
    int unsigned    num_cycles = 10;
    int unsigned    err_num = 0;

    /* Run the test */
    initial begin
        /* Instantiate the tester objects */
        tst = new(mulif);
        vtst = new(mulif);

        // Set the number of cycles to test
        if (0 != $value$plusargs("n%d", num_cycles))
            $display("[CONFIG] Number of test cycles set to %0d", num_cycles);

        /* Run the quiet test */
        $display("\nTEST #1 - Launching MUL quiet test...");
        tst.run_test(num_cycles);
        $display("TEST #1 - Test completed!");
        $display("TEST #1 - Functional coverage: %.2f%%", tst.get_cov());

        /* Run the verbose test */
        $display("\nTEST #2 - Launching MUL verbose test...");
        vtst.run_test(num_cycles);
        $display("TEST #2 - Test completed!");
        $display("TEST #2 - Functional coverage: %.2f%%", tst.get_cov());

        // Print functional coverage
        $display("\nTOTAL FUNCTIONAL COVERAGE: %.2f%%", tst.get_cov());

        // Print the number of errors
        err_num = mulif.get_err_num();
        $display("");
        if (err_num > 0) begin
            $error("### TEST FAILED with %0d errors", err_num);
        end else $display("### TEST PASSED!");

        /* Terminate the simulation */
        $display("");
        $stop;
    end
endmodule
