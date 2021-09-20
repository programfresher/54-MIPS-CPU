module DIVU(
input [31:0]dividend, //������
input [31:0]divisor, //����
input start, //������������
input clock,
input reset,
output [31:0]q, //��
output [31:0]r, //����
output busy //������æ��־λ
);
    integer i;
    reg [63:0]temp1;
    assign r=temp1[63:32],q=temp1[31:0],busy=start;
    always@(posedge clock or posedge reset)begin
        if(reset)
            temp1=64'b0;
        else begin
            if(start)begin
                temp1={32'b0,dividend};
                for(i=0;i<32;i=i+1)begin
                    temp1=temp1<<1;
                    if(temp1>={divisor,32'b0})
                        temp1=temp1-{divisor,32'b0}+1;
                end
            end
        end
    end
endmodule
