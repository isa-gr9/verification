
vsim work.fpu_tb 
add wave *
add wave -position insertpoint sim:/fpu_tb/fpuif/*
add wave -position insertpoint sim:/fpu_tb/fpuw/p/*
run 1000 ns
wave zoom full
