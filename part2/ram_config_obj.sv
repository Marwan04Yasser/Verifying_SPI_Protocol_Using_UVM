//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Marwan Yasser Rifaat
// Date:        2025-10
// Description: RAM_Environment
//==============================================================
package ram_obj_config_pkg;
import uvm_pkg::*; 
`include "uvm_macros.svh"
class ram_config extends uvm_object;
`uvm_object_utils(ram_config)

virtual  RAM_IF ram_vif;

function new(string name="ram_config");
super.new(name);
endfunction

endclass
endpackage