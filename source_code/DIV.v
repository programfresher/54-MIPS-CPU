module DIV(
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
    reg [31:0]temp2;
    assign r=(dividend[31]==0)?temp1[63:32]:(~temp1[63:32]+1);
    assign q=(dividend[31]==divisor[31])?temp1[31:0]:(~temp1[31:0]+1);
    assign busy=start;
    always@(posedge clock or posedge reset)begin
        if(reset)
            temp1=64'b0;
        else begin
            if(start)begin
                if(dividend[31]==0)
                    temp1={32'b0,dividend};
                else
                    temp1={32'b0,~dividend+1};
                if(divisor[31]==0)
                    temp2={32'b0,divisor};
                else
                    temp2={32'b0,~divisor+1};
                for(i=0;i<32;i=i+1)begin
                    temp1=temp1<<1;
                    if(temp1>={temp2,32'b0})
                        temp1=temp1-{temp2,32'b0}+1;
                end
            end
        end
    end
endmodule
