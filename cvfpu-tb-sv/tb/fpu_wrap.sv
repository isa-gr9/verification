/*
 * File: fpu_wrap.sv
 * ----------------------------------------
 * A simple wrapper to use the interface defined in 'fpu_if.sv' 
 * instead of direct port mapping. This component also allows to
 * connect the interface to a VHDL DUT (compiled separately).
 */

module fpu_wrap #(WIDTH = 16, NUM_OPERANDS = 3) (
    fpu_if.fpu_port p
);
    fpnew_top #(WIDTH, NUM_OPERANDS) fpu_u (
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