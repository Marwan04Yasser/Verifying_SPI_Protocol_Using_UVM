package SPI_wrapper_coverage_pkg;
import SPI_wrapper_sequencer_pkg::*;
import SPI_wrapper_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class SPI_wrapper_coverage extends uvm_component;
`uvm_component_utils(SPI_wrapper_coverage);
uvm_analysis_export #(SPI_wrapper_seq_item) cov_export;
uvm_tlm_analysis_fifo #(SPI_wrapper_seq_item) cov_fifo;
SPI_wrapper_seq_item seq_item_cov;

function new (string name = "SPI_wrapper_coverage",uvm_component parent = null);
    super.new(name,parent);
  endfunction
    


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export",this);
    cov_fifo = new("cov_fifo",this);
  endfunction

  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
  endfunction

   task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin 
    cov_fifo.get(seq_item_cov);
  end
  endtask

endclass
    
endpackage