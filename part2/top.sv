//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Marwan Yasser Rifaat
// Date:        2025-10
// Description: RAM_TOP_module
//==============================================================
import uvm_pkg::*;
import ram_test_pkg::*;
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
  RAM_IF ram_if(clk);
  RAM DUT(ram_if.din,ram_if.clk,ram_if.rst_n,ram_if.rx_valid,ram_if.dout,ram_if.tx_valid);

  //Instantiate GOLDEN_MODEL
   syn_ram_gold GOLDEN(.din(ram_if.din),.rx_valid_ram(ram_if.rx_valid),.dout(ram_if.dataout_golden),
                     .tx_valid_ram(ram_if.tx_valid_golden),.clk_ram(ram_if.clk),.rst_n_ram(ram_if.rst_n));

  // bind assertions
  bind RAM ram_sva RAM_check(.ram_if(top.ram_if));

  // run test using run_test task &  Set the virtual interface for the uvm test
  initial begin
    uvm_config_db#(virtual RAM_IF)::set(null,"uvm_test_top" ,"RAM_IF" , ram_if);
    run_test("ram_test");
  end
 
endmodule