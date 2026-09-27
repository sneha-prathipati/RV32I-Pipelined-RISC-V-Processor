`timescale 1ns / 1ps

module mem_stage(

    input wire clk,

    // Control
    input wire MemRead,
    input wire MemWrite,

    // Inputs
    input wire [31:0] alu_result,
    input wire [31:0] write_data,

    // Outputs
    output wire [31:0] read_data,
    output wire [31:0] alu_result_out,
output wire cache_hit

);

//////////////////////////////////////////////////////
// Data Memory
//////////////////////////////////////////////////////
data_cache DCACHE(

    .clk(clk),

    .MemRead(MemRead),
    .MemWrite(MemWrite),

    .address(alu_result),

    .write_data(write_data),

    .read_data(read_data),

    .hit(cache_hit)

);
//////////////////////////////////////////////////////
// Pass ALU Result
//////////////////////////////////////////////////////

assign alu_result_out = alu_result;

endmodule