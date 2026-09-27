`timescale 1ns / 1ps

module wb_stage(

    input  wire        MemtoReg,
    input  wire [31:0] read_data,
    input  wire [31:0] alu_result,

    output wire [31:0] wb_data

);

//////////////////////////////////////////////////////
// Write Back MUX
//////////////////////////////////////////////////////

assign wb_data = (MemtoReg) ? read_data : alu_result;

endmodule