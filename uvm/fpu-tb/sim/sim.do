puts "\n########## SIMULATION STARTS ##########\n"
run -all
puts "\n##########  SIMULATION ENDS  ##########\n"
do cov.do
exit


#puts "\n########## SIMULATION STARTS ##########\n"
#
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
#run -all
#
#coverage save -onexit results/coverage_report.ucdb
#
#puts "\n##########  SIMULATION ENDS  ##########\n"
#
#exit
#