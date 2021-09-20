module cpu(
input clk,
input rst,
input [31:0] inst,
output [31:0] pc,
input [31:0]DM_data_out,
output DM_ena,
output DM_wena,
output DM_rena,
output [31:0]DM_addr,
output [31:0]DM_data_in
);
wire [5:0]op;
wire [5:0]func;
wire [4:0]rs;
wire [4:0]rt;
wire [4:0]rd;
wire [4:0]shamt;
wire [15:0]imme16;
wire [25:0]imme26;
INSTR uut_intsr(inst,op,rs,rt,rd,shamt,func,imme16,imme26);

wire ADD=(op==6'b0&&func==6'b100000)?1:0;
wire ADDU=(op==6'b0&&func==6'b100001)?1:0;
wire SUB=(op==6'b0&&func==6'b100010)?1:0;
wire SUBU=(op==6'b0&&func==6'b100011)?1:0;
wire AND=(op==6'b0&&func==6'b100100)?1:0;
wire OR=(op==6'b0&&func==6'b100101)?1:0;
wire XOR=(op==6'b0&&func==6'b100110)?1:0;
wire NOR=(op==6'b0&&func==6'b100111)?1:0;
wire SLT=(op==6'b0&&func==6'b101010)?1:0;
wire SLTU=(op==6'b0&&func==6'b101011)?1:0;
wire SLL=(op==6'b0&&func==6'b000000)?1:0;
wire SRL=(op==6'b0&&func==6'b000010)?1:0;
wire SRA=(op==6'b0&&func==6'b000011)?1:0;
wire SLLV=(op==6'b0&&func==6'b000100)?1:0;
wire SRLV=(op==6'b0&&func==6'b000110)?1:0;
wire SRAV=(op==6'b0&&func==6'b000111)?1:0;
wire JR=(op==6'b0&&func==6'b001000)?1:0;
wire ADDI=(op==6'b001000)?1:0;
wire ADDIU=(op==6'b001001)?1:0;
wire ANDI=(op==6'b001100)?1:0;
wire ORI=(op==6'b001101)?1:0;
wire XORI=(op==6'b001110)?1:0;
wire LUI=(op==6'b001111)?1:0;
wire LW=(op==6'b100011)?1:0;
wire SW=(op==6'b101011)?1:0;
wire BEQ=(op==6'b000100)?1:0;
wire BNE=(op==6'b000101)?1:0;
wire SLTI=(op==6'b001010)?1:0;
wire SLTIU=(op==6'b001011)?1:0;
wire J=(op==6'b000010)?1:0;
wire JAL=(op==6'b000011)?1:0;


wire DIV=(op==6'b0&&rd==5'b0&&shamt==5'b0&&func==6'b011010)?1:0;
wire DIVU=(op==6'b0&&rd==5'b0&&func==6'b011011)?1:0;
wire MULT=(op==6'b0&&rd==5'b0&&func==6'b011000)?1:0;
wire MULTU=(op==6'b0&&rd==5'b0&&func==6'b011001)?1:0;
wire BGEZ=(op==6'b000001&&rt==5'b00001)?1:0;
wire JALR=(op==6'b0&&rt==5'b0&&func==6'b001001)?1:0;
wire LBU=(op==6'b100100)?1:0;
wire LHU=(op==6'b100101)?1:0;
wire LB=(op==6'b100000)?1:0;
wire LH=(op==6'b100001)?1:0;
wire SB=(op==6'b101000)?1:0;
wire SH=(op==6'b101001)?1:0;
wire BREAK=(op==6'b0&&func==6'b001101)?1:0;
wire SYSCALL=(op==6'b0&&func==6'b001100)?1:0;
wire ERET=(op==6'b010000&&rs==5'b10000&&rt==5'b0&&rd==5'b0&&shamt==5'b0&&func==6'b011000)?1:0;
wire MFHI=(op==6'b0&&rs==5'b0&&rt==5'b0&&shamt==5'b0&&func==6'b010000)?1:0;
wire MFLO=(op==6'b0&&rs==5'b0&&rt==5'b0&&shamt==5'b0&&func==6'b010010)?1:0;
wire MTHI=(op==6'b0&&rt==5'b0&&rd==5'b0&&shamt==5'b0&&func==6'b010001)?1:0;
wire MTLO=(op==6'b0&&rt==5'b0&&rd==5'b0&&shamt==5'b0&&func==6'b010011)?1:0;
wire MFC0=(op==6'b010000&&rs==5'b0&&shamt==5'b0&&func==6'b0)?1:0;
wire MTC0=(op==6'b010000&&rs==5'b00100&&shamt==5'b0&&func==6'b0)?1:0;
wire CLZ=(op==6'b011100&&shamt==5'b0&&func==6'b100000)?1:0;
wire TEQ=(op==6'b0&&func==6'b110100)?1:0;
wire MUL=(op==6'b011100&&func==6'b000010)?1:0;

wire [31:0]CP0_rdata;
wire [31:0]CP0_status;
wire [31:0]CP0_exc_addr;
reg [31:0]LO;
reg [31:0]HI;

wire [31:0]ext5;
wire [31:0]ext16;
wire [31:0]ext18;
wire [31:0]alu_a;
wire [31:0]alu_b;
wire [3:0]aluc;
wire [31:0]alu_data;
wire zero;
wire carry;
wire negative;
wire overflow;


wire [63:0]mult_z;
wire [63:0]multu_z;

wire RF_w=MUL||ADD||ADDU||SUB||SUBU||AND||OR||XOR||NOR||SLT||SLTU||SLL||SRL||SRA||SLLV||SRLV||SRAV||ADDI||ADDIU||
ANDI||ORI||XORI||LUI||LW||SLTI||SLTIU||JAL||MFHI||MFLO||LBU||LHU||LB||LH||CLZ||JALR||MFC0;
wire [4:0]RF_waddr=JAL?5'h1f:(ADDI||ADDIU||ANDI||ORI||XORI||LUI||LW||SLTI||SLTIU||LBU||LHU||LB||LB||LH||MFC0?rt:rd);
wire [31:0]rs_data;
wire [31:0]rt_data;
wire [31:0]tmp;
wire [7:0]LB_tmp=(alu_data%4==0)?DM_data_out[7:0]:((alu_data%4==1)?DM_data_out[15:8]:
(alu_data%4==2)?DM_data_out[23:16]:
DM_data_out[31:24]);
wire [15:0]LH_tmp=(alu_data%4==0)?DM_data_out[15:0]:DM_data_out[31:16];
assign tmp=LW?DM_data_out:(LBU||(LB&&LB_tmp[7]==0)?{24'b0,LB_tmp}:(LHU||(LH&&LH_tmp[15]==0)?
{16'b0,LH_tmp[15:0]}:(LB?{24'hffffff,LB_tmp}:{16'hffff,LH_tmp[15:0]})));

reg [31:0]CLZ_in;
integer i;
always@(*)
begin
    for( i=31;rs_data[i]==0&&i!=0;i=i-1)begin
    end
    if(i==0&&rs_data[i]==0)begin
        CLZ_in=32;
    end
    else if(i==0)begin
        CLZ_in=31;
    end
    else
        CLZ_in=31-i;
end

wire [31:0]RF_wdata=MUL?mult_z[31:0]:(MFC0?CP0_rdata:(CLZ?CLZ_in:(MFLO?LO:(MFHI?HI:(JAL||JALR?(pc+4):(LW||LBU||LHU||LB||LH?tmp:alu_data))))));
regfile cpu_ref(clk,rst,RF_w,rs,rt,RF_waddr,RF_wdata,rs_data,rt_data);


assign alu_a=(SLL||SRL||SRA)?ext5:rs_data;
assign alu_b=((SLTI||SLTIU||SW||SB||SH||LW||LBU||LHU||LB||LH||LUI||XORI||ORI||ANDI||ADDIU||ADDI)?ext16:rt_data);
assign aluc[3]=LUI||SLT||SLTI||SLTIU||SLTU||SLL||SRL||SRA||SLLV||SRLV||SRAV||SRAV;
assign aluc[2]=AND||OR||XOR||NOR||SRA||SLL||SRL||ANDI||ORI||XORI||SRAV||SLLV||SRLV||BEQ||BNE;
assign aluc[1]=ADD||ADDI||SUB||XOR||XORI||NOR||SLT||SLTI||SLTU||SLTIU||SLL||SLLV||BEQ||BNE;
assign aluc[0]=SUBU||SUB||OR||ORI||NOR||SLT||SLTI||SRL||SRLV;
Alu uut_ALU(alu_a,alu_b,aluc,alu_data,zero,carry,negative,overflow);


wire sign_ext16=BGEZ||BNE||BEQ||ADDI||SW||SB||SH||LW||LBU||LHU||LB||LH||SLTI||ADDIU;//第二条指令改�???????
Ext5 uut_Ext5(shamt,ext5);
Ext16 uut_Ext16((BEQ||BNE||BGEZ)?{imme16[13:0],2'b0}:imme16,sign_ext16,ext16);
Ext18 uut_Ext18({imme16,2'b00},ext18);

assign DM_ena=SW||SB||SH||LW||LBU||LHU||LB||LH;
assign DM_wena=SW||SB||SH;
assign DM_rena=SW||SB||SH||LW||LBU||LHU||LB||LH;
assign DM_addr=(alu_data- 32'h10010000) / 4;
wire [31:0]SB_TMP=(alu_data%4==0)?{DM_data_out[31:8],rt_data[7:0]}:
((alu_data%4==1)?{DM_data_out[31:16],rt_data[7:0],DM_data_out[7:0]}:
(alu_data%4==2)?{DM_data_out[31:24],rt_data[7:0],DM_data_out[15:0]}:
{rt_data[7:0],DM_data_out[23:0]});
wire [31:0]SH_TMP=(alu_data%4==0)?{DM_data_out[31:16],rt_data[15:0]}:{rt_data[15:0],DM_data_out[15:0]};
assign DM_data_in=SW?rt_data:(SH?SH_TMP:SB_TMP);


wire [31:0]div_q;
wire [31:0]div_r;
wire div_busy;
wire [31:0]divu_q;
wire [31:0]divu_r;
wire divu_busy;
DIV uut_DIV(rs_data,rt_data,DIV,clk,rst,div_q,div_r,div_busy);
DIVU uut_DIVU(rs_data,rt_data,DIVU,clk,rst,divu_q,divu_r,divu_busy);


MULT uut_mult(clk,rst,rs_data,rt_data,mult_z);
MULTU uut_multu(clk,rst,rs_data,rt_data,multu_z);
always@(*)
begin
    if(DIV)begin
        LO=div_q;
        HI=div_r;
    end
    else if(DIVU)begin
        LO=divu_q;
        HI=divu_r;
    end
    else if(MULT)begin
        LO=mult_z[31:0];
        HI=mult_z[63:32];
    end
    else if(MULTU)begin
        LO=multu_z[31:0];
        HI=multu_z[63:32];
    end
    else if(MTHI)begin
        HI=rs_data;
    end
    else if(MTLO)begin
        LO=rs_data;
    end
end

reg [31:0]t;
always@(posedge clk)begin
t=rs_data;
end

wire [31:0]npc;
assign npc=pc+4;
wire [31:0]connect={npc[31:28],imme26[25:0],2'b0};
wire [31:0]pc_in=ERET||(BREAK&&CP0_status[2])||(SYSCALL&&CP0_status[1])||(TEQ&&CP0_status[3])?CP0_exc_addr:((J||JAL)?connect:(((BEQ&&alu_data==0)||(BNE&&alu_data)||(BGEZ&&rs_data[31]==0))?(npc+ext18):(JR||JALR?t:npc)));
PC uut_PC(clk,rst,pc_in,pc);

wire teq=(rs_data==rt_data&&TEQ);
parameter   uut_SYSCALL=5'b1000,
            uut_BREAK=5'b1001,
            uut_TEQ=5'b1101;
wire [4:0]cause=SYSCALL?uut_SYSCALL:(BREAK?uut_BREAK:(TEQ?uut_TEQ:5'bz));
CP0 uut_CP0(clk,rst,MFC0,MTC0,npc,rd,rt_data,TEQ||SYSCALL||BREAK,ERET,cause,CP0_rdata,CP0_status,CP0_exc_addr);


endmodule
