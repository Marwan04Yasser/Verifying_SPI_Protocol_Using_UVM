package slave_main_sequence_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import shared_pkg::*;
  import slave_seq_item_pkg::*;

  class main_sequence extends uvm_sequence #(slave_seq_item);
    `uvm_object_utils(main_sequence)
     slave_seq_item seq_item;

        function new(string name = "SPI_wr_rd_sequence");
            super.new(name);
        endfunction

    task body();
        seq_item = slave_seq_item::type_id::create("seq_item");
        
        repeat(10000) begin
            start_item(seq_item);
            seq_item.trans_ram.constraint_mode(1);
            if(seq_item.SS_n)begin
             seq_item.tx_data.rand_mode(1);
             seq_item.wr_rd_constraint.constraint_mode(1);
            end   else begin
              seq_item.tx_data.rand_mode(0);
              seq_item.wr_rd_constraint.constraint_mode(0);
            end
            if(seq_item.SS_n && (seq_item.array_rand[0:2] inside {3'b000,3'b001,3'b110})
            ||seq_item.SS_n  && (seq_item.array_rand[0:2] inside {3'b111})) begin
                seq_item.array_rand.rand_mode(1);
            end
            else begin
                seq_item.array_rand.rand_mode(0);
            end
            assert (seq_item.randomize() with {seq_item.array_rand[0:2] inside {3'b000,3'b001,3'b110,3'b111};});
            finish_item(seq_item);
        end
    endtask
  endclass
endpackage
