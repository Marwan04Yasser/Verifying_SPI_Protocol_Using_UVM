import uvm_pkg::*;
import SPI_wrapper_test_pkg::*;
`include "uvm_macros.svh"

module top();

  logic clk;
  initial begin
    clk = 0;
    forever #1 clk = ~clk;
  end

  SPI_wrapper_if SPI_wrapperif(clk);
  SLAVE_IF       slave_if(clk);
  RAM_IF         ram_if(clk);

  WRAPPER dut (
    .MOSI  (SPI_wrapperif.MOSI),
    .MISO  (SPI_wrapperif.MISO),
    .SS_n  (SPI_wrapperif.SS_n),
    .clk   (clk),
    .rst_n (SPI_wrapperif.rst_n)
  );

  golden_wrapper golden_model (
    .SS_n  (SPI_wrapperif.SS_n),
    .MOSI  (SPI_wrapperif.MOSI),
    .clk   (clk),
    .rst_n (SPI_wrapperif.rst_n),
    .MISO  (SPI_wrapperif.MISO_golden)
  );

  SPI_wrapper_sva SVA (SPI_wrapperif);

  assign slave_if.MOSI    = dut.MOSI;
  assign slave_if.SS_n    = dut.SS_n;
  assign slave_if.rst_n   = dut.rst_n;
  assign slave_if.clk     = clk; 

  assign slave_if.rx_data  = dut.rx_data_din;
  assign slave_if.rx_valid = dut.rx_valid;
  assign slave_if.MISO     = dut.MISO;

  assign slave_if.tx_valid =  dut.tx_valid;
  assign slave_if.tx_data  =  dut.tx_data_dout;

  assign slave_if.rx_data_golden= golden_model.rx_data_bus;
  assign slave_if.rx_valid_golden = golden_model.rx_valid_bit;
  assign slave_if.MISO_golden = golden_model.MISO; 

  assign ram_if.clk      = clk;
  assign ram_if.rst_n    = dut.rst_n;
  assign ram_if.rx_valid = dut.rx_valid;
  assign ram_if.din      = dut.rx_data_din;
  assign ram_if.tx_valid = dut.tx_valid;
  assign ram_if.dout     = dut.tx_data_dout;


  assign ram_if.dataout_golden  = golden_model.tx_data_bus;
  assign ram_if.tx_valid_golden = golden_model.tx_valid_bit;
  assign slave_if.cs=golden_model.g_SPI.cs;
  assign slave_if.ns=golden_model.g_SPI.ns;

  assign SPI_wrapperif.rx_data =dut.rx_data_din;
  assign SPI_wrapperif.rx_valid=dut.rx_valid;

  initial begin
     $readmemh("mem.dat", top.golden_model.g_mem.mem);
     $readmemh("mem.dat", top.dut.RAM_instance.MEM);
    uvm_config_db#(virtual SPI_wrapper_if)::set(null, "*", "SPI_wrapper_IF", SPI_wrapperif);
    uvm_config_db#(virtual RAM_IF)::set(null, "*", "RAM_IF", ram_if);
    uvm_config_db#(virtual SLAVE_IF)::set(null, "*", "SLAVE_IF", slave_if);

    run_test("SPI_wrapper_test");
  end

endmodule

