module IM(
input [10:0]addr,
output [31:0]data_out
    );
dist_mem_gen_0 uut(addr,data_out);
endmodule
