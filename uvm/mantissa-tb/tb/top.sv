import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../src/CS_block.sv"
`include "../src/CSA.sv"
`include "../src/daddatree.sv"
`include "../src/fullAdder.sv"
`include "../src/halfAdder.sv"
`include "../src/LUT.sv"
`include "../src/RCA.sv"
`include "../src/multiplier.sv"
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
  
  DUT mul(in, out, state);

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
