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
// File: alu_tester.svh
// Author: Michele Caon
// Date: 31/05/2022

/*
 * File: alu_tester.svh
 * ----------------------------------------
 * Class containig the methods and variables to test the
 * ALU described in 'alu.sv' using the interface in 
 * 'alu_if.sv'.
 */

`ifndef FPU_TESTER_SVH_
`define FPU_TESTER_SVH_

`include "fpu_cov.svh"

import fpnew_pkg::*;
import cf_math_pkg::*;

/* ALU tester class */
class fpu_tester #(
    parameter DWIDTH    = 16
);
    // PROPERTIES
    // ----------

    // ALU interface
    /*
     * NOTE: the interface is declared as virtual, meaning that the
     * user will provide a proper implementation. In this case, the 
     * handle to a proper interface object is passed to the 
     * constructor (see below) by the TB in 'alu_tb.sv'.
     */
    virtual interface fpu_if #(DWIDTH, NUM_OPERANDS) taif;

    // Random ALU operation and inputs (updated by the 'randomize()' method)
    typedef struct packed {
        fpnew_pkg::operation_e                          op;
        logic [NUM_OPERANDS-1:0][DWIDTH-1:0]            operands
    } op_t;
    protected rand fpnew_pkg::operation_e     op;

    // DA CAPIRE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //basta fare tipo op.operands[0] dist {...}
    //op.operands[1] ....
    //op.operands[2] ....
    //???
    constraint ab_dist_c {
        op.operands dist {
            0                   :=10, 
            (1<<DWIDTH)-1       :=10,
            (1<<(DWIDTH-1))-1   :=10, 
            [1:(1<<DWIDTH)-2]   :=1
        };
        alu_op.b dist {
            0                   :=10, 
            (1<<DWIDTH)-1       :=10,
            (1<<(DWIDTH-1))-1   :=10, 
            [1:(1<<DWIDTH)-2]   :=1
        };
    };

    // ALU coverage
    // NOTE: declared as static so it's shared among multiple class
    // instances.
    protected static fpu_cov #(DWIDTH, NUM_OPERANDS)  fpucov;

    // METHODS
    // -------

    // Constructor
    function new(virtual interface fpu_if #(DWIDTH, NUM_OPERANDS) _if); 
        taif = _if;   // get the handle to the ALU interface from the TB
        fpcov = new(_if);
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
        fpcov.cov_start();

        // Issue num_cycles random ALU operations
        repeat (num_cycles) begin: driver
            @(posedge taif.clk);
            rand_fpu_op();
        end

        // Wait for the last operation to complete
        @(posedge taif.clk);

        // Stop measuring coverage
        fpucov.cov_stop();
    endtask // run_test()

    protected task init();
        // Reset driver signals
        taif.operands      = 3'b0;
        taif.op     = ADD;

        // Reset the DUT
        taif.rst_dut();

        @(posedge taif.clk);
    endtask: init
    
    // Prepare a new ALU operation
    function void rand_fpu_op();
        // Obtain random operations and operands
        assert (this.randomize())   // check the method's return value
        else   $error("ERROR while calling 'randomize()' method");

        // Set the ALU interface signals
        taif.op   = op.op;
        taif.operands    = operands.operands; //??????????????

        // Update coverage
        fpucov.cov_sample();
    endfunction

    // Get the ALU coverage
    function real get_cov();
        return fpucov.get_cov();
    endfunction: get_cov

endclass // fpu_tester

`endif /* FPU_TESTER_SVH_ */
