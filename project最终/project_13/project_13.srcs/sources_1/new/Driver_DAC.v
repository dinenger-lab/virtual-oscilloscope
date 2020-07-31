`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/27 20:08:38
// Design Name: 
// Module Name: Driver_DAC
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


module Driver_DAC( 
    input clk_100MHz, 
    input clk_DAC, 
    input DAC_En, 
    input [1:0]Wave_Mode, 
    input [8:0]Phase, 
    output reg DAC_Din, 
    output reg DAC_Sync 
    ); 
    //8 λ��ַ����Ӧ�� ROM �ڵ�����     
    wire [7:0]Addr_Out; 
    wire [7:0]Addr_Out_Sin=(Wave_Mode==1)?Addr_Out:0; 
    wire [7:0]Addr_Out_Triangle=(Wave_Mode==2)?Addr_Out:0; 
    wire [7:0]Addr_Out_Square=(Wave_Mode==3)?Addr_Out:0; 
    //ROM �� DAC ������� 
    wire [7:0]DAC_Data_Sin; 
    wire [7:0]DAC_Data_Triangle; 
    wire [7:0]DAC_Data_Square; 
    //DAC ���� 
 
    reg [7:0]DAC_Data=0; 
    //DAC ����״̬������ 
    reg [4:0] DAC_Cnt = 5'd0; 
    // 
    //ʱ���߼� 
    always@(*) 
        begin 
            case(Wave_Mode) 
                1:DAC_Data=DAC_Data_Sin; 
                2:DAC_Data=DAC_Data_Triangle; 
                3:DAC_Data=DAC_Data_Square; 
                default:DAC_Data=DAC_Data_Sin; 
            endcase 
        end 
         
    //DAC ״̬������ִ�� 
    always@(posedge clk_DAC) 
        begin 
            if(DAC_Cnt == 16) 
                DAC_Cnt <= 5'd0; 
            else 
                DAC_Cnt <= DAC_Cnt + 5'd1; 
            case(DAC_Cnt) 
                5'd0: DAC_Din <= 1'b0; 
                5'd1: DAC_Din <= DAC_Data[7]; 
                5'd2: DAC_Din <= DAC_Data[6]; 
                5'd3: DAC_Din <= DAC_Data[5]; 
                5'd4: DAC_Din <= DAC_Data[4]; 
                5'd5: DAC_Din <= DAC_Data[3]; 
                5'd6: DAC_Din <= DAC_Data[2]; 
                5'd7: DAC_Din <= DAC_Data[1]; 
                5'd8: DAC_Din <= DAC_Data[0]; 
                5'd9: DAC_Din <= 1'b0; 
                5'd10: DAC_Din <= 1'b0; 
                5'd11: DAC_Din <= 1'b0; 
                5'd12: DAC_Din <= 1'b0; 
                5'd13: DAC_Din <= 1'b0; 
                5'd14: DAC_Din <= 1'b0; 
                5'd15: begin 
                        DAC_Din <= 1'b0; 
                        DAC_Sync <= 1'b1; 
                       end 
                5'd16: begin  
                        DAC_Din <= 1'b0; 
 
                        DAC_Sync <= 1'b0; 
                       end 
            endcase     
        end 
    //��λ�ۼ���ģ�� 
           DDS_Addr_Generator DDS_Addr_Generator (         
               .clk_DDS(clk_100MHz),        
               .Rst(DAC_En),
               .Freq(1000),        
               .Phase(Phase),
               .Addr_Out(Addr_Out)
            );     
            //���Ҳ���������ģ��        
          Rom_Sin Sin_Rom(       
               .clka(clk_DAC),                 // input wire clka        
               .ena(DAC_En&(Wave_Mode==1)),    // input wire ena
               .addra(Addr_Out_Sin),           // input wire [7 : 0] addra        
               .douta(DAC_Data_Sin)            // output wire [7 : 0] douta     
           );
           //��������ģ��        
           Rom_Square Square_Rom(       
               .clka(clk_DAC),                 // input wire clka        
               .ena(DAC_En&(Wave_Mode==3)),    // input wire ena
               .addra(Addr_Out_Square),        // input wire [7 : 0] addra        
               .douta(DAC_Data_Square)         // output wire [7 : 0] douta     
           );
           //��������ģ��        
          Rom_Triangle Triangle_Rom(       
               .clka(clk_DAC),                 // input wire clka        
               .ena(DAC_En&(Wave_Mode==2)),    // input wire ena
               .addra(Addr_Out_Triangle),      // input wire [7 : 0] addra        
               .douta(DAC_Data_Triangle)       // output wire [7 : 0] douta     
           );
       endmodule
