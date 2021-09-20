module sccomp_dataflow(
input clk_in,
input reset,
output [7:0] o_seg,
output [7:0] o_sel
);
wire [31:0] inst;
wire[31:0] pc;
wire [10:0]addr=pc[12:2];
wire [31:0]DM_data_out;
wire DM_ena;
wire DM_wena;
wire DM_rena;
wire [31:0]DM_addr;
wire [31:0]DM_data_in;
wire clk;
clk_div #(3)cpu_clk(clk_in,clk);
IM IM_uut(addr,inst);
DM DM_uut(clk,DM_ena,DM_wena,DM_rena,DM_addr,DM_data_in,DM_data_out);
cpu sccpu(clk,reset,inst,pc,DM_data_out,DM_ena,DM_wena,DM_rena,DM_addr,DM_data_in);
wire seg7_cs=1;
seg7x16 seg7(clk, reset, seg7_cs, pc, o_seg, o_sel);
endmodule

module clk_div #(parameter Time=20)
(
    input I_CLK,
    output reg O_CLK
);
    integer counter=0;
    initial O_CLK = 0;
    always @ (posedge I_CLK)
    begin
        if((counter+1)==Time/2)
        begin
            counter <= 0;
            O_CLK <= ~O_CLK;
        end
        else
            counter <= counter+1;
    end
endmodule