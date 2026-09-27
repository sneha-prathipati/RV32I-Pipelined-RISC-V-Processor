`timescale 1ns/1ps

module flush_counter(

input clk,
input rst,
input flush,

output reg [31:0] flush_count

);

always @(posedge clk)
begin
    if(rst)
        flush_count <= 0;
    else if(flush)
        flush_count <= flush_count + 1;
end

endmodule