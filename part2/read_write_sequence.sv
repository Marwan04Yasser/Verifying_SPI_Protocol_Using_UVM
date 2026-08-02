//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Marwan Yasser Rifaat
// Date:        2025-10
// Description: RAM_Environment
//==============================================================
package read_write_sequence_pkg;
import uvm_pkg::*;

import ram_seq_item_pkg::*;
`include "uvm_macros.svh"
class read_write_sequence extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(read_write_sequence);
ram_seq_item seq_item;

function new(string name="read_write_sequence");
super.new(name);
endfunction

task body;
seq_item=ram_seq_item::type_id::create("seq_item");
seq_item.seq_mode=READ_WRITE;
repeat(10000)begin
start_item(seq_item);    
assert(seq_item.randomize());
finish_item(seq_item);
end

endtask
endclass
endpackage