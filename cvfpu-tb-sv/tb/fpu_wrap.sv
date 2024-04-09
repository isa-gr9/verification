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
    fpnew_top #(DWIDTH, NUM_OPERANDS) fpu_u (
        .clk_i                 (p.clk),         
        .rst_ni                (p.rst),
        .operands_i            (p.operands),
        .rnd_mode_i            (p.rnd_mode),
        .op_i                  (p.op),
        .op_mod_i              (p.op_mod),
        .src_fmt_i             (p.src_fmt),
        .dst_fmt_i             (p.dst_fmt),
        .int_fmt_i             (p.int_fmt),
        .vectorial_op_i        (p.vectorial_op),
        .tag_i                 (p.tag_i),
        .in_valid_i            (p.in_valid),
        .in_ready_o            (p.in_ready),
        .flush_i               (p.flush),
        .result_o              (p.result),
        .status_o              (p.status),
        .tag_o                 (p.tag_o),
        .out_valid_o           (p.out_valid),
        .out_ready_i           (p.out_ready),
        .busy_o                (p.busy)
    );
endmodule