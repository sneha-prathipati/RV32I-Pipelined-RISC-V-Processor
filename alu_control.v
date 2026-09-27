`timescale 1ns / 1ps

module alu_control(
    input wire [1:0] ALUOp,
    input wire [2:0] funct3,
    input wire funct7,
    output reg [3:0] ALUControl
);

always @(*) begin

    case(ALUOp)

        // LOAD / STORE / address calculation
        2'b00: begin
            ALUControl = 4'b0000;   // ADD
        end

        // BRANCH
        2'b01: begin
            ALUControl = 4'b0001;   // SUB
        end

        // R-type / I-type ALU operations
        2'b10: begin

            case({funct7,funct3})

                4'b0000: ALUControl = 4'b0000; // ADD
                4'b1000: ALUControl = 4'b0001; // SUB

                4'b0111: ALUControl = 4'b0010; // AND
                4'b0110: ALUControl = 4'b0011; // OR
                4'b0100: ALUControl = 4'b0100; // XOR

                4'b0001: ALUControl = 4'b0101; // SLL
                4'b0101: ALUControl = 4'b0110; // SRL
                4'b1101: ALUControl = 4'b0111; // SRA

                4'b0010: ALUControl = 4'b1000; // SLT
                4'b0011: ALUControl = 4'b1001; // SLTU

                default: ALUControl = 4'b0000;

            endcase

        end

        default:
            ALUControl = 4'b0000;

    endcase

end

endmodule