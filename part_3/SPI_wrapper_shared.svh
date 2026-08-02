package shared;
 typedef enum bit [2:0] {
      WRITE_ADD  = 3'b000,
      WRITE_DATA = 3'b001,
      READ_ADD   = 3'b110,
      READ_DATA  = 3'b111
    } state_e;

    typedef enum bit [1:0] {
      MODE_WR_ONLY  = 2'b00,
      MODE_RD_ONLY  = 2'b01,
      MODE_RD_WR    = 2'b10
    } mode_t;

endpackage
