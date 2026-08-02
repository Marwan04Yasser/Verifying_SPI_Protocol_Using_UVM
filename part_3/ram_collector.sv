//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Marwan Yasser Rifaat
// Date:        2025-10
// Description: RAM_Environment
//==============================================================
package ram_collector_pkg;
import ram_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ram_collector extends uvm_component;
`uvm_component_utils(ram_collector)
uvm_analysis_export #(ram_seq_item)  cov_export;
uvm_tlm_analysis_fifo #(ram_seq_item) cov_fifo;

ram_seq_item seq_item_cov;

covergroup cvr ;

din : coverpoint seq_item_cov.din[9:8]
{
  bins wr_addr = {2'b00};
  bins wr_data = {2'b01};
  bins rd_addr = {2'b10};
  bins rd_data = {2'b11};
 
}
rx_valid: coverpoint  seq_item_cov.rx_valid {bins RX_HIGH ={1};}
tx_valid: coverpoint  seq_item_cov.tx_valid {bins TX_HIGH ={1};}

din_tx_valid : cross din ,tx_valid 
{
  bins din_11_tx_valid_1 = binsof(din.rd_data) && binsof(tx_valid.TX_HIGH);
  option.cross_auto_bin_max=0;
}

endgroup

  function new(string name ="ram_collector" , uvm_component parent = null);
  super.new(name,parent);
  cvr=new();
  endfunction

  function void build_phase(uvm_phase phase);
super.build_phase(phase);

 cov_export = new("cov_export",this);
 cov_fifo =   new("cov_fifo",this);

endfunction

function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 cov_export.connect(cov_fifo.analysis_export);
 endfunction

 task run_phase(uvm_phase phase);
 super.run_phase(phase);
 forever begin
    cov_fifo.get(seq_item_cov);
    cvr.sample();
 end
 endtask
 endclass
 endpackage
