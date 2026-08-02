//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Marwan Yasser Rifaat
// Date:        2025-10
// Description: RAM_Environment
//==============================================================
package ram_env_pkg;
import ram_collector_pkg::*;
import ram_agent_pkg::*;
import ram_scoreboard_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"
class ram_env extends uvm_env;
  `uvm_component_utils(ram_env)

   ram_agent agt;
   ram_scoreboard sb;
   ram_collector cov;
   

function new(string name ="ram_env" , uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
   super.build_phase(phase);
     agt= ram_agent::type_id::create("agt",this);
     sb=  ram_scoreboard::type_id::create("sb",this);
     cov= ram_collector::type_id::create("cov",this);
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  agt.agt_ap.connect(sb.sb_export);
  agt.agt_ap.connect(cov.cov_export);
endfunction

endclass
endpackage
