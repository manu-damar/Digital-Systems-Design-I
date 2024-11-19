`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution: CINVESTAV Guadalajara Unit 
// Engineer: Emmanuel Díaz Marín 
// 
// Create Date: 13.11.2024 16:18:33
// Design Name: 
// Module Name: adderWithCarryOut
// Project Name: Assertion planning 
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


module adderWithCarryOut #(parameter WIDTH = 4)(
    input [WIDTH-1: 0] a,
    input [WIDTH-1: 0] b,
    output [WIDTH-1: 0] result,
    output carryOut
);

assign {carryOut, result} = result[2]==0 ? a+b+7 : a+b;

endmodule
