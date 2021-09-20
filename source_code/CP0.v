module CP0( 
input clk, 
input rst, 
input mfc0,   
input mtc0,     
input [31:0]pc, 
input [4:0] Rd,   
input [31:0] wdata,    
input exception, 
input eret,          
input [4:0]cause, 
output [31:0] rdata,     
output [31:0] status, 
output [31:0]exc_addr
);
parameter   SYSCALL=5'b10000,
            BREAK=5'b10010,
            TEQ=5'b11010,
            STATUS=12,
            EPC=14,
            CAUSE=13;

reg [31:0]CP_reg[31:0];
assign status=CP_reg[STATUS];
assign rdata=mfc0?CP_reg[Rd]:32'bz;
assign exc_addr=eret?CP_reg[EPC]:32'h00400004;
integer i;
always@(posedge clk or posedge rst)begin
    if(rst)begin
        for(i=0;i<32;i=i+1)
            CP_reg[i]=32'h00000000;
    end
    else begin
        if(mtc0)begin
            CP_reg[Rd]=wdata;
        end
        else if(exception) begin
            CP_reg[STATUS]= CP_reg[STATUS]<<5;
            CP_reg[EPC]=pc;
            CP_reg[CAUSE]={25'h0,cause,2'b0};
        end if(eret) begin
            CP_reg[STATUS]=CP_reg[STATUS]>>5;
        end
    end
end
    
endmodule