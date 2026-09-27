`timescale 1ns / 1ps
`include "defines.v"
module alu(

    input wire [31:0] A,
    input wire [31:0] B,

    input wire [3:0] ALUControl,

    output reg [31:0] Result,
    output wire Zero

);

always @(*)
begin

case(ALUControl)

4'b0000: Result = A + B;                           // ADD
4'b0001: Result = A - B;                           // SUB
4'b0010: Result = A & B;                           // AND
4'b0011: Result = A | B;                           // OR
4'b0100: Result = A ^ B;                           // XOR

4'b0101: Result = A << B[4:0];                     // SLL
4'b0110: Result = A >> B[4:0];                     // SRL
4'b0111: Result = $signed(A) >>> B[4:0];           // SRA

4'b1000: Result = ($signed(A) < $signed(B));       // SLT
4'b1001: Result = (A < B);                         // SLTU

default: Result = 32'd0;

endcase

end

assign Zero = (Result==0);

endmodule