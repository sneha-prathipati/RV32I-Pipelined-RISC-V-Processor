`timescale 1ns / 1ps

module performance_counter(

    input clk,
    input rst,
    input instruction_valid,

    output reg [31:0] cycle_count,
    output reg [31:0] instruction_count

);

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        cycle_count <= 32'd0;
        instruction_count <= 32'd0;
    end
    else
    begin
        cycle_count <= cycle_count + 1;

        if(instruction_valid)
            instruction_count <= instruction_count + 1;
    end
end

endmodule