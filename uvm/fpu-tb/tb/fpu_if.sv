interface fpu_if;
    import fpunew_pkg::*;

    parameter int unsigned NUM_OPERANDS = 2;
    parameter int unsigned WIDTH        = 16;


    logic                               clk_i;
    logic                               rst_ni;
    // Input signals
    logic [NUM_OPERANDS-1:0][WIDTH-1:0] operands_i;
    fpnew_pkg::roundmode_e              rnd_mode_i;
    fpnew_pkg::operation_e              op_i;
    logic                               op_mod_i;
    fpnew_pkg::fp_format_e              src_fmt_i;
    fpnew_pkg::fp_format_e              dst_fmt_i;
    fpnew_pkg::int_format_e             int_fmt_i;
    logic                               vectorial_op_i;
    TagType                             tag_i;
    // Input Handshake
    logic                               in_valid_i;
    logic                               in_ready_o;
    logic                               flush_i;
    // Output signals
    logic [WIDTH-1:0]                   result_o;
    fpnew_pkg::status_t                 status_o;
    TagType                             tag_o;
    // Output handshake
    logic                               out_valid_o;
    logic                               out_ready_i;
    // Indication of valid data in flight
    logic                               busy_o;


    assign rnd_mode_i       = fpnew_pkg::RNE;
    assign src_fmt_i        = fpnew_pkg::FP16;
    assign dst_fmt_i        = fpnew_pkg::FP16;
    assign int_fmt_i        = fpnew_pkg::INT16;      
    assign vectorial_op_i   = 0;
    assign tag_i            = 0;
    assign flush_i          = 0;
    assign op_mod_i         = 0;
    assign out_ready_i      = out_valid_o;
    assign in_valid_i       = rst;      //always valid together with the rst


    initial begin: init
        clk_i  = 1'b0;
        rst_ni = 1'b0;
        #10 rst_ni = 1'b1;
    end

    always #5ns begin: clk_gen
        clk_i = ~clk_i;
    end


    // modport port_in (
    //     input       clk,
    //     input       rst,
    //     input       operands_i,
    //     input       rnd_mode_i,
    //     input       op_i,
    //     input       op_mod_i,
    //     input       src_fmt_i,
    //     input       dst_fmt_i,
    //     input       int_fmt_i,
    //     input       vectorial_op_i,
    //     input       tag_i,
    //     input       in_valid_i,
    //     input       flush_i,
    //     input       out_ready_i,
    //     output      out_valid_o
    // );

    // modport port_out (
    //     input       clk,
    //     input       rst,
    //     output      out_valid_o,
    //     output      in_ready_o,
    //     output      result_o,
    //     output      status_o,
    //     output      tag_o,
    //     output      out_valid_o,
    //     output      busy_o
    // );

endinterface

