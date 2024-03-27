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
// File: alu_wrap.sv
// Author: Michele Caon
// Date: 31/05/2022

/*
 * File: alu_wrap.sv
 * ----------------------------------------
 * A simple wrapper to use the interface defined in 'alu_if.sv' 
 * instead of direct port mapping. This component also allows to
 * connect the interface to a VHDL DUT (compiled separately).
 */

module fpu_wrap #(parameter DWIDTH = 16, NUM_OPERANDS = 3) (
    fpu_if.fpu_port p
);
    fpu #(DWIDTH, NUM_OPERANDS) fpu_u (
        .clk_i,                 (clk),         
        .rst_ni,                (rst_n),
        .operands_i,            (operands),
        .rnd_mode_i,            (rnd_mode),
        .op_i,                  (op),
        .op_mod_i,              (op_mod),
        .src_fmt_i,             (src_fmt),
        .dst_fmt_i,             (dst_fmt),
        .int_fmt_i,             (int_fmt),
        .tag_i,                 (tag),
        .in_valid_i,            (in_valid),
        .in_ready_o,            (in_ready),
        .flush_i,               (flush),
        .result_o,              (result),
        .status_o,              (status),
        .tag_o,                 (tag),
        .out_valid_o,           (out_valid),
        .out_ready_i,           (out_ready),
        .busy_o                 (busy)
    );
endmodule