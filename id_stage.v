`timescale 1ns / 1ps
`include "defines.v"

module id_stage(

    input  wire [31:0] instruction,
    input  wire [31:0] pc,
    input  wire [31:0] pc4,

    input  wire clk,
    input  wire rst,

    // Write Back Interface
    input  wire        reg_write,
    input  wire [4:0]  wb_rd,
    input  wire [31:0] wb_data,

    // Outputs to ID/EX
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data,
    output wire [31:0] immediate,

    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [4:0] rd,

    output wire [2:0] funct3,
    output wire [6:0] funct7,

    output wire [6:0] opcode,

    output wire Branch,
    output wire MemRead,
    output wire MemWrite,
    output wire MemtoReg,
    output wire ALUSrc,
    output wire RegWrite,

    output wire [1:0] ALUOp

);

/////////////////////////////////////////////////////////////
// Instruction Decode
/////////////////////////////////////////////////////////////

assign opcode = instruction[6:0];
assign rd      = instruction[11:7];
assign funct3  = instruction[14:12];
assign rs1     = instruction[19:15];
assign rs2     = instruction[24:20];
assign funct7  = instruction[31:25];

/////////////////////////////////////////////////////////////
// Register File
/////////////////////////////////////////////////////////////

register_file RF(

    .clk(clk),

    .reg_write(reg_write),

    .rs1(rs1),
    .rs2(rs2),

    .rd(wb_rd),

    .write_data(wb_data),

    .read_data1(rs1_data),
    .read_data2(rs2_data)

);

/////////////////////////////////////////////////////////////
// Immediate Generator
/////////////////////////////////////////////////////////////

immediate_generator IMM(

    .instruction(instruction),

    .immediate(immediate)

);

/////////////////////////////////////////////////////////////
// Main Control Unit
/////////////////////////////////////////////////////////////

control_unit CU(

    .opcode(opcode),

    .Branch(Branch),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp)

);

endmodule