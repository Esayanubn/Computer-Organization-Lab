`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: InstrSeg
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
//////////////////////////////////////////////////////////////////////////////////
module InstrSeg(
    input wire clk,
    //Instrution Memory Access
    input wire [31:0] A,
    output wire [31:0] RD,
    //Instruction Memory Debug
    input wire [31:0] A2,
    input wire [31:0] WD2,
    input wire [3:0] WE2,
    output wire [31:0] RD2
    //
    );  
    
    wire [31:0] RD_raw;
    InstructionRam InstructionRamInst (
         .clk    ( clk        ),                        //�벹ȫ
         .addra  ( A[31:2]   ),                      //�벹ȫ
         .douta  ( RD_raw     ),
         .web    ( |WE2       ),
         .addrb  ( A2[31:2]   ),
         .dinb   ( WD2        ),
         .doutb  ( RD2        )
     );
    // Add clear and stall support
    // if chip not enabled, output output last read result
    // else if chip clear, output 0
    // else output values from bram
  
    assign RD =  RD_raw;

endmodule


//����˵��
    //InstrSegSegͬʱ������һ��ͬ����д��Bram���˴�����Ե��������ṩ��InstructionRam��
    //�������Զ��ۺ�Ϊblock memory����Ҳ��������Եĵ���xilinx��bram ip�ˣ���

//ʵ��Ҫ��  
    //����Ҫ��ȫ�Ϸ����룬�貹ȫ��Ƭ�ν�ȡ����
    //InstructionRam InstructionRamInst (
    //     .clk    (),                        //�벹ȫ
    //     .addra  (),                        //�벹ȫ
    //     .douta  ( RD_raw     ),
    //     .web    ( |WE2       ),
    //     .addrb  ( A2[31:2]   ),
    //     .dinb   ( WD2        ),
    //     .doutb  ( RD2        )
    // );
//ע������
    //���뵽InstructionRam��addra���ֵ�ַ��һ����32bit