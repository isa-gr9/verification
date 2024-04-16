// ----------------------------------------
// Classes containig the methods and covergroup to compute the functional
// coverage of the multiplier.

`ifndef MUL_COV_SVH_
`define MUL_COV_SVH_

class mul_cov #(
    parameter DWIDTH = 11
);
    // ---------
    // VARIABLES
    // ---------
    
    // Mul interface
    local virtual interface mul_if #(DWIDTH) mulif;
    
    // -------------------
    // FUNCTIONAL COVERAGE
    // -------------------

  
    covergroup mul_cg;
        // Operands
        mula_cp: coverpoint mulif.mul_a {
            bins corner[]   = {0, (1<<DWIDTH)-1, (1<<(DWIDTH-1))-1};
            bins others     = default;
        }
        mulb_cp: coverpoint mulif.mul_b {
            bins corner[]   = {0, (1<<DWIDTH)-1, (1<<(DWIDTH-1))-1};
            bins others     = default;
        }
    endgroup: mul_cg

    // -------
    // METHODS
    // -------

    // Constructor
    function new(virtual interface mul_if #(DWIDTH) _if);
        mulif         = _if;
        mul_cg      = new();

        // disable the covergroup by default
        mul_cg.stop();
    endfunction: new

    // Enable operands coverage
    function void cov_start();
        mul_cg.start();
    endfunction: cov_start

    // Disable operands coverage
    function void cov_stop();
        mul_cg.stop();
    endfunction: cov_stop

    // Sample operands coverage
    function void cov_sample();
      mul_cg.sample();
    endfunction: cov_sample

    // Return operands coverage
    function real get_cov();
        return mul_cg.get_inst_coverage();
    endfunction: get_cov
    
endclass // mul_cov

`endif /* MUL_COV_SVH_ */
