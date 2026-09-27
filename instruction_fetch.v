`timescale 1ns / 1ps

module instruction_fetch(

    input wire clk,
    input wire rst,
    input wire pc_write,

    output wire [31:0] pc,
    output wire [31:0] instruction

);

wire [31:0] next_pc;

pc PC(

    .clk(clk),
    .rst(rst),
    .pc_write(pc_write),
    .pc_next(next_pc),
    .pc_current(pc)

);

pc_adder ADDER(

    .pc_current(pc),
    .pc_plus4(next_pc)

);

instruction_memory IMEM(

    .address(pc),
    .instruction(instruction)

);

endmodule