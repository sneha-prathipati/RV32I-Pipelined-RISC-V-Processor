`timescale 1ns / 1ps
`include "defines.v"
module control_unit(

input [6:0] opcode,

output reg Branch,
output reg MemRead,
output reg MemtoReg,
output reg [1:0] ALUOp,
output reg MemWrite,
output reg ALUSrc,
output reg RegWrite

);

always @(*)
begin

Branch   = 0;
MemRead  = 0;
MemtoReg = 0;
ALUOp    = 2'b00;
MemWrite = 0;
ALUSrc   = 0;
RegWrite = 0;

case(opcode)

7'b0110011: begin
    RegWrite = 1;
    ALUOp    = 2'b10;
end

7'b0010011: begin
    RegWrite = 1;
    ALUSrc   = 1;
    ALUOp    = 2'b00;
end

7'b0000011: begin
    RegWrite = 1;
    ALUSrc   = 1;
    MemRead  = 1;
    MemtoReg = 1;
end

7'b0100011: begin
    ALUSrc   = 1;
    MemWrite = 1;
end

7'b1100011: begin
    Branch = 1;
    ALUOp  = 2'b01;
end

// JAL
7'b1101111: begin
    RegWrite = 1;
    ALUSrc   = 1;
end

// JALR
7'b1100111: begin
    RegWrite = 1;
    ALUSrc   = 1;
end

// LUI
7'b0110111: begin
    RegWrite = 1;
    ALUSrc   = 1;
end

// AUIPC
7'b0010111: begin
    RegWrite = 1;
    ALUSrc   = 1;
end

default: begin
    // Outputs already initialized above
end

endcase

end

endmodule