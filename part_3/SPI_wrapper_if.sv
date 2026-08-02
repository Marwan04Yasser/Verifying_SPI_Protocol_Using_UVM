import SPI_wrapper_reset_seq_pkg::*;
interface SPI_wrapper_if(clk);
input clk;
logic  MOSI, SS_n, rst_n;
logic MISO;
logic MISO_golden;
reg [9:0]rx_data;
reg rx_valid;
modport DUT (
input clk,MOSI, SS_n, rst_n,MISO , rx_data,rx_valid
);

endinterface:SPI_wrapper_if
