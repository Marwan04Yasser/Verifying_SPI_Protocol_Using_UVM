//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Marwan Yasser Rifaat
// Date:        2025-10
// Description: RAM UVM TEST
//==============================================================
package ram_test_pkg;
import ram_env_pkg::*;
import ram_obj_config_pkg::*;
import ram_rst_seq_pkg::*;
import write_only_sequence_pkg::*;
import read_only_sequence_pkg::*;
import read_write_sequence_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"
class ram_test extends uvm_test;
  `uvm_component_utils(ram_test)

  ram_env env;
  ram_config ram_cfg;

  ram_rst_seq          reset_seq;
  write_only_sequence  wr_seq;
  read_only_sequence   rd_seq;
  read_write_sequence  rd_wr_seq;

  function new(string name= "ram_test", uvm_component parent = null);
   super.new(name, parent);
  endfunction


  // Build the enviornment in the build phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
env =ram_env::type_id::create("env",this); //
ram_cfg = ram_config::type_id::create("ram_cfg"); //

reset_seq=ram_rst_seq::type_id::create("reset_seq"); 
wr_seq   =write_only_sequence::type_id::create("wr_seq");
rd_seq   =read_only_sequence::type_id::create("rd_seq");
rd_wr_seq=read_write_sequence::type_id::create("rd_wr_seq");

if(!uvm_config_db #(virtual RAM_IF)::get(this ,"","RAM_IF",ram_cfg.ram_vif))//
  `uvm_fatal("build phase" ,"Test - unable to get  the virual interface");

  uvm_config_db #(ram_config)::set(this , "*" ,"CFG" ,ram_cfg );//
endfunction

 task run_phase(uvm_phase phase);
 super.run_phase(phase);
 phase.raise_objection(this);
 `uvm_info("run_phase" , "welcome to the uvm Env." ,UVM_MEDIUM)

  `uvm_info("run_phase"  ,"start reset"  ,UVM_MEDIUM) 
  reset_seq.start(env.agt.sqr);
  `uvm_info("run_phase"  ,"Finish reset"  ,UVM_MEDIUM) 

  `uvm_info("run_phase"  ,"start write_only_seq"  ,UVM_MEDIUM) 
  wr_seq.start(env.agt.sqr);
  `uvm_info("run_phase"  ,"Finish write_only_seq"  ,UVM_MEDIUM) 

  `uvm_info("run_phase"  ,"start read_only_seq"  ,UVM_MEDIUM) 
  rd_seq.start(env.agt.sqr);
  `uvm_info("run_phase"  ,"Finish write_only_seq"  ,UVM_MEDIUM) 

  `uvm_info("run_phase"  ,"start read/write seq"  ,UVM_MEDIUM) 
  rd_wr_seq.start(env.agt.sqr);
  `uvm_info("run_phase"  ,"Finish read/write seq"  ,UVM_MEDIUM)       

 phase.drop_objection(this);
 endtask: run_phase

endclass: ram_test
endpackage