//==============================================================
// Project:     SPI Slave with Single Port RAM
// Author:      Marwan Yasser Rifaat
// Date:        2025-10
// Description: RAM_sva
//==============================================================
package ram_scoreboard_pkg;
import ram_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ram_scoreboard extends uvm_scoreboard;
`uvm_component_utils(ram_scoreboard)

uvm_analysis_export   #(ram_seq_item)  sb_export;
uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;

ram_seq_item seq_item_sb;
int error_count=0;
int correct_count=0;

  function new(string name ="ram_scoreboard" , uvm_component parent = null);
  super.new(name,parent);
  endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
sb_export = new("sb_export",this);
sb_fifo =   new("sb_fifo",this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
sb_export.connect(sb_fifo.analysis_export);
endfunction



 task run_phase(uvm_phase phase);
 super.run_phase(phase);
forever begin
    sb_fifo.get(seq_item_sb);
      //compare   
    if(seq_item_sb.dout!=seq_item_sb.dataout_golden || seq_item_sb.tx_valid!=seq_item_sb.tx_valid_golden)begin
        `uvm_error("run_phase", $sformatf("Comparison failed , Transaction recieved by the DUT :%s while the ref_out:0h%b & ref_tx_valid=0b%b",
                    seq_item_sb.convert2string(),seq_item_sb.dataout_golden,seq_item_sb.tx_valid_golden ));
         error_count++;
    end
    else begin
        `uvm_info("run_phase", $sformatf("correct  output:%s ", seq_item_sb.convert2string()), UVM_HIGH);
        correct_count++;
    end 
end
 endtask

function void report_phase(uvm_phase phase);
super.report_phase(phase);
 `uvm_info("report_phase", $sformatf("Total succesful transactions: %0d",correct_count), UVM_MEDIUM);
 `uvm_info("report_phase", $sformatf("Total Failed transactions: %0d",error_count), UVM_MEDIUM);
endfunction 

endclass
endpackage   