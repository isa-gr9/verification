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
// File: mul_if.sv
// Author: Michele Caon
// Date: 31/05/2022

/*
 * File: mul_if.sv
 * ----------------------------------------
 * Interface with the ALU wrapper in 'alu_wrap.sv'.
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

    /*
     * NOTE: an interface can be used to abstract the communication
     * with a module and to implement self-checking functions. In 
     * this case, we use it to generate the clock for the sequential
     * ALU and to check that the result is consistent with the input.
     */

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
