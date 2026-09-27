`timescale 1ns/1ps

module cache_monitor(

    input clk,
    input rst,

    input i_hit,
    input d_hit,

    output reg [31:0] i_hits,
    output reg [31:0] i_misses,

    output reg [31:0] d_hits,
    output reg [31:0] d_misses

);

always @(posedge clk)
begin

    if(rst)
    begin
        i_hits   <= 0;
        i_misses <= 0;
        d_hits   <= 0;
        d_misses <= 0;
    end
    else
    begin

        if(i_hit)
            i_hits <= i_hits + 1;
        else
            i_misses <= i_misses + 1;

        if(d_hit)
            d_hits <= d_hits + 1;
        else
            d_misses <= d_misses + 1;

    end

end

endmodule