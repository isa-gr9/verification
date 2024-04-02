package mul_pkg;

    parameter N = 10;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    typedef uvm_config_db#(mul_if) vif_config;

    `include "packet_in.sv"
    `include "packet_out.sv"
    `include "sequence_in.sv"
    `include "sequencer.sv"
    `include "driver.sv"
    `include "driver_out.sv"
    `include "monitor.sv"
    `include "monitor_out.sv"
    `include "agent.sv"
    `include "agent_out.sv"
    `include "refmod.sv"
    `include "comparator.sv"
    `include "env.sv"
    `include "simple_test.sv"
endpackage