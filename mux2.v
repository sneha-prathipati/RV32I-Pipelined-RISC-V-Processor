`timescale 1ns / 1ps

module mux2#

(
parameter WIDTH=32
)

(

input [WIDTH-1:0] A,
input [WIDTH-1:0] B,

input sel,

output [WIDTH-1:0] Y

);

assign Y = sel ? B : A;

endmodule