package slave_driver_pkg;
import slave_obj_config_pkg::*;
import slave_seq_item_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"
class  slave_driver extends uvm_driver #(slave_seq_item);
`uvm_component_utils(slave_driver)

 virtual  SLAVE_IF slave_if_drv;
 slave_seq_item stim_seq_item;
 
  function new(string name ="slave_driver" , uvm_component parent = null);
  super.new(name,parent);
  endfunction

 task run_phase(uvm_phase phase);
 super.run_phase(phase);
forever begin
   stim_seq_item=slave_seq_item::type_id::create("stim_seq_item");

   seq_item_port.get_next_item(stim_seq_item);

   slave_if_drv.rst_n=stim_seq_item.rst_n;
   slave_if_drv.SS_n=stim_seq_item.SS_n;
   slave_if_drv.tx_valid=stim_seq_item.tx_valid;
   slave_if_drv.tx_data=stim_seq_item.tx_data;
   slave_if_drv.MOSI =stim_seq_item.MOSI;

   @(negedge slave_if_drv.clk); 
   seq_item_port.item_done();
   `uvm_info("run_phase" ,stim_seq_item.convert2string_stimulus(),UVM_HIGH)
end
 endtask
 endclass
 endpackage   