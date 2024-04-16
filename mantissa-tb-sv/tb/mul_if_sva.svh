// SystemVerilog Assertions
// ------------------------
// Assertions to verify that the multiplier is producing the correct result.

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
// receiving the input operands.

property p_result;
  @(negedge clk) 
  mul_res == mul_a * mul_b;
endproperty

a_result: assert property (p_result)
else begin
    err_num++;
    $error("Assertion failed. %s", `PRINT_OP(mul_a, mul_b, mul_res));
end

`endif /* MUL_IF_SVA_SVH_ */
