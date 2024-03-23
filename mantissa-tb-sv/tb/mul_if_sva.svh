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
// File: mul_if_sva.svh
// Author: Michele Caon
// Date: 02/06/2022

// SystemVerilog Assertions
// ------------------------
// Assertions to verify that the ALU is producing the correct result.

`ifndef MUL_IF_SVA_SVH_
`define MUL_IF_SVA_SVH_

// Print operation
`define PRINT_OP(a, b, res) \
$sformatf("a: %08b (%d) | b: %08b (%d) | res: %08b (%d)", a, a, b, b, res, res)

// Wrong results
int unsigned    err_num = 0;

// Get the number of errors and reset
function int unsigned get_err_num();
    automatic int unsigned n = err_num;
    err_num = 0;
    return n;
endfunction: get_err_num

// MUL result
// ----------
// Check that the correct result is produced one clock cycle after
// receiving the input operands and the requested ALU operation.

property p_result;
  @(negedge clk) //disable iff (!rst_n)
  mul_res == mul_a * mul_b;
endproperty

a_result: assert property (p_result)
else begin
    err_num++;
    $error("Assertion failed. %s", `PRINT_OP(mul_a, mul_b, mul_res));
end

`endif /* MUL_IF_SVA_SVH_ */
