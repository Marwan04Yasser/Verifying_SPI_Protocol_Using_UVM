package SPI_wrapper_test_pkg;

import SPI_wrapper_env_pkg::*;
import SPI_wrapper_config_pkg::*;
import SPI_wrapper_main_seq_pkg::*;
import SPI_wrapper_reset_seq_pkg::*;
import SPI_wrapper_write_only_seq_pkg::*;
import SPI_wrapper_read_only_seq_pkg::*;
import SPI_wrapper_write_read_seq_pkg::*;
import slave_env_pkg::*;
import ram_env_pkg::*;
import ram_obj_config_pkg::*;
import slave_obj_config_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_wrapper_test extends uvm_test;
  `uvm_component_utils(SPI_wrapper_test)

  SPI_wrapper_env env;
  slave_env       env_slave;
  ram_env         env_ram;

  SPI_wrapper_config SPI_wrapper_cfg;
  ram_config         ram_obj_cfg;
  slave_config       slave_obj_cfg;

  virtual SPI_wrapper_if SPI_wrapper_vif;
  virtual RAM_IF       ram_vif;
  virtual SLAVE_IF     slave_vif;

  SPI_wrapper_reset_sequence      reset_seq;
  SPI_wrapper_write_only_sequence write_seq;
  SPI_wrapper_read_only_sequence  read_seq;
  SPI_wrapper_write_read_sequence wr_rd_seq;


  function new(string name = "SPI_wrapper_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env       = SPI_wrapper_env ::type_id::create("env", this);
    env_slave = slave_env       ::type_id::create("env_slave", this);
    env_ram   = ram_env         ::type_id::create("env_ram", this);

    SPI_wrapper_cfg = SPI_wrapper_config::type_id::create("SPI_wrapper_cfg");
    slave_obj_cfg   = slave_config      ::type_id::create("slave_obj_cfg");
    ram_obj_cfg     = ram_config        ::type_id::create("ram_obj_cfg");

    SPI_wrapper_cfg.is_active = UVM_ACTIVE;
    slave_obj_cfg.is_active   = UVM_PASSIVE;
    ram_obj_cfg.is_active     = UVM_PASSIVE;

    if (!uvm_config_db#(virtual SPI_wrapper_if)::get(null, "", "SPI_wrapper_IF", SPI_wrapper_vif)) begin
      `uvm_fatal("TEST_BUILD", "Could not get SPI_wrapper_IF from uvm_config_db (top must set it)")
    end
    if (!uvm_config_db#(virtual RAM_IF)::get(null, "", "RAM_IF", ram_vif)) begin
      `uvm_fatal("TEST_BUILD", "Could not get RAM_IF from uvm_config_db (top must set it)")
    end
    if (!uvm_config_db#(virtual SLAVE_IF)::get(null, "", "SLAVE_IF", slave_vif)) begin
      `uvm_fatal("TEST_BUILD", "Could not get SLAVE_IF from uvm_config_db (top must set it)")
    end

    SPI_wrapper_cfg.SPI_wrapper_vif = SPI_wrapper_vif;
    ram_obj_cfg.ram_vif            = ram_vif;
    slave_obj_cfg.slave_vif        = slave_vif;

    uvm_config_db#(SPI_wrapper_config)::set(null, "uvm_test_top.env",     "CFG", SPI_wrapper_cfg);
    uvm_config_db#(slave_config)    ::set(null, "uvm_test_top.env_slave", "CFG", slave_obj_cfg);
    uvm_config_db#(ram_config)      ::set(null, "uvm_test_top.env_ram",   "CFG", ram_obj_cfg);

    reset_seq = SPI_wrapper_reset_sequence     ::type_id::create("reset_seq");
    write_seq = SPI_wrapper_write_only_sequence::type_id::create("write_seq");
    read_seq  = SPI_wrapper_read_only_sequence ::type_id::create("read_seq");
    wr_rd_seq = SPI_wrapper_write_read_sequence::type_id::create("wr_rd_seq");

  endfunction : build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    uvm_top.print_topology();

    if (env == null) `uvm_fatal("NULL_ENV", "env is NULL in test");
    if (env.agt == null) `uvm_fatal("NULL_AGT", "env.agt is NULL in test");
    if (env.agt.sqr == null) `uvm_fatal("NULL_SQR", "env.agt.sqr is NULL — sequencer not created");

    // Reset sequence
    `uvm_info("run_phase", "RESET ASSERTED", UVM_LOW);
    reset_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "RESET DEASSERTED", UVM_LOW);

    // Write-only
    `uvm_info("run_phase", "WRITE ONLY SEQUENCE STARTED", UVM_LOW);
    write_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "WRITE ONLY SEQUENCE ENDED", UVM_LOW);



    // Read-only
    `uvm_info("run_phase", "READ ONLY SEQUENCE STARTED", UVM_LOW);
    read_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "READ ONLY SEQUENCE ENDED", UVM_LOW);

    // Write-Read
    `uvm_info("run_phase", "WRITE-READ SEQUENCE STARTED", UVM_LOW);
    wr_rd_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "WRITE-READ SEQUENCE ENDED", UVM_LOW);

    phase.drop_objection(this);
  endtask : run_phase

endclass : SPI_wrapper_test

endpackage : SPI_wrapper_test_pkg
