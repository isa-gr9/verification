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
    parameter DWIDTH    = 16,
    parameter NUM_OPERANDS = 3
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
        logic [NUM_OPERANDS-1:0][DWIDTH-1:0]            operands;
    } op_t;
 

    // operands.txt and results.txt are filled randomly with the fucntion operandGen 


int fd1; // file descriptor
int fd2;
int status_o;
int status_r;
logic [DWIDTH-1:0] ops[0:19];
logic [DWIDTH-1:0] result;

// Declare variables to store file paths
string operands_file = "../tb/operands.txt";
string results_file = "../tb/results.txt";


// ALU coverage
    // NOTE: declared as static so it's shared among multiple class
    // instances.
    protected static fpu_cov #(DWIDTH, NUM_OPERANDS)  fpucov;

 // Constructor
    function new(virtual interface fpu_if #(DWIDTH, NUM_OPERANDS) _if); 
        taif = _if;   // get the handle to the ALU interface from the TB
        fpucov = new(_if);

    // Open operands.txt for reading
    fd1 = $fopen(operands_file, "r");
    if (fd1 == 0) begin
        $display("Error opening %s", operands_file);
        $finish;
    end

begin
    // Read from operands.txt
    int j;
    for (j = 0; j < 20; j++) begin
    int status_o;
    status_o = $fscanf(fd1, "%16b", ops[j]);
    if (status_o != 1) begin
        $display("Error reading from %s", operands_file);
        $fclose(fd1);
        $finish;
        end
    end
end


    // Open results.txt for reading
    fd2 = $fopen(results_file, "r");
    if (fd2 == 0) begin
        $display("Error opening %s", results_file);
        $finish;
    end

begin
    // Read from results.txt
    int k;
    for (k=0; k<10; k++) begin
    status_r = $fscanf(fd2, "%16b", result[k]);
    if (status_r != 1) begin
        $display("Error reading from %s", results_file);
        $fclose(fd2);
        $finish;
        end
    end

end



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
        fpucov.cov_start();

        // Issue num_cycles random ALU operations
        repeat (num_cycles) begin: driver
            @(posedge taif.clk);
            //operandGen(NUM_OPERANDS);    // function to generate random operands and its results
        end

        // Wait for the last operation to complete
        @(posedge taif.clk);

        // Stop measuring coverage
        fpucov.cov_stop();
    endtask // run_test()

    protected task init();
        // Reset driver signals
        taif.operands      = 3'b0;
        taif.op     = MUL;

        // Reset the DUT
        taif.rst_dut();

        @(posedge taif.clk);
    endtask: init
    

    int i = 0;
    int k = 0;
    // Prepare a new ALU operation
    function void rand_fpu_op();
        /* Obtain random operations and operands
        assert (this.randomize())   // check the method's return value
        else   $error("ERROR while calling 'randomize()' method");*/

        // Set the ALU interface signals
        taif.op   = MUL;
        taif.operands[0] = ops[i];
        taif.operands[1] = ops[i+1];
        taif.operands[2] = 0;
        taif.result_exp = result[k];
        k = k+1;
        i = i+2;
        // Update coverage
        fpucov.cov_sample();
    endfunction

    // Get the ALU coverage
    function real get_cov();
        return fpucov.get_cov();
    endfunction: get_cov

endclass // fpu_tester

`endif /* FPU_TESTER_SVH_ */
