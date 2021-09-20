module DM(
input clk,
input ena,//使能信号，高位有�??
input wena,//�??
input rena,//�??
input [31:0]addr,
input [31:0]data_in,
output [31:0]data_out
    );
    
reg [31:0]store[255:0];

always @(negedge clk)
begin
    if(ena&&wena)
        store[addr]<=data_in;
end
assign data_out=ena?(rena?store[addr]:data_out):32'bz;
endmodule
