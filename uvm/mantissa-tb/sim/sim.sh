#!/bin/sh

# Exit immediately if any command fails
set -e


if [ -e "work" ]; then
    vdel -all
fi

vlib work

#vlog -coveropt 3 +cover +acc -F compile.f
#vlog -sv ../src/dut_if.sv
#vlog -sv ../src/DUT.sv

vlog -sv ../tb/top.sv
vsim top -do "sim.do" | tee report-sim.log
#vsim -c -sv_seed random -do "sim.do" -do cov.do -voptargs="+acc" top -coverage +UVM_TESTNAME=simple_test | tee report-sim.log
#vcover report -details -output report-cov.log results/coverage_report.ucdb

# Remove work directory
#rm -rf work
#
## Remove vsim and transcript files
#rm -f vsim.wlf transcript