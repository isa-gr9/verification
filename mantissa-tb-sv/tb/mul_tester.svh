// Copyright 2022 Politecnico di Torino.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 2.0 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-2.0. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// File: mul_tester.svh
// Author: Michele Caon
// Date: 31/05/2022

/*
 * File: mul_tester.svh
 * ----------------------------------------
 * Class containig the methods and variables to test the
 * ALU described in 'alu.sv' using the interface in 
 * 'alu_if.sv'.
 */

`ifndef MUL_TESTER_SVH_
`define MUL_TESTER_SVH_

`include "mul_cov.svh"

// import alu_pkg::*;

/* MUL tester class */
class mul_tester #(
    parameter DWIDTH    = 11
);
    // PROPERTIES
    // ----------

    // MUL interface
    /*
     * NOTE: the interface is declared as virtual, meaning that the
     * user will provide a proper implementation. In this case, the 
     * handle to a proper interface object is passed to the 
     * constructor (see below) by the TB in 'alu_tb.sv'.
     */
    virtual interface mul_if #(DWIDTH) taif;

    // Random MUL operation and inputs (updated by the 'randomize()' method)
    typedef struct packed {
        logic [DWIDTH-1:0]  a;
        logic [DWIDTH-1:0]  b;
    } op_t;
    
	protected rand op_t     mul_op;

    // Constraint to prefer corner cases for operands /10x more likely)
    constraint ab_dist_c {
        mul_op.a dist {
            0                   :=10, 
            (1<<DWIDTH)-1       :=10,
            (1<<(DWIDTH-1))-1   :=10, 
            [1:(1<<DWIDTH)-2]   :=1
        };
        mul_op.b dist {
            0                   :=10, 
            (1<<DWIDTH)-1       :=10,
            (1<<(DWIDTH-1))-1   :=10, 
            [1:(1<<DWIDTH)-2]   :=1
        };
    };

    // MUL coverage
    // NOTE: declared as static so it's shared among multiple class
    // instances.
    protected static mul_cov #(DWIDTH)  mulcov;

    // METHODS
    // -------

    // Constructor
    function new(virtual interface mul_if #(DWIDTH) _if);
        taif = _if;   // get the handle to the ALU interface from the TB
        mulcov = new(_if);
    endfunction // new()

    // Test body
    /*
     * NOTE: tasks can contain "time-consuming" code, while functions
     * are always executed within a single simulation step.
     */
    task run_test(int unsigned num_cycles);
        // Reset the DUT
        init();

        // Start measuring coverage
        mulcov.cov_start();

        // Issue num_cycles random ALU operations
        repeat (num_cycles) begin: driver
           @(posedge taif.clk);
            rand_mul_op();
        end

        // Wait for the last operation to complete
        //@(posedge taif.clk);

        // Stop measuring coverage
        mulcov.cov_stop();
    endtask // run_test()

    protected task init();
        // Reset driver signals
        taif.mul_a      = '0;
        taif.mul_b      = '0;

        // Reset the DUT
        //taif.rst_dut();

       // @(posedge taif.clk);
    endtask: init
    
    // Prepare a new ALU operation
    function void rand_mul_op();
        // Obtain random operations and operands
        assert (this.randomize())   // check the method's return value
        else   $error("ERROR while calling 'randomize()' method");

        // Set the ALU interface signals
        taif.mul_a    = mul_op.a;
        taif.mul_b    = mul_op.b;

        // Update coverage
        mulcov.cov_sample();
    endfunction

    // Get the MUL coverage
    function real get_cov();
        return mulcov.get_cov();
    endfunction: get_cov

endclass // alu_tester

`endif /* MUL_TESTER_SVH_ */
