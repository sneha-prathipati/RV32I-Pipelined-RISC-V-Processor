`timescale 1ns / 1ps

module mem_wb(

    input clk,
    input rst,

    // Control Signals
    input MemtoReg_in,
    input RegWrite_in,

    // Data
    input [31:0] read_data_in,
    input [31:0] alu_result_in,
    input [4:0] rd_in,

    // Outputs
    output reg MemtoReg_out,
    output reg RegWrite_out,

    output reg [31:0] read_data_out,
    output reg [31:0] alu_result_out,

    output reg [4:0] rd_out

);

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        MemtoReg_out  <= 1'b0;
        RegWrite_out  <= 1'b0;

        read_data_out <= 32'd0;
        alu_result_out<= 32'd0;

        rd_out         <= 5'd0;

    end
    else
    begin

        MemtoReg_out  <= MemtoReg_in;
        RegWrite_out  <= RegWrite_in;

        read_data_out <= read_data_in;
        alu_result_out<= alu_result_in;

        rd_out         <= rd_in;

    end

end

endmodule