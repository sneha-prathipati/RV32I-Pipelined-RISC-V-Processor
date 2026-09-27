`timescale 1ns / 1ps

module ex_mem(
    input clk,
    input rst,

    input MemRead_in,
    input MemWrite_in,
    input MemtoReg_in,
    input RegWrite_in,
    input Branch_in,

    input [31:0] alu_result_in,
    input [31:0] write_data_in,
    input [31:0] branch_target_in,
    input branch_taken_in,
    input [4:0] rd_in,

    output reg MemRead_out,
    output reg MemWrite_out,
    output reg MemtoReg_out,
    output reg RegWrite_out,
    output reg Branch_out,

    output reg [31:0] alu_result_out,
    output reg [31:0] write_data_out,
    output reg [31:0] branch_target_out,
    output reg branch_taken_out,
    output reg [4:0] rd_out
);

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        MemRead_out       <= 1'b0;
        MemWrite_out      <= 1'b0;
        MemtoReg_out      <= 1'b0;
        RegWrite_out      <= 1'b0;
        Branch_out        <= 1'b0;

        alu_result_out    <= 32'd0;
        write_data_out    <= 32'd0;
        branch_target_out <= 32'd0;
        branch_taken_out  <= 1'b0;
        rd_out            <= 5'd0;
    end
    else
    begin
        MemRead_out       <= MemRead_in;
        MemWrite_out      <= MemWrite_in;
        MemtoReg_out      <= MemtoReg_in;
        RegWrite_out      <= RegWrite_in;
        Branch_out        <= Branch_in;

        alu_result_out    <= alu_result_in;
        write_data_out    <= write_data_in;
        branch_target_out <= branch_target_in;
        branch_taken_out  <= branch_taken_in;
        rd_out            <= rd_in;
    end
end

endmodule