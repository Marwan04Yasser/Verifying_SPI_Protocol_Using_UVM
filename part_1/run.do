vlib work
vlog *v +cover -covercells
vsim -coverage -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/slave_if/*
run -all
coverage exclude -src SPI_slave.v -line 130 -code b
coverage save SLAVE_coverage.ucdb -du SLAVE


