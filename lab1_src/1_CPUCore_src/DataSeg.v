`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: DataSeg
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
//////////////////////////////////////////////////////////////////////////////////
module DataSeg(
    input wire clk,
    //Data Memory Access
    input wire [31:0] A,
    input wire [31:0] WD,
    input wire [3:0] WE,
    output wire [31:0] RD,
    //Data Memory Debug
    input wire [31:0] A2,
    input wire [31:0] WD2,
    input wire [3:0] WE2,
    output wire [31:0] RD2
    );

    wire [31:0] RD_raw;
    DataRam DataRamInst (
        .clk    (),                      //�벹ȫ
        .wea    (),                      //�벹ȫ  ������LoadedBytesSelect����ʱ�⻹����һ�������صĵ�ַ��ĩ2λ
        .addra  (),                      //�벹ȫ
        .dina   (),                      //�벹ȫ
        .douta  ( RD_raw         ),
        .web    ( WE2            ),
        .addrb  ( A2[31:2]       ),
        .dinb   ( WD2            ),
        .doutb  ( RD2            )
    );   

    assign RD = RD_raw;

endmodule

//����˵��
    //DataSegͬʱ������һ��ͬ����д��Bram
    //���˴�����Ե��������ṩ��DataRam���������Զ��ۺ�Ϊblock memory����Ҳ��������Եĵ���xilinx��bram ip�ˣ���

//ʵ��Ҫ��  
    //����Ҫ��ȫ�Ϸ����룬�貹ȫ��Ƭ�ν�ȡ����
    //DataRam DataRamInst (
    //    .clk    (???),                      //�벹ȫ
    //    .wea    (???),                      //�벹ȫ
    //    .addra  (???),                      //�벹ȫ
    //    .dina   (???),                      //�벹ȫ
    //    .douta  ( RD_raw         ),
    //    .web    ( WE2            ),
    //    .addrb  ( A2[31:2]       ),
    //    .dinb   ( WD2            ),
    //    .doutb  ( RD2            )
    //);   
//ע������
    //���뵽DataRam��addra���ֵ�ַ��һ����32bit
    //�����DataExtģ��ʵ�ַ��ֶ����ֽ�load
    //��ͨ����ȫ����ʵ�ַ��ֶ���store

