package slave_seq_item_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import shared_pkg::*;

  class slave_seq_item extends uvm_sequence_item;
    `uvm_object_utils(slave_seq_item)
  typedef enum bit [2:0] {WR_ADDR=3'b000, WR_DATA=3'b001, RD_ADDR=3'b110, RD_DATA =3'b111} op_e;
  typedef enum bit [1:0] {WRITE_ONLY=2'b00, READ_ONLY=2'b01, READ_WRITE=2'b10} seq_mode_e;

    bit clk;
    logic   MOSI;
    rand logic  SS_n,rst_n;
    rand logic   [7:0] tx_data;
    rand bit     tx_valid;
    logic        [9:0] rx_data;
    logic        MISO;
    bit          rx_valid;
    
    logic MISO_golden,rx_valid_golden;
    logic [9:0] rx_data_golden ;

    rand bit [0:10] array_rand;
    op_e old_operation;
    int bit_index = 0; 

    
    function void post_randomize;
        if (SS_n_prev && !SS_n)
                bit_index = 0; 
         if (!SS_n) begin
            MOSI = array_rand[bit_index];
            bit_index++;
        if (bit_index > 10)
                    bit_index = 0; 
        end
            old_operation = op_e'(array_rand[0:2]);
            SS_n_prev = SS_n;

        if (array_rand[0:2] inside {WR_ADDR, WR_DATA, RD_ADDR})
                counter_allcases++;
        if (counter_allcases == 14)
                counter_allcases = 0;

        if (array_rand[0:2] inside {RD_DATA})
                counter_read++;
        if (counter_read == 24)
                counter_read = 0;
    endfunction

    constraint reset {rst_n dist {0:=2, 1:=998};}

    constraint SS_n_high {
         if ((array_rand[0:2] inside {WR_ADDR, WR_DATA, RD_ADDR} && counter_allcases % 14 != 0)     
            || (array_rand[0:2] inside {RD_DATA} && counter_read % 24 != 0))                          
                SS_n==0;
        else 
                SS_n==1;
        }

     
        constraint wr_rd_constraint {
            array_rand[0:2] inside {WR_ADDR, WR_DATA,RD_ADDR,RD_DATA};
        }

    constraint trans_ram
    {
            if (array_rand[0:2] == READ_DATA ) 
              {
                if(counter_read>13)
                tx_valid==1;
                if(counter_read<=13 )
                 tx_valid==0;
              } 
              else
              {
                 tx_valid==0;
              }
    } 

        function new(string name = "slave_seq_item");
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
