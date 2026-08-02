module golden_wrapper (SS_n,MOSI,clk,rst_n,MISO);
    input SS_n,clk,MOSI,rst_n;
    output MISO;
    wire [9:0]rx_data_bus;
    wire [7:0]tx_data_bus;
    wire rx_valid_bit,tx_valid_bit;


    SPI_slave_GOLD g_SPI(MOSI,MISO,SS_n,clk,rst_n,tx_data_bus,tx_valid_bit,rx_data_bus,rx_valid_bit);
    
    syn_ram_gold g_mem(.rx_valid_ram(rx_valid_bit),.clk_ram(clk),.rst_n_ram(rst_n),.din(rx_data_bus),.tx_valid_ram(tx_valid_bit),.dout(tx_data_bus));
    
endmodule