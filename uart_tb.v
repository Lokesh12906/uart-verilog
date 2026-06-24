`timescale 1ns/1ps

module uart_tb;

reg clk;
reg reset;
reg [7:0] data_in;
reg data_ready;

wire tx_serial;
wire rx_serial;
wire baud_tick;

wire [7:0] data_out;
wire data_valid;

assign rx_serial = tx_serial;

baud_gen BG(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick)
);

uart_tx TX(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .data_in(data_in),
    .data_ready(data_ready),
    .tx_serial(tx_serial)
);

uart_rx RX(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .rx_serial(rx_serial),
    .data_out(data_out),
    .data_valid(data_valid)
);

always #5 clk = ~clk;

initial
begin
    $monitor("Time=%0t | tx_state=%b tx_serial=%b | rx_state=%b rx_count=%0d | data_valid=%b data_out=%8b", $time, TX.state, tx_serial, RX.state, RX.bit_count, data_valid, data_out);
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tb);

clk = 0;
reset = 1;
data_ready = 0;
data_in = 8'b10101010;

#20
reset = 0;

#100
data_ready = 1;

#100
data_ready = 0;

#10000
$finish;

end

endmodule