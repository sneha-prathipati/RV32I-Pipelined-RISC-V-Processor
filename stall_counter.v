`timescale 1ns/1ps

module stall_counter(

    input clk,
    input rst,

    input stall,

    output reg [31:0] stall_count

);

always @(posedge clk)
begin

    if(rst)
        stall_count <= 0;
    else if(stall)
        stall_count <= stall_count + 1;

end

endmodule