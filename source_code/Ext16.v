module Ext16 (
    input [15:0] in,
    input sign_ext,
    output [31:0] out
);
    assign out = (sign_ext&&in[15])?{16'hffff, in}:{16'b0, in};
endmodule
