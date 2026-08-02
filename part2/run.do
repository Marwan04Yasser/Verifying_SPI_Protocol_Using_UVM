vlib work
vlog *v +cover -covercells
vsim -coverage -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/ram_if/*
run -all
coverage exclude -src RAM.v -line 36 -code b
coverage exclude -src RAM.v -line 36 -code s
coverage save Ram_coverage.ucdb -du  RAM


