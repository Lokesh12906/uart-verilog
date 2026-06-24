module uart_tx(
    input clk,
    input reset,
    input baud_tick,
    input [7:0] data_in,
    input data_ready,
    output reg tx_serial,
    output tx_busy
);

parameter IDLE  = 0,
          START = 1,
          DATA  = 2,
          STOP  = 3;

reg [1:0] state;
reg [2:0] bit_index;
reg [7:0] data_reg;

assign tx_busy = (state != IDLE);

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        state <= IDLE;
        tx_serial <= 1'b1;
        bit_index <= 3'd0;
        data_reg <= 8'd0;
    end

    else if(baud_tick)
    begin
        case(state)

        IDLE:
        begin
            tx_serial <= 1'b1;

            if(data_ready)
            begin
                data_reg <= data_in;
                state <= START;
            end
        end

        START:
        begin
            tx_serial <= 1'b0;
            bit_index <= 3'd0;
            state <= DATA;
        end

        DATA:
        begin
            tx_serial <= data_reg[bit_index];

            $display("TX: bit_index=%0d sending=%b",
                     bit_index,
                     data_reg[bit_index]);

            if(bit_index == 3'd7)
                state <= STOP;
            else
                bit_index <= bit_index + 1'b1;
        end

        STOP:
        begin
            tx_serial <= 1'b1;
            state <= IDLE;
        end

        endcase
    end
end

endmodule