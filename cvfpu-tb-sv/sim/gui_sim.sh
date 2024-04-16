#!/bin/sh

# Exit immediately if any command fails
#set -e


#COMPILE

vlog -reportprogress 300 -work work ../src/multiplier/halfAdder.sv
vlog -reportprogress 300 -work work ../src/multiplier/fullAdder.sv
vlog -reportprogress 300 -work work ../src/multiplier/RCA.sv
vlog -reportprogress 300 -work work ../src/multiplier/CS_block.sv
vlog -reportprogress 300 -work work ../src/multiplier/CSA.sv
vlog -reportprogress 300 -work work ../src/multiplier/LUT.sv
vlog -reportprogress 300 -work work ../src/multiplier/daddatree.sv
vlog -reportprogress 300 -work work ../src/multiplier/multiplier.sv
 
vlog -reportprogress 300 -work work ../src/cf_math_pkg.sv
vlog -reportprogress 300 -work work ../src/lzc.sv
vlog -reportprogress 300 -work work ../src/rr_arb_tree.sv
vlog -reportprogress 300 -work work ../src/fpnew_pkg.sv
vlog -reportprogress 300 -work work ../src/fpnew_classifier.sv
vlog -reportprogress 300 -work work ../src/fpnew_rounding.sv
vlog -reportprogress 300 -work work ../src/fpnew_fma.sv
vlog -reportprogress 300 -work work ../src/fpnew_opgroup_fmt_slice.sv
vlog -reportprogress 300 -work work ../src/fpnew_opgroup_block.sv
vlog -reportprogress 300 -work work ../src/fpnew_top.sv

vlog -reportprogress 300 -work work ../tb/f2ieee754.sv
vlog -reportprogress 300 -work work ../tb/fpu_if.sv
vlog -reportprogress 300 -work work ../tb/fpu_tb.sv
vlog -reportprogress 300 -work work ../tb/fpu_wrap.sv

vsim -do ./runGui.do

# Remove work directory
rm -rf work

# Remove vsim and transcript files
rm -f vsim.wlf transcript