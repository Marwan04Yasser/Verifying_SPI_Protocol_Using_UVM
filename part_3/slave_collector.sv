package slave_collector_pkg;
import slave_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class slave_collector extends uvm_component;
`uvm_component_utils(slave_collector)
uvm_analysis_export #(slave_seq_item)  cov_export;
uvm_tlm_analysis_fifo #(slave_seq_item) cov_fifo;

slave_seq_item seq_item_cov;

covergroup cvr ;
rx_trans :coverpoint seq_item_cov.rx_data[9:8];
 
ss_n_trans : coverpoint  seq_item_cov.SS_n 
{
   bins normal = (1 => 0[*13] => 1 );
   bins read = (1 => 0[*23] => 1 );
} 

Mosi_trans : coverpoint  seq_item_cov.MOSI 
{
   bins write_address = (0 => 0 => 0 );
   bins write_data =    (0 => 0 => 1 );
   bins read_address =  (1 => 1 => 0 );
   bins read_data =     (1 => 1 => 1 );
}

cross ss_n_trans,Mosi_trans
{
  bins ss_n_mosi0 = binsof(ss_n_trans.normal) && binsof(Mosi_trans.write_address);
  bins ss_n_mosi1 = binsof(ss_n_trans.normal) && binsof(Mosi_trans.write_data);
  bins ss_n_mosi2 = binsof(ss_n_trans.normal) && binsof(Mosi_trans.read_address);
  bins ss_n_mosi3 = binsof(ss_n_trans.normal) && binsof(Mosi_trans.read_data);
  bins ss_n_mosi4 = binsof(ss_n_trans.read) && binsof(Mosi_trans.write_address);
  bins ss_n_mosi5 = binsof(ss_n_trans.read) && binsof(Mosi_trans.write_data);
  bins ss_n_mosi6 = binsof(ss_n_trans.read) && binsof(Mosi_trans.read_address);
  bins ss_n_mosi7 = binsof(ss_n_trans.read) && binsof(Mosi_trans.read_data);
  option.cross_auto_bin_max=0;
}



endgroup

  function new(string name ="slave_collector" , uvm_component parent = null);
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
