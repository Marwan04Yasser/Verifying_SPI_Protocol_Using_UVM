package SPI_wrapper_monitor_pkg;
import SPI_wrapper_seq_item_pkg::*;
import shared::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class SPI_wrapper_monitor extends uvm_monitor;
`uvm_component_utils(SPI_wrapper_monitor)
    virtual SPI_wrapper_if SPI_wrapper_vif;
    SPI_wrapper_seq_item rsp_seq_item;
    uvm_analysis_port #(SPI_wrapper_seq_item) mon_ap;

      
  function new (string name = "SPI_wrapper_monitor",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap",this);
  endfunction

  task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    rsp_seq_item = SPI_wrapper_seq_item::type_id::create("rsp_seq_item");
    @(negedge SPI_wrapper_vif.clk);
    rsp_seq_item.rst_n = SPI_wrapper_vif.rst_n;
    rsp_seq_item.MOSI = SPI_wrapper_vif.MOSI; 
    rsp_seq_item.SS_n = SPI_wrapper_vif.SS_n; 
    rsp_seq_item.MISO = SPI_wrapper_vif.MISO; 
    
    // Golden outputs
    rsp_seq_item.MISO_golden   = SPI_wrapper_vif.MISO_golden;
    mon_ap.write(rsp_seq_item);
    `uvm_info("run_phase",rsp_seq_item.convert2string(), UVM_HIGH)
  end

  endtask
endclass
    
endpackage