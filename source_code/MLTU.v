module MULTU(
input clk, //�˷���ʱ���ź�
input reset, //��λ�źţ��ߵ�ƽ��Ч
input [31:0] a, //������a(������)
input [31:0] b, //������b��������
output[63:0] z //�˻����z
    );
    integer i;
    reg  [65:0] c;
    assign z=c[63:0];
        
    always@(posedge clk or posedge  reset)
    begin
        if(reset)
            c=66'b0;
        else
            begin
            c={34'b0,b};
            for(i=0;i<32;i=i+1)
                begin
                if(c[0]==1)
                    c=c+{a,32'b0};
                c=c>>1; 
                end
            end
    end

endmodule
