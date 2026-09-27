`timescale 1ns/1ps

module branch_stats(

    input clk,
    input rst,

    input prediction,
    input actual,

    output reg [31:0] total_branches,
    output reg [31:0] correct_predictions,
    output reg [31:0] mispredictions

);

always @(posedge clk)
begin

    if(rst)
    begin
        total_branches <= 0;
        correct_predictions <= 0;
        mispredictions <= 0;
    end
    else
    begin
        total_branches <= total_branches + 1;

        if(prediction == actual)
            correct_predictions <= correct_predictions + 1;
        else
            mispredictions <= mispredictions + 1;
    end

end

endmodule