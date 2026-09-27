`timescale 1ns / 1ps

module pc(

    input wire clk,
    input wire rst,
    input wire pc_write,
    input wire [31:0] pc_next,

    output reg [31:0] pc_current

);

always @(posedge clk or posedge rst)
begin

    if(rst)
        pc_current <= 32'h00000000;

    else if(pc_write)
        pc_current <= pc_next;

end

endmodule