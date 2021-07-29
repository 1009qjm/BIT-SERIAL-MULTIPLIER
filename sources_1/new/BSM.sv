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
input logic bitAin,
input logic bitBin,
output logic signed [31:0] O,
output logic done
);

logic [31:0] Acur;                             //已经读入的bitcount比特所组成的数据     
logic [31:0] Bcur;                             //已经读入的bitcount比特所组成的数据
logic [31:0] Rcur;                             //当前乘积结果
logic [4:0] bitcount;                          //已经读入的比特数
logic bitA;                                    //读入的bitA
logic bitB;                                    //读入的bitB
logic bitand;                                  //bitA & bitB
logic signA;                                   //当前读入的比特位是否是符号位以及其符号
logic signB;
logic [31:0]tmp1;                          
logic [31:0]tmp2;
logic [31:0]tmp3; 
logic [4:0] maxW;                              //数据A和数据B宽度的较大值

assign maxW=(WA>WB)?WA:WB;
assign bitA=((bitcount)>WA-1)?Acur[WA-1]:bitAin;
assign bitB=((bitcount)>WB-1)?Bcur[WB-1]:bitBin;
assign signA=((bitcount)==maxW-1)?bitA:1'b0;
assign signB=((bitcount)==maxW-1)?bitB:1'b0;
assign bitand=bitA & bitB;
//tmp1=(bitA & bitB)*(signA ^ signB)*(1<<(bitcount+bitcount))
always_comb
begin
if(bitand==1'b1)
    if(signA^signB==1'b1)              //为负
        tmp1=-1<<(bitcount+bitcount);
    else
        tmp1= 1<<(bitcount+bitcount);
else
    tmp1=32'd0;
end
//tmp2=bitA * Bcur * signA * (1<<bitcount)
always_comb
begin
if(bitA==1'b1)
    if(signA==1'b1)
        tmp2=-Bcur<<bitcount;
    else
        tmp2=Bcur<<bitcount;
else
    tmp2=0;
end
//tmp3=bitB(1,0) * signB(+,-) * Acur * (1<<bitcount)
always_comb
begin
if(bitB==1'b1)
    if(signB==1'b1)
        tmp3=-Acur<<bitcount;
    else
        tmp3=Acur<<bitcount;
else
    tmp3=0;
end
//Rcur
always_ff@(posedge clk)
if(start)
    Rcur<=0;
else 
    Rcur<=Rcur+tmp1+tmp2+tmp3;
//Acur
always_ff@(posedge clk)
if(start)
    Acur<=0;
else 
    Acur[bitcount]<=bitA;
//Bcur
always_ff@(posedge clk)
if(start)
    Bcur<=0;
else 
    Bcur[bitcount]<=bitB;
//bitcount
always_ff@(posedge clk)
if(start)
    bitcount<=0;
else if(bitcount<maxW)
    bitcount<=bitcount+1;
//done
always_ff@(posedge clk,posedge rst)
if(rst)
    done<=0;
else if(bitcount==maxW-1)
    done<=1;
else
    done<=0;
//
assign O=(done==1'b1)?Rcur:0;
endmodule
