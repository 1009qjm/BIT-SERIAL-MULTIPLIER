`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/24 12:35:29
// Design Name: 
// Module Name: BSM
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


module BSM(
input logic clk,
input logic rst,
input logic start,
input logic [4:0] WA,                    //width of data A
input logic [4:0] WB,                    //width of data B
input logic [31:0] A,
input logic [31:0] B,
output logic [31:0] O,
output logic done
);

logic sign;
logic sign_A;
logic sign_B;
logic signed [31:0] P;
logic [4:0] cnt_A;
logic [4:0] cnt_B;
logic [5:0] weight;
logic [31:0] weighted_abs_value;

assign weighted_abs_value=(A[cnt_A]&B[cnt_B])<<weight;  //乘积的绝对值
assign weight=cnt_A+cnt_B;                              //权重，移位的位数
assign sign_A=(cnt_A==WA-1)?A[WA-1]:0;                  //若是最高位，则取其作为符号位，否则为0，即为正
assign sign_B=(cnt_B==WB-1)?B[WB-1]:0;              
assign sign=sign_A^sign_B;                              //异或，同号为0，异号为1(负数)
//cnt_A
always_ff@(posedge clk)
if(start)
    cnt_A<=0;
else if(cnt_B==WB-1)
begin
    if(cnt_A==WA-1)
        cnt_A<=WA;
    else if(cnt_A<WA-1)
        cnt_A<=cnt_A+1; 
end
//cnt_B
always_ff@(posedge clk)
if(start)
    cnt_B<=0;
else if(cnt_B==WB-1)
    cnt_B<=0;
else
    cnt_B<=cnt_B+1;
//P
always_ff@(posedge clk)
if(start)
    P<=0;
else if(sign)
    P<=P-weighted_abs_value;        //相反数
else
    P<=P+weighted_abs_value;
//done
always_ff@(posedge clk,posedge rst)
if(rst)
    done<=0;
else if(cnt_A==WA-1&&cnt_B==WB-1)
    done<=1;
else
    done<=0;
//O
always_ff@(posedge clk)
if(done)
    O<=P;
endmodule
