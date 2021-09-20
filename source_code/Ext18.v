module Ext18(
    input [17:0] in,
    output [31:0] out
);
    assign out = in[17]?{14'h3fff, in}:{14'b0, in};
endmodule
