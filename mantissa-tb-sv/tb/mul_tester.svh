/*
 * File: mul_tester.svh
 * ----------------------------------------
 * Class containig the methods and variables to test the
 * MUL described in 'multipler.sv' using the interface in 
 * 'mul_if.sv'.
 */

`ifndef MUL_TESTER_SVH_
`define MUL_TESTER_SVH_

`include "mul_cov.svh"

/* MUL tester class */
class mul_tester #(
    parameter DWIDTH    = 11
);
    // PROPERTIES
    // ----------

    // MUL interface
    virtual interface mul_if #(DWIDTH) taif;

    // Random MUL operation and inputs (updated by the 'randomize()' method)
    typedef struct packed {
        logic [DWIDTH-1:0]  a;
        logic [DWIDTH-1:0]  b;
    } op_t;
    
	protected rand op_t     mul_op;

    // Constraint to prefer corner cases for operands /10x more likely)
    constraint ab_dist_c {
        mul_op.a dist {
            0                   :=10, 
            (1<<DWIDTH)-1       :=10,
            (1<<(DWIDTH-1))-1   :=10, 
            [1:(1<<DWIDTH)-2]   :=1
        };
        mul_op.b dist {
            0                   :=10, 
            (1<<DWIDTH)-1       :=10,
            (1<<(DWIDTH-1))-1   :=10, 
            [1:(1<<DWIDTH)-2]   :=1
        };
    };

    // MUL coverage
    protected static mul_cov #(DWIDTH)  mulcov;

    // METHODS
    // -------

    // Constructor
    function new(virtual interface mul_if #(DWIDTH) _if);
        taif = _if;   // get the handle to the MUL interface from the TB
        mulcov = new(_if);
    endfunction // new()

    // Test body
    task run_test(int unsigned num_cycles);
        // Reset the DUT
        init();

        // Start measuring coverage
        mulcov.cov_start();

        // Issue num_cycles random multiplications
        repeat (num_cycles) begin: driver
           @(posedge taif.clk);
            rand_mul_op();
        end

        // Stop measuring coverage
        mulcov.cov_stop();
    endtask // run_test()

    protected task init();
        // Reset driver signals
        taif.mul_a      = '0;
        taif.mul_b      = '0;
    endtask: init
    
    function void rand_mul_op();
        // Obtain random operands
        assert (this.randomize())   // check the method's return value
        else   $error("ERROR while calling 'randomize()' method");

        // Set the MUL interface signals
        taif.mul_a    = mul_op.a;
        taif.mul_b    = mul_op.b;

        // Update coverage
        mulcov.cov_sample();
    endfunction

    // Get the MUL coverage
    function real get_cov();
        return mulcov.get_cov();
    endfunction: get_cov

endclass // mul_tester

`endif /* MUL_TESTER_SVH_ */
