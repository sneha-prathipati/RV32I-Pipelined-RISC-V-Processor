`timescale 1ns / 1ps

module immediate_generator(

    input wire [31:0] instruction,

    output reg [31:0] immediate

);

always @(*)
begin

case(instruction[6:0])

7'b0010011:
    immediate = {{20{instruction[31]}},instruction[31:20]};

7'b0000011:
    immediate = {{20{instruction[31]}},instruction[31:20]};

7'b0100011:
    immediate = {{20{instruction[31]}},
                 instruction[31:25],
                 instruction[11:7]};

default:
    immediate = 32'd0;

endcase

end

endmodule