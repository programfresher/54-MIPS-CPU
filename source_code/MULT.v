module MULT(
input clk, //�˷���ʱ���ź�
input reset, //��λ�źţ��ߵ�ƽ��Ч
input [31:0] a, //������a(������)
input [31:0] b, //������b��������
output[63:0] z //�˻����z
    );
    integer i;
    reg temp1;
    reg [32:0]temp2;
    reg [32:0]temp3;
    reg  [64:0] c;
    assign z=c[63:0];
    always@(*)
        begin
        if(reset)
            c=65'b0;
        else
            begin
            temp1=0;
            if(a[31]==1)
            begin
            temp2={1'b1,a};
            end
            else
            begin
            temp2={1'b0,a};
            end
            temp3=~temp2+1;
            c={33'b0,b};
            for(i=1;i<=32;i=i+1)
                begin
                if(c[0]<temp1)
                    c=c+{temp2,32'b0};
                if(c[0]>temp1)
                    c=c+{temp3,32'b0};
                temp1=c[0];
                if(i!=33)
                    begin
                    if(c[64]==1)
                    begin
                    c=c>>1;
                    c[64]=1;
                    end
                    else
                    c=c>>1;
                    end
                end
            end
        end
endmodule
