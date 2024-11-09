`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2024 17:11:06
// Design Name: 
// Module Name: compuertas
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



module compuertas #(parameter WIDTH = 4)(a, b, bitwise_and, bitwise_or, bitwise_xor);

input [WIDTH-1:0] a, b;
output [WIDTH-1:0] bitwise_and;
output [WIDTH-1:0] bitwise_or;
output [WIDTH-1:0] bitwise_xor;

assign  bitwise_and = a & b;
assign  bitwise_or = a | b;
assign  bitwise_xor = a ^ b; 

endmodule
