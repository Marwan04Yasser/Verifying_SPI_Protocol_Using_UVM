//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Marwan Yasser Rifaat
// Date:        2025-10
// Description: RAM_Environment
//==============================================================
package ram_agent_pkg;
import ram_seq_item_pkg::*;
import ram_sequencer_pkg::*;
import ram_driver_pkg::*;
import ram_monitor_pkg::*;
import ram_obj_config_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"
class ram_agent extends uvm_agent;
`uvm_component_utils(ram_agent)

ram_sequencer sqr;
ram_driver drv;
ram_monitor mon;
ram_config ram_cfg;
uvm_analysis_port #(ram_seq_item) agt_ap;

  function new(string name= "ram_agent", uvm_component parent = null);
   super.new(name, parent);
  endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Get configuration object from test (set via uvm_config_db in test)
  if(!uvm_config_db#(ram_config)::get(this, "", "CFG", ram_cfg)) begin
    `uvm_fatal("build_phase", "unable to get configuration object")
  end

  // Create sequencer and driver only if active
  if (ram_cfg.is_active == UVM_ACTIVE) begin
    sqr = ram_sequencer::type_id::create("sqr", this);
    drv = ram_driver::type_id::create("drv", this);
  end

  // Always create monitor and analysis port
  mon = ram_monitor::type_id::create("mon", this);
  agt_ap = new("agt_ap", this);
endfunction

function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);
  if (ram_cfg.is_active == UVM_ACTIVE) begin 
 drv.ram_if_driver=ram_cfg.ram_vif;
 drv.seq_item_port.connect(sqr.seq_item_export);
  end

 mon.ram_vif=ram_cfg.ram_vif;
 mon.mon_ap.connect(agt_ap);
endfunction

endclass
endpackage
