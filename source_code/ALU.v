module Alu(
input[31:0]a,
input[31:0]b,
input[3:0]aluc,
output reg[31:0]r,
output reg zero,
output reg carry,
output reg negative,
output reg overflow
    );
wire [31:0]com;
assign com=(aluc==12)?b>>>(a-1):((aluc==13)?b>>(a-1):b<<(a-1));
always@(*)
begin

//ADD
if(aluc[3]==0&&aluc[2]==0&&aluc[1]==0&&aluc[0]==0)
begin
r<=a+b;
if(r==0)
zero<=1;
else
zero<=0;
if(r<a||r<b)
carry<=1;
else
carry<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
end

//SUBU
else if(aluc[3]==0&&aluc[2]==0&&aluc[1]==0&&aluc[0]==1)
begin
r<=a-b;
if(r==0)
zero<=1;
else
zero<=0;
if(a<b)
carry<=1;
else
carry<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
end

//ADD
else if(aluc[3]==0&&aluc[2]==0&&aluc[1]==1&&aluc[0]==0)
begin
r<=a+b;
if(r==0)
zero<=1;
else
zero<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
if((a[31]&b[31]&(~r[31]))||(a[31]==0&&b[31]==0&&r[31]==1))
overflow<=1;
else
overflow<=0;
end

//SUB
else if(aluc[3]==0&&aluc[2]==0&&aluc[1]==1&&aluc[0]==1)
begin
r<=a-b;
if(r==0)
zero<=1;
else
zero<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
if((a[31]==1&&b[31]==0&&r[31]==0)||(a[31]==0&&b[31]==1&&r[31]==1))
overflow<=1;
else
overflow<=0;
end

//AND
else if(aluc[3]==0&&aluc[2]==1&&aluc[1]==0&&aluc[0]==0)
begin
r<=a&b;
if(r==0)
zero<=1;
else
zero<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
end

//OR
else if(aluc[3]==0&&aluc[2]==1&&aluc[1]==0&&aluc[0]==1)
begin
r<=a|b;
if(r==0)
zero<=1;
else
zero<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
end

//XOR
else if(aluc[3]==0&&aluc[2]==1&&aluc[1]==1&&aluc[0]==0)
begin
r<=a^b;
if(r==0)
zero<=1;
else
zero<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
end

//NOR
else if(aluc[3]==0&&aluc[2]==1&&aluc[1]==1&&aluc[0]==1)
begin
r<=~(a|b);
if(r==0)
zero<=1;
else
zero<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
end

//LUI
else if(aluc[3]==1&&aluc[2]==0&&aluc[1]==0)
begin
r<={b[15:0],16'b0};
if(r==0)
zero<=1;
else
zero<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
end

//SLTU
else if(aluc[3]==1&&aluc[2]==0&&aluc[1]==1&&aluc[0]==0)
begin
r<=(a<b)?1:0;
if(a-b==0)
zero<=1;
else
zero<=0;
if(a<b)
carry<=1;
else
carry<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
end

//SLT
else if(aluc[3]==1&&aluc[2]==0&&aluc[1]==1&&aluc[0]==1)
begin
if((a[31]==0&&b[31]==0)||(a[31]==1&&b[31]==1))
r<=(a<b)?1:0;
else if(a[31]==0&&b[31]==1)
r<=0;
else
r<=1;
if(a-b==0)
zero<=1;
else
zero<=0;
if(r==1)
negative<=1;
else
negative<=0;
end

//SRA
else if(aluc[3]==1&&aluc[2]==1&&aluc[1]==0&&aluc[0]==0)
begin

if(b[31]==1)
r<=~(~b>>a);
else
r<=b>>a;
if(r==0)
zero<=1;
else
zero<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
carry<=com[0];
end

//SRL
else if(aluc[3]==1&&aluc[2]==1&&aluc[1]==0&&aluc[0]==1)
begin
r<=b>>a;
if(r==0)
zero<=1;
else
zero<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
carry<=com[0];
end

else 
begin
r<=b<<a;
if(r==0)
zero<=1;
else
zero<=0;
if(r[31]==1)
negative<=1;
else
negative<=0;
carry<=com[31];
end


end
endmodule
