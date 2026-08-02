package SPI_wrapper_seq_item_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import shared::*;
  import shared_pkg::*;

  class SPI_wrapper_seq_item extends uvm_sequence_item;
    `uvm_object_utils(SPI_wrapper_seq_item)
    typedef enum bit [2:0] {
      WRITE_ADD  = 3'b000,
      WRITE_DATA = 3'b001,
      READ_ADD   = 3'b110,
      READ_DATA  = 3'b111
    } state_e;

    typedef enum bit [1:0] {
      MODE_WRITE  = 2'b00,
      MODE_READ   = 2'b01,
      MODE_MIXED  = 2'b10
    } mode_e;

    rand bit [10:0] mosi_bits;     
    rand bit        MOSI;
    rand bit        SS_n;
    rand bit        rst_n;
    rand bit        tx_valid;
    rand mode_e     mode_select;
    bit       MISO, MISO_golden;

    int       cycle_counter;
    int       rx_counter;
    int       mosi_index;
    state_e   prev_state;

    function new(string name = "SPI_wrapper_seq_item");
      super.new(name);
      cycle_counter = 0;
      mosi_index    = 10;
    endfunction

    function void post_randomize();
      cycle_counter++;
      if (SS_n) begin
        cycle_counter = 1;
        mosi_index    = 10;
      end

      if (mosi_index >= 0 ) begin
        if (cycle_counter > 2) begin
           MOSI = mosi_bits[mosi_index];
           mosi_index--;
        end
      end
      prev_state = state_e'(mosi_bits[10:8]);
    endfunction

    constraint rst_activity_const {
      rst_n dist {1 := 99, 0 := 1};
    }

    constraint ss_n_const {
      if (~rst_n) {
       SS_n == 1;
      }
      else if (mosi_bits[10:8] == 3'b111) {   
       SS_n == (cycle_counter % 24 == 0);
      }
      else {
        SS_n == (cycle_counter % 14 == 0);
      }
}

    constraint mosi_arr_const {
      if (~rst_n)
        mosi_bits[10:8] inside {WRITE_DATA, WRITE_ADD, READ_ADD};
      else
        mosi_bits[10:8] inside {WRITE_DATA, WRITE_ADD, READ_ADD, READ_DATA};
    }

    constraint write_mode_const {
      if (mode_select == MODE_WRITE)
        mosi_bits[10:8] inside {WRITE_ADD, WRITE_DATA};
    }

    constraint read_mode_const {
      if (mode_select == MODE_READ && prev_state == READ_ADD ) {
          mosi_bits[10:8] == READ_DATA;
      else if (mode_select == MODE_READ && prev_state == READ_DATA)
          mosi_bits[10:8] == READ_ADD;
       
      }
    }

    constraint mixed_mode_const {
      if (mode_select == MODE_MIXED) {
        if (prev_state == WRITE_ADD)
          mosi_bits[10:8] inside {WRITE_ADD, WRITE_DATA};
        else if (prev_state == WRITE_DATA)
          mosi_bits[10:8] dist {READ_ADD := 60, WRITE_ADD := 40};
        else if (prev_state == READ_ADD)
          mosi_bits[10:8] == READ_DATA;
        else
          mosi_bits[10:8] dist {WRITE_ADD := 60, READ_ADD := 40};
      }
    }


  endclass

endpackage
