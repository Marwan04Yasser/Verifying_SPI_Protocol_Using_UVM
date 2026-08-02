vlib work
vlog -sv +cover *.*v *.svh
vsim -voptargs=+acc top -cover
coverage save top.ucdb -onexit
add wave -position insertpoint sim:/top/SPI_wrapperif/*
add wave -position insertpoint sim:/top/slave_if/*
add wave -position insertpoint sim:/top/ram_if/*
add wave /top/SVA/assert__p_reset_outputs_inactive /top/SVA/assert__p_miso_stable
run -all
