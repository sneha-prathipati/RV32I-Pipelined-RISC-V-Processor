`timescale 1ns / 1ps

module branch_predictor(

    input clk,
    input rst,

    input [31:0] pc,
    input actual_taken,
    input update,

    output predict_taken

);

reg [1:0] BHT [0:63];

wire [5:0] index;

assign index = pc[7:2];

assign predict_taken = BHT[index][1];

integer i;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        for(i=0;i<64;i=i+1)
            BHT[i] <= 2'b01;
    end

    else if(update)
    begin

        if(actual_taken)
        begin
            if(BHT[index]!=2'b11)
                BHT[index] <= BHT[index]+1;
        end
        else
        begin
            if(BHT[index]!=2'b00)
                BHT[index] <= BHT[index]-1;
        end

    end

end

endmodule