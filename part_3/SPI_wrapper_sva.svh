module SPI_wrapper_sva(SPI_wrapper_if.DUT SPI_wrapperif);

property p_reset_outputs_inactive;
    @(posedge SPI_wrapperif.clk)
      ~SPI_wrapperif.rst_n |=> (SPI_wrapperif.MISO == 0 && SPI_wrapperif.rx_valid == 0 && SPI_wrapperif.rx_data == 8'h00);
  endproperty

  assert property (p_reset_outputs_inactive);
  cover property (p_reset_outputs_inactive);

sequence SEQ;
  $fell(SPI_wrapperif.SS_n) ##1 (SPI_wrapperif.MOSI [*3]) ##1 $rose(SPI_wrapperif.SS_n);
endsequence

property p_miso_stable;
    @(posedge SPI_wrapperif.clk) disable iff (!SPI_wrapperif.rst_n)
        $fell(SPI_wrapperif.SS_n) |=> 
            (not SEQ ##1 ($stable(SPI_wrapperif.MISO) throughout (!SPI_wrapperif.SS_n)) );
endproperty

  assert property (p_miso_stable);
  cover property (p_miso_stable);
  
endmodule