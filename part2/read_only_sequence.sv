//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Marwan Yasser Rifaat
// Date:        2025-10
// Description: RAM_Environment
//==============================================================
package read_only_sequence_pkg;
import uvm_pkg::*;

import ram_seq_item_pkg::*;
`include "uvm_macros.svh"
class read_only_sequence extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(read_only_sequence);
ram_seq_item seq_item;

function new(string name="read_only_sequence");
super.new(name);
endfunction

task body;
seq_item=ram_seq_item::type_id::create("seq_item");
seq_item.seq_mode=READ_ONLY;
repeat(10000)begin
start_item(seq_item);    
assert(seq_item.randomize() with {seq_item.din[9:8] inside {2'b10, 2'b11} ;});
finish_item(seq_item);
end

endtask
endclass
endpackage