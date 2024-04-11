import fpnew_pkg:*;

module DUT#(
    parameter fpnew_pkg::fpu_features_t       Features       = fpnew_pkg::RV16F,		   
    parameter fpnew_pkg::fpu_implementation_t Implementation = fpnew_pkg::ISA_PIPE,
    parameter type                            TagType        = logic,
  // Do not change
    localparam int unsigned WIDTH        = Features.Width,
    localparam int unsigned NUM_OPERANDS = 3
)(dut_if.port_in in_inter, dut_if.port_out out_inter, output enum logic [1:0] {INITIAL,WAIT,SEND} state);
    
    //adder adder_under_test(.A(in_inter.A),.B(in_inter.B),.OUT(out_inter.data));



       fpnew_top #(Features, 
                   Implementation
                   TagType
                   Width
                   NUM_operands) DUT_top(
            .clk_i          (in_inter.clk),
            .rst_ni         (in_inter.rst),
		    .operands_i     (in_inter.operands_i),
		    .rnd_mode_i     (in_inter.rnd_mode_i),
		    .op_i           (in_inter.op_i),
		    .op_mod_i       (in_inter.op_mod_i),
		    .src_fmt_i      (in_inter.src_fmt_i),
		    .dst_fmt_i      (in_inter.dst_fmt_i),
		    .int_fmt_i      (in_inter.int_fmt_i),
		    .vectorial_op_i (in_inter.vectorial_op_i),
		    .tag_i          (in_inter.tag_i),
		    .in_valid_i     (in_inter.in_valid_i),
		    .in_ready_o     (out_inter.in_ready_o),
		    .flush_i        (in_inter.flush_i),
		    .result_o       (out_inter.result_o),
		    .status_o       (out_inter.status_o),
		    .tag_o          (out_inter.tag_o),
		    .out_valid_o    (out_inter.out_valid_o),
		    .out_ready_i    (in_inter.out_ready_i),
		    .busy_o         (out_inter.busy_o)
         );

    always_ff @(posedge in_inter.clk)
    begin
        if(in_inter.rst) begin
            in_inter.ready <= 0;
            //out_inter.data <= 'x;
            out_inter.valid <= 0;
            state <= INITIAL;
        end
        else case(state)
                INITIAL: begin
                    in_inter.ready <= 1;
                    state <= WAIT;
                end
                
                WAIT: begin
                    if(in_inter.valid) begin
                        in_inter.ready <= 0;
                        //out_inter.data <= in_inter.A + in_inter.B;
                        $display("adder: input A = %d, input B = %d, output OUT = %d",in_inter.A,in_inter.B,out_inter.data);
                        $display("adder: input A = %b, input B = %b, output OUT = %b",in_inter.A,in_inter.B,out_inter.data);
                        out_inter.valid <= 1;
                        state <= SEND;
                    end
                end
                
                SEND: begin
                    if(out_inter.ready) begin
                        out_inter.valid <= 0;
                        in_inter.ready <= 1;
                        state <= WAIT;
                    end
                end
        endcase
    end
endmodule: DUT