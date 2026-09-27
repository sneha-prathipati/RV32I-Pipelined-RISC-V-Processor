`timescale 1ns / 1ps

module id_ex(

    input clk,
    input rst,
    input flush,

    // Control Signals
    input Branch_in,
    input MemRead_in,
    input MemWrite_in,
    input MemtoReg_in,
    input ALUSrc_in,
    input RegWrite_in,
    input [1:0] ALUOp_in,

    // Data
    input [31:0] pc_in,
    input [31:0] pc4_in,
    input [31:0] rs1_data_in,
    input [31:0] rs2_data_in,
    input [31:0] immediate_in,

    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [4:0] rd_in,

    input [2:0] funct3_in,
    input [6:0] funct7_in,

    // Outputs
    output reg Branch_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg MemtoReg_out,
    output reg ALUSrc_out,
    output reg RegWrite_out,
    output reg [1:0] ALUOp_out,

    output reg [31:0] pc_out,
    output reg [31:0] pc4_out,
    output reg [31:0] rs1_data_out,
    output reg [31:0] rs2_data_out,
    output reg [31:0] immediate_out,

    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,

    output reg [2:0] funct3_out,
    output reg [6:0] funct7_out

);

always @(posedge clk or posedge rst)
begin

    if(rst || flush)
    begin
        Branch_out     <= 0;
        MemRead_out    <= 0;
        MemWrite_out   <= 0;
        MemtoReg_out   <= 0;
        ALUSrc_out     <= 0;
        RegWrite_out   <= 0;
        ALUOp_out      <= 2'b00;

        pc_out         <= 32'd0;
        pc4_out        <= 32'd0;
        rs1_data_out   <= 32'd0;
        rs2_data_out   <= 32'd0;
        immediate_out  <= 32'd0;

        rs1_out        <= 5'd0;
        rs2_out        <= 5'd0;
        rd_out         <= 5'd0;

        funct3_out     <= 3'd0;
        funct7_out     <= 7'd0;
    end
    else
    begin
        Branch_out     <= Branch_in;
        MemRead_out    <= MemRead_in;
        MemWrite_out   <= MemWrite_in;
        MemtoReg_out   <= MemtoReg_in;
        ALUSrc_out     <= ALUSrc_in;
        RegWrite_out   <= RegWrite_in;
        ALUOp_out      <= ALUOp_in;

        pc_out         <= pc_in;
        pc4_out        <= pc4_in;
        rs1_data_out   <= rs1_data_in;
        rs2_data_out   <= rs2_data_in;
        immediate_out  <= immediate_in;

        rs1_out        <= rs1_in;
        rs2_out        <= rs2_in;
        rd_out         <= rd_in;

        funct3_out     <= funct3_in;
        funct7_out     <= funct7_in;
    end

end

endmodule