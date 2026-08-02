package SPI_wrapper_read_only_seq_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import SPI_wrapper_seq_item_pkg::*;
  import shared::*;
  import shared_pkg::*;

  class SPI_wrapper_read_only_sequence extends uvm_sequence #(SPI_wrapper_seq_item);
    `uvm_object_utils(SPI_wrapper_read_only_sequence)

    SPI_wrapper_seq_item seq_itm;

    function new(string name = "SPI_wrapper_read_only_sequence");
      super.new(name);
    endfunction

    task body();
      seq_itm = SPI_wrapper_seq_item::type_id::create("seq_itm");

      repeat (10000) begin
        start_item(seq_itm);
        seq_itm.mode_select = SPI_wrapper_seq_item::MODE_READ;

        seq_itm.write_mode_const.constraint_mode(0);
        seq_itm.read_mode_const.constraint_mode(1);
        seq_itm.mixed_mode_const.constraint_mode(0);
        seq_itm.mosi_bits.rand_mode(1);

        if (!seq_itm.randomize() with {
             mosi_bits[10:8] inside {
               SPI_wrapper_seq_item::READ_ADD,
               SPI_wrapper_seq_item::READ_DATA
             };
           }) begin
          `uvm_error("RANDOMIZE_FAIL", $sformatf("read_only_sequence: randomize failed (mode_select=%0d).", seq_itm.mode_select))
        end

        finish_item(seq_itm);
      end
    endtask

  endclass

endpackage
