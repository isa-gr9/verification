#!/bin/sh

# Exit immediately if any command fails
set -e


if [ -e "work" ]; then
    vdel -all
fi

vlib work

vlog -coveropt 3 +cover +acc -F compile.f

vsim -c -sv_seed random -do "sim.do" -do cov.do -voptargs="+acc" top -coverage +UVM_TESTNAME=test | tee report-sim.log
vcover report -details -output report-cov.log results/coverage_report.ucdb

# Remove work directory
#rm -rf work
#
## Remove vsim and transcript files
#rm -f vsim.wlf transcript