//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Marwan Yasser Rifaat
// Date:        2025-10
// Description: RAM_sva
//==============================================================
package ram_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum {WRITE_ONLY, READ_ONLY, READ_WRITE} seq_mode_e;
class ram_seq_item extends uvm_sequence_item;
`uvm_object_utils(ram_seq_item);

bit   clk;
rand logic rst_n, rx_valid;
rand logic [9:0] din;
logic [7:0] dout,dataout_golden;
bit   tx_valid,tx_valid_golden;


function new(string name ="ram_seq_item");
   super.new(name);
endfunction

// constraints
seq_mode_e seq_mode;
constraint rst_n_c { rst_n dist {0:/10 , 1:/90} ;}
constraint rx_valid_c {rx_valid dist {0:/20 , 1:/80};}

function void post_randomize();
    bit [1:0] current_op = din[9:8];

    case (seq_mode)
      WRITE_ONLY: begin
        static bit [1:0] prev_op_wr = 2'b00;
        if (prev_op_wr == 2'b00 && !(current_op inside {2'b00, 2'b01}))
          din[9:8] = $urandom_range(0,1) ? 2'b00 : 2'b01;
        prev_op_wr = din[9:8];
      end

      READ_ONLY: begin
        static bit [1:0] prev_op_rd = 2'b10;
        if (prev_op_rd == 2'b10 && !(current_op inside {2'b11}))
          din[9:8] = 2'b11;

       if (prev_op_rd == 2'b11 && !(current_op inside {2'b10}))
          din[9:8] = 2'b10;

        prev_op_rd = din[9:8];
      end

      READ_WRITE: begin
        static bit [1:0] prev_op = 2'b00;
        int rand_val;

        case (prev_op)
          // After WRITE_ADDR → allow WRITE_ADDR or WRITE_DATA
          2'b00: if (!(current_op inside {2'b00,2'b01}))
                    din[9:8] = $urandom_range(0,1) ? 2'b00 : 2'b01;

          // After WRITE_DATA → 60% chance READ_ADDR, 40% chance WRITE_ADDR
          2'b01: begin
            rand_val = $urandom_range(0,99);
            din[9:8] = (rand_val < 60) ? 2'b10 : 2'b00;
          end

          // After READ_ADDR → allow READ_ADDR or READ_DATA
          2'b10: if (!(current_op inside {2'b10,2'b11}))
                    din[9:8] = $urandom_range(0,1) ? 2'b10 : 2'b11;

          // After READ_DATA → 60% WRITE_ADDR, 40% READ_ADDR
          2'b11: begin
            rand_val = $urandom_range(0,99);
            din[9:8] = (rand_val < 60) ? 2'b00 : 2'b10;
          end
        endcase

        prev_op = din[9:8];
end

    endcase
  endfunction


function string convert2string();
 return $sformatf("%s rst_n=0b%b, rx_valid=0b%b, din=0b%b,dout=0b%b, tx_valid=0b%b ", super.convert2string(),rst_n, rx_valid, din, dout, tx_valid);
endfunction

function string convert2string_stimulus();
 return $sformatf("rst_n=0b%b, rx_valid=0b%b, din=0b%b ,dout=0b%b, tx_valid=0b%b ", rst_n, rx_valid, din, dout, tx_valid);
endfunction

endclass
endpackage

