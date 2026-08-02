package SPI_wrapper_scoreboard_pkg;
import SPI_wrapper_sequencer_pkg::*;
import SPI_wrapper_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class SPI_wrapper_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(SPI_wrapper_scoreboard);
    uvm_analysis_export #(SPI_wrapper_seq_item)sb_export;
    uvm_tlm_analysis_fifo #(SPI_wrapper_seq_item) sb_fifo;
    SPI_wrapper_seq_item seq_item_sb;
  
    int error_count , correct_count;

    
  function new (string name = "SPI_wrapper_scoreboard",uvm_component parent = null);
    super.new(name,parent);
  endfunction

   function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  sb_export = new("sb_export",this);
  sb_fifo = new("sb_fifo",this);
endfunction : build_phase

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
endfunction

task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
      sb_fifo.get(seq_item_sb);
      if (seq_item_sb.MISO === seq_item_sb.MISO_golden ) begin
        `uvm_info("run_phase", $sformatf("correct out : %s",seq_item_sb.convert2string()),UVM_HIGH);
            correct_count++;
      end
      else begin
        `uvm_error("run_phase",$sformatf("comparsion failed , transaction received by the dut :%s while the ref MISO : 0b%0b , MISO_exp: 0b%0b  ",
         seq_item_sb.convert2string(),seq_item_sb.MISO ,seq_item_sb.MISO_golden));
            error_count++;
      end
    end
endtask
function void report_phase(uvm_phase phase);
    super.report_phase(phase);
   `uvm_info("report_phase",$sformatf("total succ trans : %0d",correct_count),  UVM_LOW);
   `uvm_info("report_phase",$sformatf("total fail trans : %0d",error_count),UVM_LOW);
endfunction
endclass
    
endpackage
