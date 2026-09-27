`timescale 1ns / 1ps

module if_id(
    input wire clk,
    input wire rst,

    // Control
    input wire stall,
    input wire flush,

    // Inputs
    input wire [31:0] pc_in,
    input wire [31:0] pc4_in,
    input wire [31:0] instruction_in,

    // Outputs
    output reg [31:0] pc_out,
    output reg [31:0] pc4_out,
    output reg [31:0] instruction_out
);

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        pc_out <= 32'd0;
        pc4_out <= 32'd0;
        instruction_out <= 32'h00000013;
    end

    else if(flush)
    begin
        pc_out <= 32'd0;
        pc4_out <= 32'd0;
        instruction_out <= 32'h00000013;
    end

    else if(!stall)
    begin
        pc_out <= pc_in;
        pc4_out <= pc4_in;
        instruction_out <= instruction_in;
    end
end

endmodule