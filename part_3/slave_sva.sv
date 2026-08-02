// ////////////////////////////////////////////////////////////////////////////////
// // Author: Marwan Yasser & Mahmoud Kebiesy
// // Course: Digital Verification using SV & UVM
// //
// // Description: ram assertions 
// // 
// ////////////////////////////////////////////////////////////////////////////////
module slave_sva(SLAVE_IF.DUT slave_if );

typedef enum logic [2:0] {
  IDLE_M     = 3'b000,
  CHK_CMD_M  = 3'b001,
  WRITE_ADDR_M = 3'b010,
  WRITE_DATA_M = 3'b011,
  READ_ADDR_M  = 3'b100,
  READ_DATA_M  = 3'b101
} mon_state_e;

mon_state_e mon_state;

always_ff @(posedge slave_if.clk) begin
  if (!slave_if.rst_n)
    mon_state <= IDLE_M;
  else begin
    case (mon_state)
      IDLE_M:
        if ($fell(slave_if.SS_n))
          mon_state <= CHK_CMD_M;

      CHK_CMD_M:
        if ( slave_if.rx_data[9:8] == 2'b00)
          mon_state <= WRITE_ADDR_M;
        else if ( slave_if.rx_data[9:8] == 2'b01)
          mon_state <= WRITE_DATA_M;
        else if ( slave_if.rx_data[9:8] == 2'b10)
          mon_state <= READ_ADDR_M;

      WRITE_ADDR_M, WRITE_DATA_M, READ_ADDR_M, READ_DATA_M:
        if ($rose(slave_if.SS_n))
          mon_state <= IDLE_M;

      default:
        mon_state <= IDLE_M;
    endcase
  end
end


property reset_chk;
    @(posedge slave_if.clk)   (!slave_if.rst_n) |=> (slave_if.MISO==0 && slave_if.rx_data==0 && slave_if.rx_valid==0);
endproperty

property rx_valid_asserted;
    @(posedge slave_if.clk)  disable iff(!slave_if.rst_n)  
    ((slave_if.rx_data[9:8]==2'b00 || slave_if.rx_data[9:8]==2'b01 || slave_if.rx_data[9:8]==2'b10 || slave_if.rx_data[9:8]==2'b11) ) |-> ##10  (slave_if.rx_valid)  && (slave_if.SS_n)[->1];
endproperty


property IDLE_to_CHK_CMD;
  @(posedge slave_if.clk) disable iff(!slave_if.rst_n)
    (mon_state == IDLE_M && $fell(slave_if.SS_n)) |=> (mon_state == CHK_CMD_M);
endproperty


property CHK_CMD_valid_transitions;
  @(posedge slave_if.clk) disable iff(!slave_if.rst_n || slave_if.SS_n)
    (mon_state == CHK_CMD_M) |=> (mon_state inside {WRITE_ADDR_M, WRITE_DATA_M, READ_ADDR_M});
endproperty


property return_to_IDLE_on_ss_high;
  @(posedge slave_if.clk) disable iff(!slave_if.rst_n)
    (mon_state inside {WRITE_ADDR_M, WRITE_DATA_M, READ_ADDR_M} && $rose(slave_if.SS_n)) |=> 
    (mon_state == IDLE_M);
endproperty



assert property(reset_chk);
assert property(rx_valid_asserted);
assert property (IDLE_to_CHK_CMD);
assert property (CHK_CMD_valid_transitions);
assert property (return_to_IDLE_on_ss_high);

cover property(reset_chk);
cover property(rx_valid_asserted);
cover property (IDLE_to_CHK_CMD);
cover property (CHK_CMD_valid_transitions);
cover property (return_to_IDLE_on_ss_high);

endmodule