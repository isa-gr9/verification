#!/bin/sh

# Exit immediately if any command fails
#set -e


#COMPILE
#vlog -reportprogress 300 -work work ./halfAdder.sv
#vlog -reportprogress 300 -work work ./fullAdder.sv
#vlog -reportprogress 300 -work work ./RCA.sv
#vlog -reportprogress 300 -work work ./CS_block.sv
#vlog -reportprogress 300 -work work ./CSA.sv
#vlog -reportprogress 300 -work work ./LUT.sv
#vlog -reportprogress 300 -work work ./daddatree.sv
#vlog -reportprogress 300 -work work ./multiplier.sv
##Testbench
#vlog -reportprogress 300 -work work ./tb_mul.sv

#vdel -all
#
#vlib work

vlog -F compile.f

vsim -c -sv_seed random -do sim.do +n100 mul_tb -do cov.do | tee report-sim.log

vsim -do ./run.do

# Remove work directory
#rm -rf work
#
## Remove vsim and transcript files
#rm -f vsim.wlf transcript