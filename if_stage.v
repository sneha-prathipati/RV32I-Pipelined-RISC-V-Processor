`timescale 1ns / 1ps

module if_stage(

    input  wire clk,
    input  wire rst,

    input  wire pc_write,
    input  wire flush,

    input  wire pc_src,
    input  wire [31:0] branch_target,

    output wire [31:0] instruction,
    output wire [31:0] pc_current,
    output wire [31:0] pc_plus4,

    output wire cache_hit

);

//------------------------------------------------------------
// Internal Signals
//------------------------------------------------------------
wire [31:0] pc_next;
wire [31:0] instr_mem;

//------------------------------------------------------------
// PC MUX
//------------------------------------------------------------
assign pc_next = (pc_src) ? branch_target : pc_plus4;

//------------------------------------------------------------
// Program Counter
//------------------------------------------------------------
pc PC (
    .clk(clk),
    .rst(rst),
    .pc_write(pc_write),
    .pc_next(pc_next),
    .pc_current(pc_current)
);

//------------------------------------------------------------
// PC + 4
//------------------------------------------------------------
pc_adder PC_ADDER (
    .pc_current(pc_current),
    .pc_plus4(pc_plus4)
);

//------------------------------------------------------------
// Instruction Memory
//------------------------------------------------------------
instruction_cache ICACHE(

    .clk(clk),

    .address(pc_current),

    .instruction(instr_mem),

    .hit(cache_hit)

);
//------------------------------------------------------------
// Flush Logic
//------------------------------------------------------------
assign instruction = (flush) ? 32'h00000013 : instr_mem;
// 32'h00000013 = NOP (ADDI x0,x0,0)

endmodule