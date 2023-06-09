`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: 
// Module Name: DataExt 
// Target Devices: 
// Tool Versions: 
// Description: 
//////////////////////////////////////////////////////////////////////////////////

`include "Parameters.v"   
module DataExt(
    input wire [31:0] IN,
    input wire [1:0] LoadedBytesSelect,
    input wire [2:0] RegWrite,
    output reg [31:0] OUT
    );
    
    wire [31:0] tar_byte;
    //?
    assign tar_byte = IN >> (LoadedBytesSelect * 8);
    always @(*) begin
        case (RegWrite)
           `LB:     OUT <= {{24{tar_byte[7]}}, tar_byte[7:0]};
           `LH:     OUT <= {{16{tar_byte[15]}}, tar_byte[15:0]};
           `LW:     OUT <= IN;
           `LBU:    OUT <= {24'b0, tar_byte[7:0]};
           `LHU:    OUT <= {16'b0, tar_byte[15:0]};
           default: OUT <= 32'b0;                          
        endcase
    end
    
    
endmodule

//功能说明
    //DataExt是用来处理非字对齐load的情形，同时根据load的不同模式对Data Mem中load的数进行符号或者无符号拓展，组合逻辑电路
//输入
    //IN                    是从Data Memory中load的32bit字
    //LoadedBytesSelect     等价于AluOutM[1:0]，是读Data Memory地址的低两位，
                            //因为DataMemory是按字（32bit）进行访问的，所以需要把字节地址转化为字地址传给DataMem
                            //DataMem一次返回一个字，低两位地址用来从32bit字中挑选出我们需要的字节
    //RegWriteW             表示不同的 寄存器写入模式 ，所有模式定义在Parameters.v中
//输出
    //OUT表示要写入寄存器的最终值
//实验要求  
    //实现DataExt模块   