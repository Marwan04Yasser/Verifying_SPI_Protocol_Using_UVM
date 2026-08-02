package shared_pkg;
typedef enum bit [2:0] {WRITE_ADD=3'b000,WRITE_DATA=3'b001,READ_ADD=3'b110,READ_DATA=3'b111 } state_e;
int counter_allcases =0  ;
int counter_read=0;
 logic SS_n_prev=1;
endpackage