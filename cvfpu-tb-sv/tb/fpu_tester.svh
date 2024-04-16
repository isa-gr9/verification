/*
 * File: fpu_tester.svh
 * ----------------------------------------
 * Class containig the methods and variables to test the
 * FPU described in 'fpnew_top.sv' using the interface in 
 * 'fpu_if.sv'.
 */

`ifndef FPU_TESTER_SVH_
`define FPU_TESTER_SVH_

`include "fpu_cov.svh"
`include "f2ieee754.sv"

import fpnew_pkg::*;
import cf_math_pkg::*;


class fpu_tester #(
    parameter WIDTH        = 16,
    parameter NUM_OPERANDS = 3
);


 virtual interface fpu_if #(WIDTH, NUM_OPERANDS) taif;



 typedef struct packed {
        int  a;
        int  b;
    } op_t;
    protected rand op_t     fpu_op;

constraint constraint_randx {
    fpu_op.a dist{
        // from 10000 to 100000 with probability 90%, from 100001 to 1000000 with probability 10%
        [10000   :   100000] :/ 90,
        [100001   :   1000000] :/ 10
    };
    
    fpu_op.b dist{
        // from 10000 to 100000 with probability 90%, from 100001 to 1000000 with probability 10%
        [10000   :   100000] :/ 90,
        [100001   :   1000000] :/ 10
    };
}

    // Random FPU operation and inputs (updated by the 'randomize()' method)  
	shortreal op1_rand;
	shortreal op2_rand;
    shortreal   result_real;
    logic [WIDTH-1:0] op1std;
    logic [WIDTH-1:0] op2std;
    logic [WIDTH-1:0] expected_res;

// FPU coverage
    // NOTE: declared as static so it's shared among multiple class
    // instances.
    protected static fpu_cov #(WIDTH, NUM_OPERANDS)  fpucov;

 // Constructor
    function new(virtual interface fpu_if #(WIDTH, NUM_OPERANDS) _if); 
        taif = _if;   // get the handle to the FPU interface from the TB
        fpucov = new(_if);
    endfunction
   

    // Test body
    /*
     * NOTE: tasks can contain "time-consuming" code, while functions
     * are always executed within a single simulation step.
     */
    task run_test(int unsigned num_cycles);
        // Reset the DUT
        init();

        // Start measuring coverage
        fpucov.cov_start();

        // Issue num_cycles random FPU operations
        repeat (num_cycles) begin: driver
            //@(posedge taif.clk);
            rand_fpu_op();
            wait_for_ready(); // Wait for ready signal to be 1
		end

        // Wait for the last operation to complete
        //@(posedge taif.clk);
        wait_for_ready(); // Wait for ready signal to be 1
        // Stop measuring coverage
        fpucov.cov_stop();
    endtask // run_test()


// Task to wait for the ready signal to be 1 and handle valid/ready handshake
protected task wait_for_ready();
    // Wait for in_ready signal to be 1
    while (!taif.in_ready) begin
        @(posedge taif.clk);
    end

    // Once in_ready is 1, assert out_valid and wait for out_ready
    taif.out_valid = 1'b1;
    @(posedge taif.clk);
    while (!taif.out_ready) begin
        @(posedge taif.clk);
    end

    // Once out_ready is 1, deassert out_valid
    taif.out_valid = 1'b0;
endtask: wait_for_ready


    protected task init();
        // Reset driver signals
        taif.operands[0][15:0] = 16'b0;
        taif.operands[1][15:0] = 16'b0;
        taif.operands[2][15:0] = 16'b0;
        taif.op     = MUL;
        taif.in_valid = 1'b0;

        // Reset the DUT
        taif.rst_dut();

        @(posedge taif.clk);
    endtask: init
    

    // Prepare a new FPU operation
    function void rand_fpu_op();

        
        // Obtain random operations and operands
        assert (this.randomize())   // check the method's return value
        else   $error("ERROR while calling 'randomize()' method");

        op1_rand = fpu_op.a/1000.0;
        op2_rand = fpu_op.b/1000.0;
        result_real = op1_rand * op2_rand;

        $display("a_real : %f, b_real: %f, a*b: %f", op1_rand, op2_rand, result_real);

        // Set the FPU interface signals
        taif.op   = MUL;
        f2ieee754(op1_rand, op1std);
        f2ieee754(op2_rand, op2std);
        f2ieee754(result_real, expected_res);
        $display("expected result: %16b", expected_res);
        taif.operands[0][15:0] = op1std;
        taif.operands[1][15:0] = op2std;
        taif.operands[2][15:0] = 16'b0; // c is not used
        taif.expected_res = expected_res;
        taif.in_valid = 1'b1; 

        // Update coverage
        fpucov.cov_sample();
    endfunction

    // Get the FPU coverage
    function real get_cov();
        return fpucov.get_cov();
    endfunction: get_cov


endclass // fpu_tester

`endif /* FPU_TESTER_SVH_ */
