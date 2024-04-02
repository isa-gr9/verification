module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import mul_pkg::*;

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

    // uvm_config_db#(input_vif)::set(uvm_root::get(), "*.env_h.mst.*", "vif", in);
    // uvm_config_db#(output_vif)::set(uvm_root::get(), "*.env_h.slv.*",  "vif", out);

    vif_config::set(null, "*.env_h.mst.*", "vif", hw_top.intf);

    run_test("simple_test");
  end
endmodule
