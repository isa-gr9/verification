import fpnew_pkg::*;


module fpu_wrap #(
    parameter fpnew_pkg::fpu_features_t       Features       = fpnew_pkg::RV16F,		   
    parameter fpnew_pkg::fpu_implementation_t Implementation = fpnew_pkg::ISA_PIPE,
    parameter type                            TagType        = logic,
  // Do not change
    localparam int unsigned WIDTH        = Features.Width,
    localparam int unsigned NUM_OPERANDS = 3
)
(
    dut_if if
);



       fpnew_top #(Features, 
                   Implementation
                   TagType
                   Width
                   NUM_operands) DUT_top(
            .clk_i          (if.clk_i),
            .rst_ni         (if.rst_ni),
		    .operands_i     (if.operands_i),
		    .rnd_mode_i     (if.rnd_mode_i),
		    .op_i           (if.op_i),
		    .op_mod_i       (if.op_mod_i),
		    .src_fmt_i      (if.src_fmt_i),
		    .dst_fmt_i      (if.dst_fmt_i),
		    .int_fmt_i      (if.int_fmt_i),
		    .vectorial_op_i (if.vectorial_op_i),
		    .tag_i          (if.tag_i),
		    .in_valid_i     (if.in_valid_i),
		    .in_ready_o     (if.in_ready_o),
		    .flush_i        (if.flush_i),
		    .result_o       (if.result_o),
		    .status_o       (if.status_o),
		    .tag_o          (if.tag_o),
		    .out_valid_o    (if.out_valid_o),
		    .out_ready_i    (if.out_ready_i),
		    .busy_o         (if.busy_o)
         );
endmodule: DUT