package SPI_wrapper_reset_seq_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import SPI_wrapper_seq_item_pkg::*;
  import shared::*;

  class SPI_wrapper_reset_sequence extends uvm_sequence #(SPI_wrapper_seq_item);
    `uvm_object_utils(SPI_wrapper_reset_sequence)

    SPI_wrapper_seq_item seq_itm;

    function new(string name = "SPI_wrapper_reset_sequence");
      super.new(name);
    endfunction

    task body();
      seq_itm = SPI_wrapper_seq_item::type_id::create("seq_itm");
      start_item(seq_itm);
        seq_itm.rst_n = 0;
        seq_itm.SS_n  = 0;
        seq_itm.MOSI  = 0;
      finish_item(seq_itm);
    endtask

  endclass

endpackage
