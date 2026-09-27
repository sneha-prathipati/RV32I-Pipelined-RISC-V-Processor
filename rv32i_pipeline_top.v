`timescale 1ns / 1ps
`include "defines.v"

module rv32i_pipeline_top(

    input clk,
    input rst,

    output wire [31:0] debug_status



);

/////////////////////////////////////////////////////////////
// IF Stage Wires
/////////////////////////////////////////////////////////////
wire predict_taken;
wire bp_update;
wire [31:0] if_instruction;
wire [31:0] if_pc;
wire [31:0] if_pc4;
wire [31:0] cycle_count;
wire [31:0] instruction_count;
wire pc_write;
wire if_flush;
wire pc_src;
wire [31:0] branch_target;
wire i_hit;
wire d_hit;

wire [31:0] i_hits;
wire [31:0] i_misses;


wire [31:0] d_hits;
wire [31:0] d_misses;
/////////////////////////////////////////////////////////////
// IF/ID Wires
/////////////////////////////////////////////////////////////

wire [31:0] id_instruction;
wire [31:0] id_pc;
wire [31:0] id_pc4;

wire ifid_write;
wire cache_stall;
/////////////////////////////////////////////////////////////
// ID Stage Wires
/////////////////////////////////////////////////////////////

wire [31:0] rs1_data;
wire [31:0] rs2_data;
wire [31:0] immediate;

wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;

wire [2:0] funct3;
wire [6:0] funct7;
wire [6:0] opcode;

wire Branch;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire ALUSrc;
wire RegWrite;

wire [1:0] ALUOp;

/////////////////////////////////////////////////////////////
// ID/EX Wires
/////////////////////////////////////////////////////////////

wire ex_Branch;
wire ex_MemRead;
wire ex_MemWrite;
wire ex_MemtoReg;
wire ex_ALUSrc;
wire ex_RegWrite;

wire [1:0] ex_ALUOp;

wire [31:0] ex_pc;
wire [31:0] ex_pc4;
wire [31:0] ex_rs1_data;
wire [31:0] ex_rs2_data;
wire [31:0] ex_immediate;

wire [4:0] ex_rs1;
wire [4:0] ex_rs2;
wire [4:0] ex_rd;

wire [2:0] ex_funct3;
wire [6:0] ex_funct7;

/////////////////////////////////////////////////////////////
// EX Stage Wires
/////////////////////////////////////////////////////////////

wire [31:0] alu_result;
wire [31:0] store_data;

wire ex_branch_taken;
wire [31:0] ex_branch_target;

wire [4:0] ex_rd_out;

/////////////////////////////////////////////////////////////
// EX/MEM Wires
/////////////////////////////////////////////////////////////

wire mem_Branch;
wire mem_MemRead;
wire mem_MemWrite;
wire mem_MemtoReg;
wire mem_RegWrite;

wire [31:0] mem_alu_result;
wire [31:0] mem_store_data;

wire mem_branch_taken;
wire [31:0] mem_branch_target;

wire [4:0] mem_rd;

/////////////////////////////////////////////////////////////
// MEM Stage Wires
/////////////////////////////////////////////////////////////

wire [31:0] mem_read_data;
wire [31:0] mem_alu_pass;

/////////////////////////////////////////////////////////////
// MEM/WB Wires
/////////////////////////////////////////////////////////////

wire wb_MemtoReg;
wire wb_RegWrite;

wire [31:0] wb_read_data;
wire [31:0] wb_alu_result;

wire [4:0] wb_rd;

/////////////////////////////////////////////////////////////
// WB Stage Wire
/////////////////////////////////////////////////////////////

wire [31:0] wb_data;

/////////////////////////////////////////////////////////////
// Hazard Detection
/////////////////////////////////////////////////////////////

wire control_mux;

/////////////////////////////////////////////////////////////
// Forwarding
/////////////////////////////////////////////////////////////

wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire uart_tx;
wire [31:0] stall_count;
wire [31:0] total_branches;
wire [31:0] correct_predictions;
wire [31:0] mispredictions;
wire [31:0] cpi;
wire perf_tx;
wire [31:0] flush_count;
wire refill_busy;
wire refill_done;
wire cache_miss;



/////////////////////////////////////////////////////////////
// IF Stage
/////////////////////////////////////////////////////////////
assign cache_miss = (~i_hit) ||
                    ((mem_MemRead || mem_MemWrite) && ~d_hit);

if_stage IF_STAGE(

    .clk(clk),
    .rst(rst),

    .pc_write(pc_write & ~cache_stall),
    .flush(if_flush),

    .pc_src(pc_src),
    .branch_target(branch_target),

    .instruction(if_instruction),
    .pc_current(if_pc),
    .pc_plus4(if_pc4),
    .cache_hit(i_hit)

);
/////////////////////////////////////////////////////////////
// IF/ID Register
/////////////////////////////////////////////////////////////

