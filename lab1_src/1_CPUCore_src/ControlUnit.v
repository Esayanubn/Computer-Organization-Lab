`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: ControlUnit
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: RISC-V Instruction Decoder
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
`define ControlOut {{Jal,Jalr},{MemToReg},{RegWrite},{MemWrite},{LoadNpc},{RegRead},{BranchType},{AluContrl},{AluSrc1,AluSrc2},{ImmType}}
module ControlUnit(
    input wire [6:0] Op,
    input wire [2:0] Fn3,
    input wire [6:0] Fn7,
	input wire [31:7] In,
	input wire [2:0] Type,
    output reg Jal,//
    output reg Jalr,//
    output reg [2:0] RegWrite,//L-type
    output reg MemToReg,//
    output reg [3:0] MemWrite,//S-type
    output reg LoadNpc,//
    output reg [1:0] RegRead,//
    output reg [2:0] BranchType,//
    output reg [3:0] AluContrl,//
    output reg [1:0] AluSrc2,//
    output reg AluSrc1,//
    output reg [2:0] ImmType,//
	output reg [31:0] Imm//
    );
    
    //J-type jal,jalr,loadnpc
    always @(*) begin
        case (Op)
            7'b1101111:  begin
                Jal <= 1'b1;
                Jalr <= 1'b0;  
                LoadNpc <= 1'b1;    
            end
            7'b1100111:  begin
                Jal <= 1'b0;
                Jalr <= 1'b1;  
                LoadNpc <= 1'b1;    
            end
            default:  begin
                Jal <= 1'b0;
                Jalr <= 1'b0;  
                LoadNpc <= 1'b0;    
            end                          
        endcase
    end
    
    //RegWrite
    always @(*) begin
        case (Op) 
            7'b0110011, 7'b0010011, 7'b0110111, 7'b0010111, 7'b1101111, 7'b1100111:
                 RegWrite <= `LW;
            7'b0100011, 7'b1100011:     
                RegWrite <= `NOREGWRITE; 
            7'b0000011: begin
                case(Fn3)
                    3'b000:     RegWrite <= `LB;
                    3'b001:     RegWrite <= `LH;
                    3'b010:     RegWrite <= `LW;
                    3'b100:     RegWrite <= `LBU;
                    3'b101:     RegWrite <= `LHU;
                    default:    RegWrite <= `NOREGWRITE;
                endcase    
            end   
            default:    RegWrite <= `NOREGWRITE;             
        endcase
    end
    
    //MemToReg
    always @(*) begin
        if (Op == 7'b0000011)  
            MemToReg <= 1'b1;
        else
            MemToReg <= 1'b0;
    end
    
    //MemWrite
    always @(*) begin
        if (Op == 7'b0100011) begin
            case(Fn3)
                3'b000:     MemWrite <= 4'b0001;
                3'b001:     MemWrite <= 4'b0011;
                3'b010:     MemWrite <= 4'b1111;
                default:    MemWrite <= 4'b0000;
            endcase                     
        end
        else 
            MemWrite <= 4'b0000;
    end
    
    //RegRead
    always @(*) begin
        case (Op)
            7'b0110011:     RegRead <= 2'b11;
            7'b0010011:     RegRead <= 2'b10;
            7'b0110111:     RegRead <= 2'b00; 
            7'b0010111:     RegRead <= 2'b00;
            7'b0000011:     RegRead <= 2'b10;
            7'b0100011:     RegRead <= 2'b11;
            7'b1100011:     RegRead <= 2'b11; 
            7'b1101111:     RegRead <= 2'b00; 
            7'b1100111:     RegRead <= 2'b10;              
        endcase
    end
    
    //BranchType
    always @(*) begin
        if (Op == 7'b1100011)begin
            case (Fn3)
                3'b000:     BranchType <= `BEQ;
                3'b001:     BranchType <= `BNE;
                3'b100:     BranchType <= `BLT;
                3'b101:     BranchType <= `BGE;
                3'b110:     BranchType <= `BLTU;
                3'b111:     BranchType <= `BGEU;
                default:    BranchType <= `NOBRANCH;                          
            endcase
        end
        else 
             BranchType <= `NOBRANCH;
    end
    
    //AluContrl
    always @(*) begin
        if ((Op == 7'b0010011) || (Op == 7'b0110011))begin
            case (Fn3)
                3'b000:     AluContrl <= ((Op == 7'b0110011) && (Fn7 == 7'b0100000)) ? `SUB : `ADD;
                3'b001:     AluContrl <= `SLL;
                3'b010:     AluContrl <= `SLT;
                3'b011:     AluContrl <= `SLTU;
                3'b100:     AluContrl <= `XOR;
                3'b101:     AluContrl <= (Fn7 == 7'b0100000) ? `SRA : `SRL;
                3'b110:     AluContrl <= `OR;
                3'b111:     AluContrl <= `AND;
                default:    AluContrl <= 4'hx;                          
            endcase
        end
        else if(Op == 7'b0110111)
            AluContrl <= `LUI;
        else
            AluContrl <= `ADD;
    end      
    
    //AluSrc1
    always@(*) begin
        case(Op)
            7'b0110011:     AluSrc1 <= 1'b0;
            7'b0010011:     AluSrc1 <= 1'b0;
            7'b0110111:     AluSrc1 <= 1'b0;
            7'b0010111:     AluSrc1 <= 1'b1;
            7'b0000011:     AluSrc1 <= 1'b0;
            7'b0100011:     AluSrc1 <= 1'b0;
            7'b1100011:     AluSrc1 <= 1'b0;
            7'b1101111:     AluSrc1 <= 1'b0;
            7'b1100111:     AluSrc1 <= 1'b0;
        endcase
    end    
    
    //AluSrc2
    always@(*) begin
        case(Op)
            7'b0110011:     AluSrc2 <= 2'b00;
            7'b0010011:     AluSrc2 <= (Fn3 == 3'b101 || Fn3 == 3'b001)? 2'b01 : 2'b10;
            7'b0110111:     AluSrc2 <= 2'b10;
            7'b0010111:     AluSrc2 <= 2'b10;
            7'b0000011:     AluSrc2 <= 2'b10;
            7'b0100011:     AluSrc2 <= 2'b10;
            7'b1100011:     AluSrc2 <= 2'b00;
            7'b1101111:     AluSrc2 <= 2'b00;
            7'b1100111:     AluSrc2 <= 2'b10;
        endcase
    end    
    
    //ImmType
    always @(*) begin
        case (Op)
            7'b0110011:     ImmType <= `RTYPE;
            7'b0010011:     ImmType <= `ITYPE;
            7'b0110111:     ImmType <= `UTYPE; 
            7'b0010111:     ImmType <= `UTYPE;
            7'b0000011:     ImmType <= `ITYPE;
            7'b0100011:     ImmType <= `STYPE;
            7'b1100011:     ImmType <= `BTYPE;
            7'b1101111:     ImmType <= `JTYPE;
            7'b1100111:     ImmType <= `ITYPE;             
        endcase
    end
    
    //Imm
    always @(*) begin
        case (Op)
            7'b0010011, 7'b1100111, 7'b0000011:     
                Imm <= {{21{In[31]}}, In[30:20]};
            7'b0110111, 7'b0010111:                 
                Imm <= {In[31:12], 12'b0}; 
            7'b0100011:                             
                Imm <= {{21{In[31]}}, In[30:25],In[11:7]};
            7'b1100011:                             
                Imm <= {{20{In[31]}},In[7], In[30:25],In[11:8],1'b0};
            7'b1101111:                             
                Imm <= { {12{In[31]}}, In[19:12], In[20], In[30:21], 1'b0}; 
            default: Imm <= 32'hxxxxxxxx;        
        endcase
    end
      
endmodule

//����˵��
    //ControlUnit       �Ǳ�CPU��ָ��������������߼���·
//����
    // Op               ��ָ��Ĳ����벿��
    // Fn3              ��ָ���func3����
    // Fn7              ��ָ���func7����
//���
    // Jal==1          ��ʾJalָ���ź�
    // Jalr==1         ��ʾJalrָ���ź�
    // RegWrite        ��ʾ �Ĵ���д��ģʽ ������ģʽ������Parameters.v��
    // MemToReg==1     ��ʾָ����Ҫ��data memory��ȡ��ֵд��Ĵ���,
    // MemWrite        ��4bit�����ö������ʽ������data memory��32bit�ְ�byte����д��,MemWrite=0001��ʾֻд�����1��byte����xilinx bram�Ľӿ�����
    // LoadNpc==1      ��ʾ��NextPC�����Result
    // RegRead[1]==1   ��ʾA1��Ӧ�ļĴ���ֵ��ʹ�õ��ˣ�RegRead[0]==1��ʾA2��Ӧ�ļĴ���ֵ��ʹ�õ���
    // BranchType      ��ʾ��ͬ�ķ�֧���ͣ��������Ͷ�����Parameters.v��
    // AluContrl       ��ʾ��ͬ��ALU���㹦�ܣ��������Ͷ�����Parameters.v��
    // AluSrc2         ��ʾAlu����Դ2��ѡ��
    // AluSrc1         ��ʾAlu����Դ1��ѡ��
    // ImmType          ��ʾָ�����������ʽ���������Ͷ�����Parameters.v��   
//ʵ��Ҫ��  
    //ʵ��ControlUnitģ��   