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

interface fpu_if #();

    /* INTERFACE SIGNALS */
    logic                               clk_i,
    logic                               rst_ni,
    logic [NUM_OPERANDS-1:0][WIDTH-1:0] operands_i,
    fpnew_pkg::roundmode_e              rnd_mode_i,
    fpnew_pkg::operation_e              op_i,
    logic                               op_mod_i,
    fpnew_pkg::fp_format_e              src_fmt_i,
    fpnew_pkg::fp_format_e              dst_fmt_i,
    fpnew_pkg::int_format_e             int_fmt_i,
    logic                               vectorial_op_i,
    TagType                             tag_i,
    logic                               in_valid_i,
    logic                               in_ready_o,
    logic                               flush_i,
    logic [WIDTH-1:0]                   result_o,
    fpnew_pkg::status_t                 status_o,
    TagType                             tag_o,
    logic                               out_valid_o,
    logic                               out_ready_i,
    logic                               busy_o

    /* INTERFACE SIGNALS MODE MAPPING */

    /* Interface port at ALU side (DUT) */
    modport fpu_port (
        input logic                               clk_i,
        input logic                               rst_ni,
        input logic [NUM_OPERANDS-1:0][WIDTH-1:0] operands_i,
        input fpnew_pkg::roundmode_e              rnd_mode_i,
        input fpnew_pkg::operation_e              op_i,
        input logic                               op_mod_i,
        input fpnew_pkg::fp_format_e              src_fmt_i,
        input fpnew_pkg::fp_format_e              dst_fmt_i,
        input fpnew_pkg::int_format_e             int_fmt_i,
        input logic                               vectorial_op_i,
        input TagType                             tag_i,
        input logic                               in_valid_i,
        output logic                               in_ready_o,
        input logic                               flush_i,
        output logic [WIDTH-1:0]                  result_o,
        output fpnew_pkg::status_t                status_o,
        output TagType                            tag_o,
        output logic                              out_valid_o,
        input  logic                              out_ready_i,
        output logic                              busy_o   
    );

    /* Interface port at driver side (unused since the driver is a class) */
    modport driver_port (
        output logic                               clk_i,
        output logic                               rst_ni,
        output logic [NUM_OPERANDS-1:0][WIDTH-1:0] operands_i,
        output fpnew_pkg::roundmode_e              rnd_mode_i,
        output fpnew_pkg::operation_e              op_i,
        output logic                               op_mod_i,
        output fpnew_pkg::fp_format_e              src_fmt_i,
        output fpnew_pkg::fp_format_e              dst_fmt_i,
        output fpnew_pkg::int_format_e             int_fmt_i,
        output logic                               vectorial_op_i,
        output TagType                             tag_i,
        output logic                               in_valid_i,
        input logic                                in_ready_o,
        output logic                               flush_i,
        input logic [WIDTH-1:0]                    result_o,
        input fpnew_pkg::status_t                  status_o,
        input TagType                              tag_o,
        input logic                                out_valid_o,
        output logic                               out_ready_i,
        input logic                                busy_o  
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
        clk_i    = 1'b1;
        rst_ni   = 1'b1;
    end

    // Generate clock
    always #5ns begin: clk_gen
        clk_i= ~clk_i
    end

    // Reset the DUT
    task rst_dut();
        @(negedge clk_i;
        rst_ni   = 1'b0;
        @(negedge clk_i;
        rst_ni   = 1'b1;
    endtask // rst_dut

    // ----------
    // ASSERTIONS
    // ----------
    `ifndef SYNTHESIS
    `include "fpu_if_sva.svh"
    `endif /* SYNTHESIS */

endinterface // fpu_if