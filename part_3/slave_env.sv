////////////////////////////////////////////////////////////////////////////////
// Author: Marwan Yasser
// Course: Digital Verification using SV & UVM
//
// Description:Ram UVM ENV
// 
////////////////////////////////////////////////////////////////////////////////
package slave_env_pkg;
import slave_collector_pkg::*;
import slave_agent_pkg::*;
import slave_scoreboard_pkg::*;
import slave_obj_config_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"
class slave_env extends uvm_env;
  `uvm_component_utils(slave_env)

   slave_agent agt;
   slave_scoreboard sb;
   slave_collector cov;
   slave_config slave_cfg;

function new(string name ="slave_env" , uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
   super.build_phase(phase);
      slave_cfg = slave_config::type_id::create("slave_cfg");

     agt= slave_agent::type_id::create("agt",this);
     sb=  slave_scoreboard::type_id::create("sb",this);
     cov= slave_collector::type_id::create("cov",this);

    if (!uvm_config_db#(slave_config)::get(this, "", "CFG", slave_cfg))
      `uvm_fatal("build_phase", "Unable to get config in slave_env");

    uvm_config_db#(slave_config)::set(this, "agt", "CFG", slave_cfg);

endfunction: build_phase

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  agt.agt_ap.connect(sb.sb_export);
  agt.agt_ap.connect(cov.cov_export);
endfunction

endclass
endpackage
