////////////////////////////////////////////////////////////////////////////////
// Author: Marwan Yasser
// Course: Digital Verification using SV & UVM
//
// Description:slave UVM 
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
import slave_test_pkg::*;
`include "uvm_macros.svh"

module top();
  // Example 1
  bit clk;
  // Clock generation
  initial begin
    forever begin
      #1 clk=~clk;
    end
  end
  // Instantiate the interface and DUT
  SLAVE_IF slave_if(clk);
  SLAVE DUT(slave_if.MOSI,slave_if.MISO,slave_if.SS_n,slave_if.clk,slave_if.rst_n,slave_if.rx_data,slave_if.rx_valid,slave_if.tx_data,slave_if.tx_valid);
  
  //Instantiate GOLDEN_MODEL
  SPI_slave_GOLD GOLDEN( .MOSI(slave_if.MOSI),  .MISO(slave_if.MISO_golden), .SS_n(slave_if.SS_n), .clk(slave_if.clk), .rst_n(slave_if.rst_n),
                      .tx_data(slave_if.tx_data), .tx_valid(slave_if.tx_valid), .rx_data(slave_if.rx_data_golden), .rx_valid(slave_if.rx_valid_golden));                    
  
  assign slave_if.cs=DUT.cs;
  assign slave_if.ns=DUT.ns;
  
  // bind assertions
  bind SLAVE slave_sva SLAVE_check(.slave_if(top.slave_if));
   
  // run test using run_test task &  Set the virtual interface for the uvm test
  initial begin
    uvm_config_db#(virtual SLAVE_IF)::set(null,"uvm_test_top" ,"SLAVE_IF" , slave_if);
    run_test("slave_test");
  end
 
endmodule
