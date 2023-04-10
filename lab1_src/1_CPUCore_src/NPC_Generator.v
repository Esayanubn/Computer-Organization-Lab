`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: NPC_Generator
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Choose Next PC value
//////////////////////////////////////////////////////////////////////////////////
module NPC_Generator(
    input wire [31:0] JalrTarget, BranchTarget, JalTarget,
    input wire Branch,Jal,Jalr,
    input clk,rst,
    output reg [31:0] PC
    );
    
    initial begin
        PC = 32'b0;
    end
    
    wire [31:0] next_PC;
    assign  next_PC =  (Branch == 1'b1)?(BranchTarget):
                       ((Jalr == 1'b1)?(JalrTarget):
                       ((Jal == 1'b1)?(JalTarget):
                       (PC + 32'd4)));

    always@ (posedge clk) begin
        if (rst) begin
            PC <= 0;
        end 
        else begin
            PC <= next_PC;
        end
    end
    
endmodule

//����˵��
    //NPC_Generator����������Next PCֵ��ģ�飬���ݲ�ͬ����ת�ź�ѡ��ͬ����PCֵ
//����
    //PCF               �ɵ�PCֵ
    //JalrTarget        jalrָ��Ķ�Ӧ����תĿ��
    //BranchTarget      branchָ��Ķ�Ӧ����תĿ��
    //JalTarget         jalָ��Ķ�Ӧ����תĿ��
    //Branch==1         Branchָ��ȷ����ת
    //Jal==1            Jalָ��ȷ����ת
    //Jalr==1           Jalrָ��ȷ����ת
//���
    //PC                NPC��ֵ
//ʵ��Ҫ��  
    //ʵ��NPC_Generatorģ��  
