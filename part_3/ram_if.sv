//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Marwan Yasser Rifaat
// Date:        2025-10
// Description: RAM_interface
//==============================================================
interface RAM_IF (clk);
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;

input clk;
logic rst_n, rx_valid;
logic [9:0] din;
logic [7:0] dout ,dataout_golden;
bit   tx_valid,tx_valid_golden;

modport DUT(input clk,rst_n,din, rx_valid , output dout,tx_valid );
endinterface : RAM_IF

