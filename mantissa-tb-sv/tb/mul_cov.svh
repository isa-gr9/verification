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
// File: mul_cov.svh
// Author: Michele Caon
// Date: 06/06/2022


// ----------------------------------------
// Classes containig the methods and covergroup to compute the functional
// coverage of the xx.

`ifndef MUL_COV_SVH_
`define MUL_COV_SVH_

class mul_cov #(
    parameter DWIDTH = 11
);
    // ---------
    // VARIABLES
    // ---------
    
    // Adder interface
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
