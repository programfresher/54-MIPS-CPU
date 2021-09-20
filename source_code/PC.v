`timescale 1ns / 1ps
module PC(
input clk,
input rst,//异步复位信号
input [31:0]data_in,
output reg [31:0]data_out
    );
    
always@(negedge clk or posedge rst)
if(rst)
    data_out<=32'h00400000;
else 
    data_out<=data_in;

endmodule

