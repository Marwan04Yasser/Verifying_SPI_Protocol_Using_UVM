
package SPI_wrapper_agent_pkg;

  import SPI_wrapper_seq_item_pkg::*;
  import SPI_wrapper_sequencer_pkg::*;
  import SPI_wrapper_driver_pkg::*;
  import SPI_wrapper_monitor_pkg::*;
  import SPI_wrapper_config_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class SPI_wrapper_agent extends uvm_agent;
    `uvm_component_utils(SPI_wrapper_agent)
    SPI_wrapper_sequencer sqr;
    SPI_wrapper_driver drv;
    SPI_wrapper_monitor mon;

    SPI_wrapper_config SPI_wrapper_cfg;
    uvm_analysis_port #(SPI_wrapper_seq_item) agt_ap;
    function new (string name = "SPI_wrapper_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      if (!uvm_config_db#(SPI_wrapper_config)::get(this, "", "CFG", SPI_wrapper_cfg)) begin
        `uvm_fatal("build_phase", "Test - Unable to get SPI_wrapper_config")
      end
      sqr = SPI_wrapper_sequencer::type_id::create("sqr", this);
      if (SPI_wrapper_cfg.is_active == UVM_ACTIVE) begin
        drv = SPI_wrapper_driver::type_id::create("drv", this);
      end
      mon = SPI_wrapper_monitor::type_id::create("mon", this);
      agt_ap = new("agt_ap", this);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      if (SPI_wrapper_cfg == null)
        `uvm_fatal("CONNECT", "SPI_wrapper_cfg is NULL in connect_phase");

      if (SPI_wrapper_cfg.is_active == UVM_ACTIVE) begin
        if (drv == null)
          `uvm_fatal("CONNECT", "drv is NULL but is_active==UVM_ACTIVE");

        if (SPI_wrapper_cfg.SPI_wrapper_vif == null)
          `uvm_fatal("CONNECT", "SPI_wrapper_vif is NULL in config");
        drv.SPI_wrapper_vif = SPI_wrapper_cfg.SPI_wrapper_vif;
        drv.seq_item_port.connect(sqr.seq_item_export);
      end
      if (SPI_wrapper_cfg.SPI_wrapper_vif != null)
        mon.SPI_wrapper_vif = SPI_wrapper_cfg.SPI_wrapper_vif;
      else
        `uvm_warning("CONNECT", "SPI_wrapper_vif is NULL — monitor cannot sample interface");
      mon.mon_ap.connect(agt_ap);
    endfunction : connect_phase

  endclass : SPI_wrapper_agent

endpackage
