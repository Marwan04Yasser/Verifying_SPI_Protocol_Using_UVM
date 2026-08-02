package SPI_wrapper_config_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_wrapper_config extends uvm_object;
  `uvm_object_utils(SPI_wrapper_config)

  virtual SPI_wrapper_if SPI_wrapper_vif;
  virtual SLAVE_IF slave_vif;
  virtual  RAM_IF ram_vif;

  uvm_active_passive_enum is_active;

  function new(string name = "SPI_wrapper_config");
    super.new(name);
  endfunction

  function void display();
    `uvm_info("CFG", $sformatf("Config Info: is_active=%s, vif=%p",
              (is_active==UVM_ACTIVE)?"UVM_ACTIVE":"UVM_PASSIVE",
              SPI_wrapper_vif), UVM_LOW)
  endfunction

endclass : SPI_wrapper_config

endpackage
