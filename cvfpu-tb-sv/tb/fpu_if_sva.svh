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
// File: alu_if_sva.svh
// Author: Michele Caon
// Date: 02/06/2022

// SystemVerilog Assertions
// ------------------------
// Assertions to verify that the ALU is producing the correct result.

`ifndef FPU_IF_SVA_SVH_
`define FPU_IF_SVA_SVH_

// Print operation
`define PRINT_OP(op, operands[0], operands[1], operands[2], res) \
    $sformatf("op: %-7s | a: %16b (%f) | b: %16b (%f) | c: %16b (%f) | res: %16b (%f)", $past(op), $past(operands[0]), $past(operands[0]), $past(operands[1]), $past(operands[1]), $past(operands[2]), $past(operands[2]), res, res)


// Wrong results
int unsigned    err_num = 0;

// Get the number of errors and reset
function int unsigned get_err_num();
    automatic int unsigned n = err_num;
    err_num = 0;
    return n;
endfunction: get_err_num

// Reset condition
// ---------------
// Check that whenever the reset signal is asserted, the output is 0.
property p_reset;
    @(posedge clk or negedge rst_n)
    !rst_n |-> result == 'h0;
endproperty
fpu_reset: assert property (p_reset);

// ALU result
// ----------
// Check that the correct result is produced one clock cycle after
// receiving the input operands and the requested ALU operation.

property p_result;
    logic [DWIDTH-1:0] res;
    @(negedge clk) disable iff (!rst_n)
    case (op)       //DA CAPIRE!!!!!!!!!!!!!!!!!!!!!!!!!!
        ADD:        ##1 alu_res == $past(alu_a + alu_b);
        FMADD:        ##1 alu_res == $past(alu_a - alu_b);
        MUL:       ##1 alu_res == $past(alu_a[MULT_WIDTH-1:0]) * $past(alu_b[MULT_WIDTH-1:0]);
        FNMSUB:     ##1 alu_res == $past(alu_a & alu_b);
        /* With other operations, return 0 */
        default:    ##1 alu_res == 'h0;
    endcase
endproperty
fpu_result: assert property (p_result) 
else begin
    err_num++;
    $error("%s", `PRINT_OP(op, operands[0], operands[1], operands[2], res));
end

`endif /* FPU_IF_SVA_SVH_ */