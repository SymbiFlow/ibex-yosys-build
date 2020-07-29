`timescale 1ns/1ps

module tb;

reg clk = '0;
reg rst = '0;
reg [3:0] leds;

top_artya7 top(.IO_CLK(clk), .IO_RST_N(rst), .LED(leds));

always #5 clk = !clk;
initial begin $dumpfile("dump.vcd"); $dumpvars(0); end
initial #8000 $finish;
initial #100 rst <= '1;

endmodule
