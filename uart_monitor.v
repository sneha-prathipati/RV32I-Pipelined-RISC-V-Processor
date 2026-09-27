`timescale 1ns/1ps

module uart_monitor(

input clk,
input rst,

input [31:0] cycle_count,
input [31:0] instruction_count,
input [31:0] stall_count,
input [31:0] cpi,

output reg tx

);

always @(posedge clk)
begin
    if(rst)
        tx <= 1'b1;
    else
        tx <= cycle_count[0] ^
              instruction_count[0] ^
              stall_count[0] ^
              cpi[0];
end

endmodule