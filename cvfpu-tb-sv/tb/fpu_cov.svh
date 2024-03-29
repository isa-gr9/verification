// Copyright 2022 Politecnico di Torino.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 2.0 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-2.0. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// File: alu_cov.svh
// Author: Michele Caon
// Date: 06/06/2022

// File: alu_cov.svh
// ----------------------------------------
// Classes containig the methods and covergroup to compute the functional
// coverage of the ALU.

`ifndef FPU_COV_SVH_
`define FPU_COV_SVH_

import fpu_pkg::*;
import cf_math_pkg::*;

class fpu_cov #(
    parameter DWIDTH = 16,
    parameter NUM_OPERANDS = 3
);
    // ---------
    // VARIABLES
    // ---------
    
    // Adder interface
    local virtual interface fpu_if #(DWIDTH, NUM_OPERANDS) fpuif;
    
    // -------------------
    // FUNCTIONAL COVERAGE
    // -------------------

    // DA MODIFICARE???????????????????????????????????????????????????????????
    covergroup fpu_cg;
        // Operations
        op_cp: coverpoint fpuif.op iff (fpuif.rst_n) {
            bins add        = {ADD};
            bins fmadd        = {FMADD};
            bins mnmsub       = {FNMSUB};
            bins mul     = {MUL};
        }

        // Operands
        operands_cp: coverpoint fpuif.operands iff (fpuif.rst_n) {
            bins dim[]   = {0, (1<<DWIDTH)-1, (1<<(DWIDTH-1))-1};
            bins num[]   = {0, (1<<NUM_OPERANDS)-1, (1<<(NUM_OPERANDS-1))-1};
            bins others     = default;
        }
    endgroup: fpu_cg

    // -------
    // METHODS
    // -------

    // Constructor
    function new(virtual interface fpu_if #(DWIDTH, NUM_OPERANDS) _if);
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
    
endclass // alu_cov

`endif /* FPU_COV_SVH_ */