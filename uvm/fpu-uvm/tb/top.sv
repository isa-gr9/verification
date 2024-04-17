// import uvm_pkg::*;
// `include "uvm_macros.svh"

// import fpu_tb_pkg::*;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "../src/multiplier/halfAdder.sv"
    `include "../src/multiplier/fullAdder.sv"
    `include "../src/multiplier/RCA.sv"
    `include "../src/multiplier/CS_block.sv"
    `include "../src/multiplier/CSA.sv"
    `include "../src/multiplier/LUT.sv"
    `include "../src/multiplier/daddatree.sv"
    `include "../src/multiplier/multiplier.sv"
    `include "../src/cf_math_pkg.sv"
    `include "../src/lzc.sv"
    `include "../src/rr_arb_tree.sv"
    `include "../src/fpnew_pkg.sv"
    `include "../src/fpnew_classifier.sv"
    `include "../src/fpnew_rounding.sv"
    `include "../src/fpnew_fma.sv"
    `include "../src/fpnew_opgroup_fmt_slice.sv"
    `include "../src/fpnew_opgroup_block.sv"
    `include "../src/fpnew_top.sv"
    `include "../src/dut_if.sv"
    `include "../src/DUT.sv"
    `include "../tb/packet_in.sv"
    `include "../tb/packet_out.sv"
    `include "../tb/sequence_in.sv"
    `include "../tb/sequencer.sv"
    `include "../tb/driver.sv"
    `include "../tb/driver_out.sv"
    `include "../tb/monitor.sv"
    `include "../tb/monitor_out.sv"
    `include "../tb/agent.sv"
    `include "../tb/agent_out.sv"
    `include "../tb/refmod.sv"
    `include "../tb/comparator.sv"
    `include "../tb/env.sv"
    `include "../tb/simple_test.sv"


//Top
module top;
  logic clk;
  logic rst;
  
  initial begin
    clk = 0;
    rst = 1;
    #22 rst = 0;
    
  end
  
  always #5 clk = !clk;
  
  logic [1:0] state;
  
  dut_if in(clk, rst);
  dut_if out(clk, rst);
  
  DUT fpu(in, out, state);

  initial begin
    `ifdef INCA
      $recordvars();
    `endif
    `ifdef VCS
      $vcdpluson;
    `endif
    `ifdef QUESTA
      $wlfdumpvars();
      set_config_int("*", "recording_detail", 1);
    `endif
    
    uvm_config_db#(input_vif)::set(uvm_root::get(), "*.env_h.mst.*", "vif", in);
    uvm_config_db#(output_vif)::set(uvm_root::get(), "*.env_h.slv.*",  "vif", out);
    
    run_test("simple_test");
  end
endmodule
