// SystemVerilog Assertions
// ------------------------
// Assertions to verify that the FPU is producing the correct result.

`ifndef FPU_IF_SVA_SVH_
`define FPU_IF_SVA_SVH_


// Print operation
`define PRINT_OP(op, operands[0], operands[1], operands[2], result) \
    $sformatf("op: %-7s | a: %16b (%f) | b: %16b (%f) | c: %16b (%f) | res: %16b (%f)", $past(op), $past(operands[0]), $past(operands[0]), $past(operands[1]), $past(operands[1]), $past(operands[2]), $past(operands[2]), result, result)


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
    @(posedge clk or negedge rst)
    !rst |-> result == 'h0;
endproperty
fpu_reset: assert property (p_reset);

// fpu mul result
// ----------
property p_result;
    @(negedge clk) disable iff (!rst)
        result == expected_res;
endproperty

fpu_result: assert property (p_result) 
else begin
    err_num++;
    $error("%s", `PRINT_OP(op, operands[0], operands[1], operands[2], result));
end

`endif /* FPU_IF_SVA_SVH_ */
