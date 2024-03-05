#!/bin/sh

vdel -all

vlib work

vcom -F compilevhdl.f
vlog -F compilesv.f

vsim -c -sv_seed random -do sim.do +n100 reg_tb -do cov.do | tee report-sim.log
