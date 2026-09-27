`timescale 1ns/1ps

module uart_debug(

    input clk,
    input rst,

    input [31:0] pc,
    input [31:0] instruction,
    input [31:0] alu_result,

    output reg tx

);

always @(posedge clk)
begin

    if(rst)
        tx <= 1'b1;
    else
        tx <= pc[0] ^ instruction[0] ^ alu_result[0];

end

endmodule