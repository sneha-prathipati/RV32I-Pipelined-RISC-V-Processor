`timescale 1ns/1ps

module cpi_monitor(

    input clk,
    input rst,

    input [31:0] cycle_count,
    input [31:0] instruction_count,

    output reg [31:0] cpi

);

always @(posedge clk)
begin

    if(rst)
        cpi <= 0;
    else if(instruction_count != 0)
        cpi <= cycle_count / instruction_count;
    else
        cpi <= 0;

end

endmodule