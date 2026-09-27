`timescale 1ns / 1ps

module tb_rv32i_pipeline;

    //----------------------------------------------------------
    // Testbench Signals
    //----------------------------------------------------------
    reg clk;
    reg rst;

    //----------------------------------------------------------
    // Instantiate DUT
    //----------------------------------------------------------
    rv32i_pipeline_top DUT(
        .clk(clk),
        .rst(rst)
    );

    //----------------------------------------------------------
    // Clock Generation - 100 MHz
    //----------------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    //----------------------------------------------------------
    // Reset + Simulation Sequence
    //----------------------------------------------------------
    initial begin

        // Start in reset
        rst = 1'b1;

        // Hold reset for 20 ns
        #20;

        // Release reset
        rst = 1'b0;

        // Let processor execute
        #500;

        //------------------------------------------------------
        // Register Verification
        //------------------------------------------------------
$display("DEBUG x1 = %h", DUT.ID_STAGE.RF.registers[1]);
$display("DEBUG x2 = %h", DUT.ID_STAGE.RF.registers[2]);
$display("DEBUG x3 = %h", DUT.ID_STAGE.RF.registers[3]);
$display("DEBUG x4 = %h", DUT.ID_STAGE.RF.registers[4]);
$display("DEBUG x5 = %h", DUT.ID_STAGE.RF.registers[5]);

$display("DEBUG WB_RD = %d", DUT.wb_rd);
$display("DEBUG WB_DATA = %h", DUT.wb_data);
$display("DEBUG WB_RegWrite = %b", DUT.wb_RegWrite);
        $display("");
        $display("===== Register Verification =====");

        if (DUT.ID_STAGE.RF.registers[1] == 32'd5)
            $display("PASS : x1 = %0d",
                     DUT.ID_STAGE.RF.registers[1]);
        else
            $display("FAIL : x1 = %0d (Expected 5)",
                     DUT.ID_STAGE.RF.registers[1]);

        if (DUT.ID_STAGE.RF.registers[2] == 32'd10)
            $display("PASS : x2 = %0d",
                     DUT.ID_STAGE.RF.registers[2]);
        else
            $display("FAIL : x2 = %0d (Expected 10)",
                     DUT.ID_STAGE.RF.registers[2]);

        if (DUT.ID_STAGE.RF.registers[3] == 32'd15)
            $display("PASS : x3 = %0d",
                     DUT.ID_STAGE.RF.registers[3]);
        else
            $display("FAIL : x3 = %0d (Expected 15)",
                     DUT.ID_STAGE.RF.registers[3]);

        if (DUT.ID_STAGE.RF.registers[4] == 32'd5)
            $display("PASS : x4 = %0d",
                     DUT.ID_STAGE.RF.registers[4]);
        else
            $display("FAIL : x4 = %0d (Expected 5)",
                     DUT.ID_STAGE.RF.registers[4]);

        if (DUT.ID_STAGE.RF.registers[5] == 32'd15)
            $display("PASS : x5 = %0d",
                     DUT.ID_STAGE.RF.registers[5]);
        else
            $display("FAIL : x5 = %0d (Expected 15)",
                     DUT.ID_STAGE.RF.registers[5]);

        //------------------------------------------------------
        // Processor Status
        //------------------------------------------------------

        if (DUT.cycle_count > 0)
            $display("PASS : Processor Executed Successfully");
        else
            $display("FAIL : Processor Did Not Execute");

        //------------------------------------------------------
        // Performance Summary
        //------------------------------------------------------

        $display("");
        $display("==========================================");
        $display(" RV32I PIPELINE SIMULATION COMPLETED ");
        $display("==========================================");

        $display("Total Cycles            = %0d",
                 DUT.cycle_count);

        $display("Instructions Retired    = %0d",
                 DUT.instruction_count);

        $display("Stall Count             = %0d",
                 DUT.stall_count);

        $display("Flush Count             = %0d",
                 DUT.flush_count);

        $display("Instruction Cache Hits  = %0d",
                 DUT.i_hits);

        $display("Instruction Cache Misses= %0d",
                 DUT.i_misses);

        $display("Data Cache Hits         = %0d",
                 DUT.d_hits);

        $display("Data Cache Misses       = %0d",
                 DUT.d_misses);

        $display("Branches                = %0d",
                 DUT.total_branches);

        $display("Correct Predictions     = %0d",
                 DUT.correct_predictions);

        $display("Mispredictions          = %0d",
                 DUT.mispredictions);

        $display("CPI                     = %0d",
                 DUT.cpi);

        $display("");

        $finish;

    end

    //----------------------------------------------------------
    // Live Monitor
    //----------------------------------------------------------
    initial begin

        $display("---------------------------------------------------------------");
        $display(" RV32I 5-Stage Pipeline Simulation Started ");
        $display("---------------------------------------------------------------");

        $monitor(
        "Time=%0t | PC=%h | Instr=%h | EX_ALU=%h | MEM_ALU=%h | ALUCtrl=%b | EX_RS1=%0d | EX_RS2=%0d | EX_RD=%0d | EX_RD_OUT=%0d | MEM_RD=%0d | WB_RD=%0d | EX_RegW=%b | MEM_RegW=%b | WB_RegW=%b | RF_RD=%0d | RF_WDATA=%h",

        $time,

        DUT.if_pc,
        DUT.if_instruction,

        DUT.EX_STAGE.alu_result,
        DUT.mem_alu_result,
        DUT.EX_STAGE.alu_ctrl,

        DUT.ex_rs1,
        DUT.ex_rs2,

        DUT.ex_rd,
        DUT.ex_rd_out,

        DUT.mem_rd,
        DUT.wb_rd,

        DUT.ex_RegWrite,
        DUT.mem_RegWrite,
        DUT.wb_RegWrite,

        DUT.ID_STAGE.RF.rd,
        DUT.ID_STAGE.RF.write_data
        );

    end

endmodule