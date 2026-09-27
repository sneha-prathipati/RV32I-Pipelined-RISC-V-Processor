`timescale 1ns / 1ps
`include "defines.v"

module ex_stage(

    input  wire [31:0] pc,
    input  wire [31:0] rs1_data,
    input  wire [31:0] rs2_data,
    input  wire [31:0] immediate,

    input  wire [4:0]  rd,

    input  wire [2:0]  funct3,
    input  wire [6:0]  funct7,

    input  wire Branch,
    input  wire ALUSrc,
    input  wire [1:0] ALUOp,
// Forwarding Control
input wire [1:0] ForwardA,
input wire [1:0] ForwardB,

// Forwarded Values
input wire [31:0] ex_mem_data,
input wire [31:0] mem_wb_data,
    // Outputs
    output wire [31:0] alu_result,
    output wire [31:0] write_data,
    output wire [31:0] branch_target,
    output wire        branch_taken,
    output wire [4:0]  rd_out

);

//////////////////////////////////////////////////////
// ALU Control
//////////////////////////////////////////////////////

wire [3:0] alu_ctrl;

alu_control ALUCTRL(

    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7(funct7[5]),
   .ALUControl(alu_ctrl)

);

//////////////////////////////////////////////////////
// ALU Operand Selection
//////////////////////////////////////////////////////

wire [31:0] srcA;
wire [31:0] srcB;
wire [31:0] operand_B;

assign srcA =
    (ForwardA == 2'b10) ? ex_mem_data :
    (ForwardA == 2'b01) ? mem_wb_data :
                          rs1_data;

assign srcB =
    (ForwardB == 2'b10) ? ex_mem_data :
    (ForwardB == 2'b01) ? mem_wb_data :
                          rs2_data;

assign operand_B = ALUSrc ? immediate : srcB;
//////////////////////////////////////////////////////
// ALU
//////////////////////////////////////////////////////

wire zero;

alu ALU(

  .A(srcA),
    .B(operand_B),
    .ALUControl(alu_ctrl),
    .Result(alu_result),
    .Zero(zero)

);
//////////////////////////////////////////////////////
// Branch Address
//////////////////////////////////////////////////////

assign branch_target = pc + immediate;

//////////////////////////////////////////////////////
// Branch Decision
//////////////////////////////////////////////////////

reg branch_cond;

always @(*)
begin

    case(funct3)

        3'b000: branch_cond = zero;                        // BEQ
        3'b001: branch_cond = ~zero;                       // BNE

        3'b100: branch_cond = ($signed(srcA) < $signed(srcB)); // BLT
        3'b101: branch_cond = ($signed(srcA) >= $signed(srcB)); // BGE

        3'b110: branch_cond = (srcA < srcB);               // BLTU
        3'b111: branch_cond = (srcA >= srcB);              // BGEU

        default: branch_cond = 1'b0;

    endcase

end

assign branch_taken = Branch & branch_cond;

//////////////////////////////////////////////////////
// Store Data
//////////////////////////////////////////////////////

assign write_data = srcB;

//////////////////////////////////////////////////////
// Destination Register
//////////////////////////////////////////////////////

assign rd_out = rd;

endmodule