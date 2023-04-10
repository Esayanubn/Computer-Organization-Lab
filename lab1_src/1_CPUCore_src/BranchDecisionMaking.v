`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: BranchDecisionMaking
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Decide whether to branch 
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
module BranchDecisionMaking(
    input wire [2:0] BranchType,
    input wire [31:0] Operand1,Operand2,
    output reg Branch
    );
    
    initial begin
        Branch = 1'b0;
    end
    
    always @(*) begin
        case (BranchType)
            `BEQ:       Branch <= ((Operand1 == Operand2) ? 1'b1 : 1'b0); 
            `BNE:       Branch <= ((Operand1 != Operand2) ? 1'b1 : 1'b0);  
            `BLT:       Branch <= (($signed(Operand1) < $signed(Operand2)) ? 1'b1 : 1'b0);
            `BLTU:      Branch <= ((Operand1 < Operand2) ? 1'b1 : 1'b0); 
            `BGE:       Branch <= (($signed(Operand1) >= $signed(Operand2)) ? 1'b1 : 1'b0);
            `BLTU:      Branch <= ((Operand1 >= Operand2) ? 1'b1 : 1'b0); 
            default:    Branch <= 1'b0;      //NOBRANCH                    
        endcase
    end
endmodule


//���ܺͽӿ�˵��
    //BranchDecisionMaking��������������������BranchType�Ĳ�ͬ�����в�ͬ���жϣ�����֧Ӧ��takenʱ����Branch=1'b1
    //BranchTypeE�����Ͷ�����Parameters.v��
//�Ƽ���ʽ��
    //case()
    //    `BEQ: ???
    //      .......
    //    default:                            Branch<=1'b0;  //NOBRANCH
    //endcase
//ʵ��Ҫ��  
    //ʵ��BranchDecisionMakingģ��