`timescale 1ns / 1ps

module forwarding_unit(

    // EX Stage Source Registers
    input wire [4:0] ID_EX_rs1,
    input wire [4:0] ID_EX_rs2,

    // EX/MEM Destination Register
    input wire [4:0] EX_MEM_rd,
    input wire       EX_MEM_RegWrite,

    // MEM/WB Destination Register
    input wire [4:0] MEM_WB_rd,
    input wire       MEM_WB_RegWrite,

    // Forwarding Controls
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB

);

always @(*)
begin

    // Default: No Forwarding
    ForwardA = 2'b00;
    ForwardB = 2'b00;

    //-------------------------------------------------
    // EX Hazard
    //-------------------------------------------------

    if(EX_MEM_RegWrite &&
       (EX_MEM_rd != 5'd0) &&
       (EX_MEM_rd == ID_EX_rs1))
    begin
        ForwardA = 2'b10;
    end

    if(EX_MEM_RegWrite &&
       (EX_MEM_rd != 5'd0) &&
       (EX_MEM_rd == ID_EX_rs2))
    begin
        ForwardB = 2'b10;
    end

    //-------------------------------------------------
    // MEM Hazard
    //-------------------------------------------------

    if(MEM_WB_RegWrite &&
       (MEM_WB_rd != 5'd0) &&
       !(EX_MEM_RegWrite &&
         (EX_MEM_rd != 5'd0) &&
         (EX_MEM_rd == ID_EX_rs1)) &&
       (MEM_WB_rd == ID_EX_rs1))
    begin
        ForwardA = 2'b01;
    end

    if(MEM_WB_RegWrite &&
       (MEM_WB_rd != 5'd0) &&
       !(EX_MEM_RegWrite &&
         (EX_MEM_rd != 5'd0) &&
         (EX_MEM_rd == ID_EX_rs2)) &&
       (MEM_WB_rd == ID_EX_rs2))
    begin
        ForwardB = 2'b01;
    end

end

endmodule