/*
 * File: fpu_if.sv
 * ----------------------------------------
 * Interface with the fpu wrapper in 'fpu_wrap.sv'.
 */

import fpnew_pkg::*;
import cf_math_pkg::*;

interface fpu_if #(
    parameter fpnew_pkg::fpu_features_t       Features       = fpnew_pkg::RV16F,
    parameter fpnew_pkg::fpu_implementation_t Implementation = fpnew_pkg::ISA_PIPE,
    parameter type                            TagType        = logic,
    parameter WIDTH        = 16,
    parameter NUM_OPERANDS = 3
);

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
    logic                             tag_i;
    logic                               in_valid;
    logic                               in_ready;
    logic                               flush;
    logic [WIDTH-1:0]                  result;
    fpnew_pkg::status_t                 status;
    logic                            tag_o;
    logic                               out_valid;
    logic                               out_ready;
    logic                               busy;
    logic [WIDTH-1:0]                  expected_res;



    /* INTERFACE SIGNALS MODE MAPPING */

    /* Interface port at fpu side (DUT) */
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
        output                              busy
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
        input                                   busy
    );


   assign rnd_mode = fpnew_pkg::RNE;
   assign op = fpnew_pkg::MUL;
   assign src_fmt = fpnew_pkg::FP16;
   assign dst_fmt = fpnew_pkg::FP16;
   assign int_fmt = fpnew_pkg::INT16;   
   assign vectorial_op = 0;
   assign tag_i = 0;
   assign flush = 0;
   assign op_mod = 0;
   assign out_ready = out_valid;



    // Constants
     time Ts = 10ns;
     time Tp = 2ns;



    // Clock generation process
    always begin : clk_process
        if (clk === 1'bx) begin
            clk <= 1'b0;
        end else begin
            clk <= ~clk;
        end
        #(Ts/2);
    end

   // Task for generating reset
    task rst_dut();
        rst = 1'b1;
        #Tp;
        rst = 1'b0;
        #(2 * Ts);
        rst = 1'b1;
        // Infinite loop to keep simulation running
        @(posedge clk);
    endtask

    // ----------
    // ASSERTIONS
    // ----------
    `ifndef SYNTHESIS
    `include "fpu_if_sva.svh"
    `endif /* SYNTHESIS */

endinterface // fpu_if
