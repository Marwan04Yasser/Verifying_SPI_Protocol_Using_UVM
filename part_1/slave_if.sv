interface SLAVE_IF (clk);
    parameter IDLE     =3'b000;
    parameter CHK_CMD  =3'b001;
    parameter WRITE    =3'b010;
    parameter READ_ADD =3'b011;
    parameter READ_DATA=3'b100;

    input clk;
    logic   rst_n,SS_n;
    logic   MOSI, MISO;
    logic   [7:0] tx_data;
    bit         tx_valid;
    logic  [9:0] rx_data;
    bit rx_valid;

    logic MISO_golden,rx_valid_golden;
    logic [9:0] rx_data_golden ;
    
    reg [2:0]cs,ns;

modport DUT(input MOSI,SS_n,clk,rst_n,tx_data,tx_valid ,output MISO,rx_data,rx_valid,cs,ns);
endinterface : SLAVE_IF

