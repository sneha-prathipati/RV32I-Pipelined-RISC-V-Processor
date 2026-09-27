`timescale 1ns/1ps

module cache_controller(

    input clk,
    input rst,

    input i_cache_hit,
    input d_cache_hit,

    input MemRead,
    input MemWrite,

    output reg stall_pipeline

);

always @(posedge clk)
begin

    if(rst)
        stall_pipeline <= 1'b0;

    else
    begin
        // Instruction cache has an immediate refill in this model,
        // so do not stall the pipeline for an I-cache miss.

        if((MemRead || MemWrite) && !d_cache_hit)
            stall_pipeline <= 1'b1;

        else
            stall_pipeline <= 1'b0;
    end

end

endmodule