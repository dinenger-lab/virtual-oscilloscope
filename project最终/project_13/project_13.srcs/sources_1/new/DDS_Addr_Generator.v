`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/27 20:09:28
// Design Name: 
// Module Name: DDS_Addr_Generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DDS_Addr_Generator(
    input clk_DDS,              //ϵͳʱ��
    input Rst,                  //�͵�ƽ��λ
    input [13:0]Freq,           //Ƶ��
    input [8:0]Phase,           //��λ
    output [7:0]Addr_Out        //�����ַ����ӦROM�е�����
    );
    parameter NWORD=256;                 //Դ���ݲ�������
    wire clk_out;                         //ʱ��        
    reg [7:0]Addr_Cnt=0;                  //��ַ����    
    wire [7:0]PWORD = (Phase*NWORD)/360;  //��λ������ (x/360)*256
    wire [30:0]FWORD = 100000000/(Freq*NWORD);//Ƶ�ʿ�����
    //��Ƶ��
    Clk_Division_0 Clk_Division_01 (
      .clk_100MHz(clk_DDS),  // input wire clk_100MHz
      .clk_mode(FWORD),      // input wire [30 : 0] clk_mode
      .clk_out(clk_out)      // output wire clk_out
    );
    //����
    always @ (posedge clk_out or negedge Rst)
        begin
            if (!Rst)
                Addr_Cnt <= 0;  
            else
                Addr_Cnt <= Addr_Cnt + 1;   
        end 
    //���ۼ����ĵ�ַ�ĸ߰�λ��ֵ������ĵ�ַ��ROM�ĵ�ַ
    assign Addr_Out = Addr_Cnt + PWORD;
endmodule
