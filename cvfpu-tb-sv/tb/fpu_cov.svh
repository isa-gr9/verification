// File: fpu_cov.svh
// ----------------------------------------
// Classes containig the methods and covergroup to compute the functional
// coverage of the FPU.

`ifndef FPU_COV_SVH_
`define FPU_COV_SVH_

import fpnew_pkg::*;
import cf_math_pkg::*;

class fpu_cov #(
    parameter WIDTH        = 16,
    parameter NUM_OPERANDS = 3
);
    // ---------
    // VARIABLES
    // ---------
    
    // fpu interface
    local virtual interface fpu_if #(WIDTH, NUM_OPERANDS) fpuif;
    
    // -------------------
    // FUNCTIONAL COVERAGE
    // -------------------

    covergroup fpu_cg;
    // Operands
    a_cp: coverpoint fpuif.operands[0] iff (fpuif.rst) {
        bins corner[] = {16'b0, {16{1'b1}}, {16{1'b0}}};
        bins others = default;
    }

    b_cp: coverpoint fpuif.operands[1] iff (fpuif.rst) {
        bins corner[] = {16'b0, {16{1'b1}}, {16{1'b0}}};
        bins others = default;
    }

    endgroup: fpu_cg

    // -------
    // METHODS
    // -------

    // Constructor
    function new(virtual interface fpu_if #(WIDTH, NUM_OPERANDS) _if);
        fpuif         = _if;
        fpu_cg      = new();

        // disable the covergroup by default
        fpu_cg.stop();
    endfunction: new

    // Enable operands coverage
    function void cov_start();
        fpu_cg.start();
    endfunction: cov_start

    // Disable operands coverage
    function void cov_stop();
        fpu_cg.stop();
    endfunction: cov_stop

    // Sample operands coverage
    function void cov_sample();
        fpu_cg.sample();
    endfunction: cov_sample

    // Return operands coverage
    function real get_cov();
        return fpu_cg.get_inst_coverage();
    endfunction: get_cov
    
endclass // fpu_cov

`endif /* FPU_COV_SVH_ */
