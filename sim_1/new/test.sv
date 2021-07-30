`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/24 13:10:28
// Design Name: 
// Module Name: test
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


module test;

logic clk;
logic rst;
logic start;
logic [4:0] WA;
logic [4:0] WB;
logic bitAin;
logic bitBin;
logic signed [31:0] O;
logic done;
logic signed [31:0] A;
logic signed [31:0] B;
logic [31:0] bitcount;
//clk
initial begin
    clk=0;
    forever begin
        #5 clk=~clk;
    end
end
//rst
initial begin
    rst=1;
    #20
    rst=0;
end
//stat
always_ff@(posedge clk,posedge rst)
if(rst||done)
    start<=1;
else
    start<=0;
//WA,WB
initial begin
    WA=8;
    WB=15;
end
//A,B
always_ff@(posedge clk,posedge rst)
if(rst)
begin
    A = $random % (1<<(WA-1)-1);
    B = $random % (1<<(WB-1)-1);
end
else if(done)
begin
    A = $random % (1<<(WA-1)-1);
    B = $random % (1<<(WB-1)-1);
end
//
// initial begin
//     A=15;
//     B=-7;
// end
//bitAin
always_comb
    bitAin<=A[bitcount];
//bitBin
always_comb
    bitBin<=B[bitcount];
//bitcount
always_ff@(posedge clk,posedge rst)
if(rst)
    bitcount<=0;
else if(start)
    bitcount<=0;
else
    bitcount<=bitcount+1;
always_ff@(negedge clk)
if(done)
begin
    $display("A=%d,B=%d,A*B=%d,O=%d",A,B,A*B,O);
    if(A*B!=O)
    begin
        $display("test error!");
        $stop;
    end
end
//inst
BSM U(
.clk(clk),
.rst(rst),
.start(start),
.WA(WA),                    //width of data A
.WB(WB),                    //width of data B
.bitAin(bitAin),
.bitBin(bitBin),
.O(O),
.done(done)
);
endmodule
