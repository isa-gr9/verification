// File: mul_verbose_tester.svh
// ----------------------------
// Class extended from alu_tester.svh to print additional information about
// the test progress.

`ifndef MUL_VERBOSE_TESTER_SVH_
`define MUL_VERBOSE_TESTER_SVH_

`include "mul_tester.svh"

/* MUL verbose tester class */
class mul_verbose_tester #(
    parameter DWIDTH    = 11
) extends mul_tester #(DWIDTH);    // inherits methods and variables from mul_tester

    // Operands queue
    op_t    opq[$];
    
    // Use the constructor from the parent class
    function new(virtual interface mul_if #(DWIDTH) _if);
        super.new(_if);
        opq = {};
    endfunction // new()

    // Test body
    task run_test(int unsigned num_cycles);
        // Reset the DUT
        init();

        // Start measuring coverage
        mulcov.cov_start();

      fork
         // Monitor operations
         print_op();
          // Issue num_cycles random multiplications
          repeat (num_cycles) begin: driver
              @(posedge taif.clk);
              rand_mul_op();
              opq.push_front({mul_op});
          end
      join
      // Stop measuring coverage
      mulcov.cov_stop();
  endtask // run_test()
  
  // Print current operation
  task print_op();
      op_t   prev_op;
      repeat (2) @(negedge taif.clk);    // skip the first result after reset
      while (opq.size() > 0) begin
          @(negedge taif.clk); // sample on negative edge to avoid race conditions
          prev_op = opq.pop_back();
          $display("[%07t]  | a: %b (%d) | b: %b (%d) | res: %b (%d)", $time, mul_op.a, mul_op.a, mul_op.b, mul_op.b, taif.mul_res, taif.mul_res);
        end 
endtask // op2str()
 
endclass // mul_verbose_tester

`endif /* MUL_VERBOSE_TESTER_SVH_ */
