module SPI_slave_GOLD(
    input   MOSI,
    output reg  MISO,
    input   SS_n,
    input   clk,
    input   rst_n,
    input   [7:0] tx_data,
    input         tx_valid,
    output reg  [9:0] rx_data,
    output reg        rx_valid
);

localparam IDLE      = 3'b000;
localparam CHK_CMD   = 3'b001;
localparam WRITE     = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

    reg [2:0] cs, ns;
    reg       rd_check;
    reg [3:0] counter ;   


    always @(posedge clk) begin
        if (~rst_n)
            cs <= IDLE;
        else
            cs <= ns;
    end

    always @(*) begin
        case (cs)
             IDLE:  ns =  (~SS_n)?  CHK_CMD :  IDLE;
                
             CHK_CMD: begin
                if (SS_n)
                    ns = IDLE;
                else if (MOSI == 0)
                    ns = WRITE;
                else if (MOSI == 1 && rd_check == 0)
                    ns = READ_ADD;
                else if (MOSI == 1 && rd_check == 1)
                    ns = READ_DATA;
                else
                    ns = CHK_CMD; 
            end


             WRITE: ns = (SS_n) ? IDLE : WRITE;

             READ_ADD: ns = (SS_n) ?  IDLE : READ_ADD;
                   
             READ_DATA:ns = (SS_n) ?  IDLE : READ_DATA;

        endcase
    end

    always @(posedge clk) begin
        if (~rst_n) begin
            rx_data<=0;
            rx_valid  <= 1'b0;
            counter   <= 10;
            rd_check  <= 0;
            MISO      <= 1'b0;
        end else begin 
             
            case (cs)
                IDLE: begin 
                    rx_valid<=0; 
                    rx_data<=0;
                    MISO<=1'b0;
                end 
                CHK_CMD:begin
                    counter <= 10;
                end    

                WRITE: begin
                        if (counter > 0) begin
                             rx_data[counter-1] <= MOSI;
                             counter <= counter - 1;   
                        end 
                        else begin
                             rx_valid <= 1;
                        end
                    end
                
                READ_ADD: begin
                        if (counter > 0) begin
                             rx_data[counter-1] <= MOSI;
                            counter <= counter - 1;
                        end else begin
                             rx_valid<=1;
                             rd_check<=1;
                        end
                    end
            
                READ_DATA: begin
                       if (tx_valid ==1) begin
                         rx_valid <= 0;
                         if (counter > 0)begin
                                 MISO <= tx_data[counter-1];
                                 counter <= counter - 1;
                        end   
                         else begin 
                                rd_check<=0;
                         end 
                         end
                        else begin 
                        if (counter > 0) begin 
                             rx_data[counter-1] <= MOSI;
                             counter <= counter - 1;
                        end
                         else begin
                             rx_valid <= 1;
                             counter <= 8;
                        end
                        end
                end     
             endcase

        end  
    end 
endmodule
