#vsim work.tb_iir -t ns -voptargs=+architecture
vsim work.tb_mul
add wave *
#add wave -position insertpoint sim:/tb_iir/UUT/*

#add wave -position insertpoint sim:/tb_daddatree/dadda_tree/fastAdd
add wave -position insertpoint sim:/tb_mul/mul/*
add wave -position insertpoint sim:/tb_mul/mul/dadda/*



run 2000 ns
wave zoom full
#quit -sim
#exit -f