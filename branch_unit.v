`timescale 1ns / 1ps

module branch_unit(

input [31:0] A,
input [31:0] B,

output take_branch

);

assign take_branch = (A==B);

endmodule