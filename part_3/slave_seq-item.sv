package slave_seq_item_pkg;
import shared_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"
class slave_seq_item extends uvm_sequence_item;
`uvm_object_utils(slave_seq_item)

    bit clk;
    logic   MOSI;
    logic  SS_n,rst_n;
    logic   [7:0] tx_data;
    bit     tx_valid;
    logic        [9:0] rx_data;
    logic        MISO;
    bit          rx_valid;
    
    logic MISO_golden,rx_valid_golden;
    logic [9:0] rx_data_golden ;
    
function new(string name ="slave_seq_item");
   super.new(name);
endfunction

function string convert2string();
 return $sformatf("%s  rst_n=0b%b,SS_n=0b%b ,MOSI=0b%b, tx_data=0b%b , tx_valid=0b%b, MISO=0b%b ,rx_data=0b%b ,rx_valid=0b%b ", super.convert2string(),
                   rst_n,SS_n ,MOSI, tx_data , tx_valid, MISO ,rx_data ,rx_valid);
endfunction

function string convert2string_stimulus();
 return $sformatf("rst_n=0b%b,SS_n=0b%b ,MOSI=0b%b, tx_data=0b%b , tx_valid=0b%b, MISO=0b%b ,rx_data=0b%b ,rx_valid=0b%b ",
                   rst_n,SS_n ,MOSI, tx_data , tx_valid, MISO ,rx_data ,rx_valid);
endfunction

endclass
endpackage
