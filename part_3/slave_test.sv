////////////////////////////////////////////////////////////////////////////////
// Author: Marwan Yasser
// Course: Digital Verification using SV & UVM
//
// Description: slave UVM test
// 
////////////////////////////////////////////////////////////////////////////////
/*package slave_test_pkg;
import slave_env_pkg::*;
import slave_obj_config_pkg::*;
import slave_rst_seq_pkg::*;
import slave_main_sequence_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"
class slave_test extends uvm_test;
  `uvm_component_utils(slave_test)

  slave_env env;
  slave_config slave_cfg;

  slave_rst_seq      reset_seq;
  main_sequence      slave_main_seq;


  function new(string name= "slave_test", uvm_component parent = null);
   super.new(name, parent);
  endfunction


  // Build the enviornment in the build phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
env =slave_env::type_id::create("env",this); 
slave_cfg = slave_config::type_id::create("slave_cfg"); 

reset_seq=slave_rst_seq::type_id::create("reset_seq"); 
slave_main_seq=main_sequence::type_id::create("slave_main_seq");


if(!uvm_config_db #(virtual SLAVE_IF)::get(this ,"","SLAVE_IF",slave_cfg.slave_vif))
  `uvm_fatal("build phase" ,"Test - unable to get  the virual interface");

  uvm_config_db #(slave_config)::set(this , "*" ,"CFG" ,slave_cfg );
endfunction

 task run_phase(uvm_phase phase);
 super.run_phase(phase);
 phase.raise_objection(this);
 `uvm_info("run_phase" , "welcome to the uvm Env." ,UVM_MEDIUM)

  `uvm_info("run_phase"  ,"start reset"  ,UVM_MEDIUM) 
  reset_seq.start(env.agt.sqr);
  `uvm_info("run_phase"  ,"Finish reset"  ,UVM_MEDIUM) 

  `uvm_info("run_phase"  ,"start main_seq"  ,UVM_MEDIUM) 
  slave_main_seq.start(env.agt.sqr);
  `uvm_info("run_phase"  ,"Finish main_seq"  ,UVM_MEDIUM) 
    

 phase.drop_objection(this);
 endtask: run_phase

endclass: slave_test
endpackage*/