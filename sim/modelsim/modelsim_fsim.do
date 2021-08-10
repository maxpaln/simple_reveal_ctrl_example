set testname simple_rvl_ex

if { ! [ file exists "logs" ] } {
  mkdir logs
  puts "Created Log Directory: logs"
}

if { [ file exists "logs/sim_${testname}.log" ] } {
  transcript file ""
  file delete -force "logs/sim_${testname}.log"
}

# Copy modelsim.ini locally...
#vmap -c

if { [ file exists "work" ] } {
  vdel -all
  puts "Removing Library: work"
}

vlib work
vlog -O0 -f design_files.f -sv ../testbench/tb_${testname}.v
vsim -c -L ovi_lfd2nx -L pmi_work +access +r -l logs/sim_${testname}.log tb_${testname}
log -r /*
onfinish stop
do wave_debug_${testname}.do
run -all
