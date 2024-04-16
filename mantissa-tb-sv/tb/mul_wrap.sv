/*
 * File: mul_wrap.sv
 * ----------------------------------------
 * A simple wrapper to use the interface defined in 'mul_if.sv' 
 * instead of direct port mapping. This component also allows to
 * connect the interface to a VHDL DUT (compiled separately).
 */

module mul_wrap #(parameter DWIDTH = 11) (
    mul_if.mul_port p
);
    multiplier #(DWIDTH) mul_u (
        .A    (p.mul_a),
        .B    (p.mul_b),
        .result  (p.mul_res)
    );
endmodule
