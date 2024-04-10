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
// File: fpu_if.sv
// Author: Michele Caon
// Date: 31/05/2022

/*
 * File: fpu_if.sv
 * ----------------------------------------
 * Interface with the fpu wrapper in 'fpu_wrap.sv'.
 */

import fpnew_pkg::*;
import cf_math_pkg::*;

interface fpu_if #(parameter NUM_OPERANDS = 3, WIDTH = 16);
    parameter type                            TagType        = logic;

    /* INTERFACE SIGNALS */
    logic                               clk;
    logic                               rst;
    logic [NUM_OPERANDS-1:0][WIDTH-1:0]    operands;
    fpnew_pkg::roundmode_e              rnd_mode;
    fpnew_pkg::operation_e              op;
    logic                               op_mod;
    fpnew_pkg::fp_format_e              src_fmt;
    fpnew_pkg::fp_format_e              dst_fmt;
    fpnew_pkg::int_format_e             int_fmt;
    logic                               vectorial_op;
    TagType                             tag_i;
    logic                               in_valid;
    logic                               in_ready;
    logic                               flush;
    logic [WIDTH-1:0]                   result;
    fpnew_pkg::status_t                 status;
    TagType                             tag_o;
    logic                               out_valid;
    logic                               out_ready;
    logic                               busy;
    logic [WIDTH-1:0]                   result_exp;

    /* INTERFACE SIGNALS MODE MAPPING */

    /* Interface port at mul side (DUT) */
    modport fpu_port (
        input                               clk,
        input                               rst,
        input                               operands,
        input                               rnd_mode,
        input                               op,
        input                               op_mod,
        input                               src_fmt,
        input                               dst_fmt,
        input                               int_fmt,
        input                               vectorial_op,
        input                               tag_i,
        input                               in_valid,
        output                              in_ready,
        input                               flush,
        output                              result,
        output                              status,
        output                              tag_o,
        output                              out_valid,
        input                               out_ready,
        output                              busy,
        input                               result_exp   
    );

    /* Interface port at driver side (unused since the driver is a class) */
    modport driver_port (
        output                                  clk,
        output                                  rst,
        output                                  operands,
        output                                  rnd_mode,
        output                                  op,
        output                                  op_mod,
        output                                  src_fmt,
        output                                  dst_fmt,
        output                                  int_fmt,
        output                                  vectorial_op,
        output                                  tag_i,
        output                                  in_valid,
        input                                   in_ready,
        output                                  flush,
        input                                   result,
        input                                   status,
        input                                   tag_o,
        input                                   out_valid,
        output                                  out_ready,
        input                                   busy,  
        output                                  result_exp
    );

    /*
     * NOTE: an interface can be used to abstract the communication
     * with a module and to implement self-checking functions. In 
     * this case, we use it to generate the clock for the sequential
     * ALU and to check that the result is consistent with the input.
     */

    /******************************************************************************/
    /* CLOCK GENERATION */

    // Initialize clock and reset
    initial begin: init
        clk    = 1'b1;
        rst   = 1'b1;
    end

    // Generate clock
    always #5ns begin: clk_gen
        clk= ~clk;
    end

    // Reset the DUT
    task rst_dut();
        @(negedge clk)
        rst   = 1'b0;
        @(negedge clk)
        rst   = 1'b1;
    endtask // rst_dut

    // ----------
    // ASSERTIONS
    // ----------
    `ifndef SYNTHESIS
    `include "fpu_if_sva.svh"
    `endif /* SYNTHESIS */

endinterface // fpu_if