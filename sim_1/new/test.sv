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
logic signed [31:0] A;
logic signed [31:0] B;
logic signed [31:0] O;
logic done;
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
//start
initial begin
    start=0;
    #50
    start=1;
    #10
    start=0;
end
//WA,WB
initial begin
    WA=7;
    WB=5;
end
//A,B
initial begin
    A=14;
    B=-13;
end

BSM U(
.clk(clk),
.rst(rst),
.start(start),
.WA(WA),                    //width of data A
.WB(WB),                    //width of data B
.A(A),
.B(B),
.O(O),
.done(done)
);
endmodule