if_id IF_ID(

    .clk(clk),
    .rst(rst),

    .stall(~ifid_write),
    .flush(if_flush),

    .pc_in(if_pc),
    .pc4_in(if_pc4),
    .instruction_in(if_instruction),

    .pc_out(id_pc),
    .pc4_out(id_pc4),
    .instruction_out(id_instruction)

);
/////////////////////////////////////////////////////////////
// ID Stage
/////////////////////////////////////////////////////////////

id_stage ID_STAGE(

    .instruction(id_instruction),
    .pc(id_pc),
    .pc4(id_pc4),

    .clk(clk),
    .rst(rst),

    // Write Back
    .reg_write(wb_RegWrite),
    .wb_rd(wb_rd),
    .wb_data(wb_data),

    // Outputs
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .immediate(immediate),

    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),

    .funct3(funct3),
    .funct7(funct7),

    .opcode(opcode),

    .Branch(Branch),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp)

);

/////////////////////////////////////////////////////////////
// Hazard Detection
/////////////////////////////////////////////////////////////

hazard_detection HDU(

    .IF_ID_rs1(rs1),
    .IF_ID_rs2(rs2),

    .ID_EX_rd(ex_rd),

    .ID_EX_MemRead(ex_MemRead),

    .PCWrite(pc_write),
    .IF_ID_Write(ifid_write),
    .ControlMux(control_mux)

);

/////////////////////////////////////////////////////////////
// ID/EX Register
/////////////////////////////////////////////////////////////

id_ex ID_EX(

    .clk(clk),
    .rst(rst),

    .flush(control_mux),

    .Branch_in(Branch),
    .MemRead_in(MemRead),
    .MemWrite_in(MemWrite),
    .MemtoReg_in(MemtoReg),
    .ALUSrc_in(ALUSrc),
    .RegWrite_in(RegWrite),
    .ALUOp_in(ALUOp),

    .pc_in(id_pc),
    .pc4_in(id_pc4),

    .rs1_data_in(rs1_data),
    .rs2_data_in(rs2_data),

    .immediate_in(immediate),

    .rs1_in(rs1),
    .rs2_in(rs2),
    .rd_in(rd),

    .funct3_in(funct3),
    .funct7_in(funct7),

    .Branch_out(ex_Branch),
    .MemRead_out(ex_MemRead),
    .MemWrite_out(ex_MemWrite),
    .MemtoReg_out(ex_MemtoReg),
    .ALUSrc_out(ex_ALUSrc),
    .RegWrite_out(ex_RegWrite),
    .ALUOp_out(ex_ALUOp),

    .pc_out(ex_pc),
    .pc4_out(ex_pc4),

    .rs1_data_out(ex_rs1_data),
    .rs2_data_out(ex_rs2_data),

    .immediate_out(ex_immediate),

    .rs1_out(ex_rs1),
    .rs2_out(ex_rs2),
    .rd_out(ex_rd),

    .funct3_out(ex_funct3),
    .funct7_out(ex_funct7)

);

/////////////////////////////////////////////////////////////
// Forwarding Unit
/////////////////////////////////////////////////////////////

forwarding_unit FU(

    .ID_EX_rs1(ex_rs1),
    .ID_EX_rs2(ex_rs2),

    .EX_MEM_rd(mem_rd),
    .EX_MEM_RegWrite(mem_RegWrite),

    .MEM_WB_rd(wb_rd),
    .MEM_WB_RegWrite(wb_RegWrite),

    .ForwardA(ForwardA),
    .ForwardB(ForwardB)

);


/////////////////////////////////////////////////////////////
// EX Stage
/////////////////////////////////////////////////////////////

ex_stage EX_STAGE(

    .pc(ex_pc),

    .rs1_data(ex_rs1_data),
    .rs2_data(ex_rs2_data),

    .immediate(ex_immediate),

    .rd(ex_rd),

    .funct3(ex_funct3),
    .funct7(ex_funct7),

    .Branch(ex_Branch),
    .ALUSrc(ex_ALUSrc),
    .ALUOp(ex_ALUOp),

    .ForwardA(ForwardA),
    .ForwardB(ForwardB),

    .ex_mem_data(mem_alu_result),
    .mem_wb_data(wb_data),

    .alu_result(alu_result),

    .write_data(store_data),

    .branch_target(ex_branch_target),

    .branch_taken(ex_branch_taken),

    .rd_out(ex_rd_out)

);
/////////////////////////////////////////////////////////////
// EX/MEM Register
/////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////
// EX/MEM Register
/////////////////////////////////////////////////////////////

