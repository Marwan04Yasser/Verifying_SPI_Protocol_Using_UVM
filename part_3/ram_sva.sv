//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Marwan Yasser Rifaat
// Date:        2025-10
// Description: RAM_sva
//==============================================================
module ram_sva(RAM_IF.DUT ram_if );

property reset_chk;
    @(posedge ram_if.clk)   (!ram_if.rst_n) |=> (ram_if.dout==0 && ram_if.tx_valid==0 );
endproperty

property tx_valid_deasserted;
    @(posedge ram_if.clk)  disable iff(!ram_if.rst_n)  
    (ram_if.din[9:8]!=2'b11) |=> (ram_if.tx_valid==0);
endproperty

property tx_valid_asserted;
  @(posedge ram_if.clk)   disable iff (!ram_if.rst_n) 
    (ram_if.din[9:8]==2'b11 && ram_if.rx_valid) |=> $rose(ram_if.tx_valid) |=> $fell(ram_if.tx_valid) [->1] ;
endproperty


property wr_addr_followed_by_wr_data;
    @(posedge ram_if.clk)   disable iff (!ram_if.rst_n)
    (ram_if.din[9:8]==2'b00 && ram_if.rx_valid) |=> (ram_if.din[9:8]==2'b01) [->1];
endproperty    

property rd_addr_followed_by_rd_data;
    @(posedge ram_if.clk)   disable iff (!ram_if.rst_n)
    (ram_if.din[9:8]==2'b10 && ram_if.rx_valid) |=> (ram_if.din[9:8]==2'b11) [->1];
endproperty 
    

assert property(reset_chk);
assert property(tx_valid_deasserted);
assert property(tx_valid_asserted);
assert property(wr_addr_followed_by_wr_data);
assert property(rd_addr_followed_by_rd_data);


cover property(reset_chk);
cover property(tx_valid_deasserted);
cover property(tx_valid_asserted);
cover property(wr_addr_followed_by_wr_data);
cover property(rd_addr_followed_by_rd_data);


endmodule