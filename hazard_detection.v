`timescale 1ns / 1ps

module hazard_detection(

    // Source registers in IF/ID stage
    input wire [4:0] IF_ID_rs1,
    input wire [4:0] IF_ID_rs2,

    // Destination register in ID/EX stage
    input wire [4:0] ID_EX_rd,

    // Load instruction indicator
    input wire ID_EX_MemRead,

    // Outputs
    output reg PCWrite,
    output reg IF_ID_Write,
    output reg ControlMux

);

always @(*)
begin

    // Default operation
    PCWrite    = 1'b1;
    IF_ID_Write = 1'b1;
    ControlMux = 1'b0;

    //--------------------------------------------------------
    // Load-Use Hazard Detection
    //--------------------------------------------------------

    if (ID_EX_MemRead &&
       ((ID_EX_rd == IF_ID_rs1) ||
        (ID_EX_rd == IF_ID_rs2)) &&
        (ID_EX_rd != 5'd0))
    begin

        // Stall Pipeline
        PCWrite     = 1'b0;
        IF_ID_Write = 1'b0;

        // Insert Bubble
        ControlMux  = 1'b1;

    end

end

endmodule