ex_mem EX_MEM(

    .clk(clk),
    .rst(rst),

    // Control inputs
    .MemRead_in(ex_MemRead),
    .MemWrite_in(ex_MemWrite),
    .MemtoReg_in(ex_MemtoReg),
    .RegWrite_in(ex_RegWrite),
    .Branch_in(ex_Branch),

    // Data inputs
    .alu_result_in(alu_result),
    .write_data_in(store_data),
    .branch_target_in(ex_branch_target),

    .branch_taken_in(ex_branch_taken),

    .rd_in(ex_rd_out),

    // Control outputs
    .MemRead_out(mem_MemRead),
    .MemWrite_out(mem_MemWrite),
    .MemtoReg_out(mem_MemtoReg),
    .RegWrite_out(mem_RegWrite),
    .Branch_out(mem_Branch),

    // Data outputs
    .alu_result_out(mem_alu_result),
    .write_data_out(mem_store_data),
    .branch_target_out(mem_branch_target),

    .branch_taken_out(mem_branch_taken),

    .rd_out(mem_rd)

);
/////////////////////////////////////////////////////////////
// MEM Stage
/////////////////////////////////////////////////////////////

mem_stage MEM_STAGE(

    .clk(clk),

    .MemRead(mem_MemRead),
    .MemWrite(mem_MemWrite),

    .alu_result(mem_alu_result),

    .write_data(mem_store_data),

   .read_data(mem_read_data),

.alu_result_out(mem_alu_pass),

.cache_hit(d_hit)

);

/////////////////////////////////////////////////////////////
// MEM/WB Register
/////////////////////////////////////////////////////////////

mem_wb MEM_WB(

    .clk(clk),
    .rst(rst),

    .MemtoReg_in(mem_MemtoReg),
    .RegWrite_in(mem_RegWrite),

    .read_data_in(mem_read_data),
    .alu_result_in(mem_alu_result),

    .rd_in(mem_rd),

    .MemtoReg_out(wb_MemtoReg),
    .RegWrite_out(wb_RegWrite),

    .read_data_out(wb_read_data),
    .alu_result_out(wb_alu_result),

    .rd_out(wb_rd)

);
performance_counter PERF(

    .clk(clk),
    .rst(rst),

    .instruction_valid(wb_RegWrite),

    .cycle_count(cycle_count),
    .instruction_count(instruction_count)

);
cache_monitor CACHE_MON(

    .clk(clk),
    .rst(rst),

    .i_hit(i_hit),
    .d_hit(d_hit),

    .i_hits(i_hits),
    .i_misses(i_misses),

    .d_hits(d_hits),
    .d_misses(d_misses)

);
uart_debug UART(

    .clk(clk),
    .rst(rst),

    .pc(if_pc),
    .instruction(if_instruction),
    .alu_result(mem_alu_result),

    .tx(uart_tx)

);
stall_counter STALL(

    .clk(clk),
    .rst(rst),

    .stall(~pc_write),

    .stall_count(stall_count)

);
branch_stats BRANCH_STATS(

    .clk(clk),
    .rst(rst),

    .prediction(predict_taken),
    .actual(mem_branch_taken),

    .total_branches(total_branches),
    .correct_predictions(correct_predictions),
    .mispredictions(mispredictions)

);

cpi_monitor CPI(

    .clk(clk),
    .rst(rst),

    .cycle_count(cycle_count),
    .instruction_count(instruction_count),

    .cpi(cpi)

);

uart_monitor UART_MON(

.clk(clk),
.rst(rst),

.cycle_count(cycle_count),
.instruction_count(instruction_count),
.stall_count(stall_count),
.cpi(cpi),

.tx(perf_tx)

);

flush_counter FLUSH(

.clk(clk),
.rst(rst),

.flush(if_flush),

.flush_count(flush_count)

);
cache_controller CACHE_CTRL(

    .clk(clk),
    .rst(rst),

    .i_cache_hit(i_hit),
    .d_cache_hit(d_hit),

    .MemRead(mem_MemRead),
    .MemWrite(mem_MemWrite),

    .stall_pipeline(cache_stall)

);
cache_refill REFILL(

    .clk(clk),
    .rst(rst),

    .cache_miss(cache_miss),

    .busy(refill_busy),
    .refill_done(refill_done)

);

















/////////////////////////////////////////////////////////////
// Write Back Stage
/////////////////////////////////////////////////////////////

wb_stage WB_STAGE(

    .MemtoReg(wb_MemtoReg),

    .read_data(wb_read_data),

    .alu_result(wb_alu_result),

    .wb_data(wb_data)

);
branch_predictor BP(

    .clk(clk),
    .rst(rst),

    .pc(if_pc),

    .actual_taken(mem_branch_taken),

    .update(bp_update),

    .predict_taken(predict_taken)

);
/////////////////////////////////////////////////////////////
// Branch Control
/////////////////////////////////////////////////////////////

assign pc_src = mem_branch_taken;
assign bp_update = mem_Branch;
assign branch_target = mem_branch_target;
assign if_flush = mem_branch_taken;
/////////////////////////////////////////////////////////////
// End
/////////////////////////////////////////////////////////////
assign debug_status =
      if_pc
    ^ if_instruction
    ^ alu_result
    ^ mem_alu_result
    ^ wb_data
    ^ {27'd0, wb_rd};
endmodule
