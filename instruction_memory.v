`timescale 1ns / 1ps

module instruction_memory(

    input  wire [31:0] address,
    output wire [31:0] instruction

);

reg [31:0] memory [0:255];

initial
begin

    // Sample Program

    memory[0] = 32'h00500093; // addi x1,x0,5
    memory[1] = 32'h00A00113; // addi x2,x0,10
    memory[2] = 32'h002081B3; // add x3,x1,x2
    memory[3] = 32'h40110233; // sub x4,x2,x1
    memory[4] = 32'h00302023; // sw x3,0(x0)
    memory[5] = 32'h00002283; // lw x5,0(x0)

end

assign instruction = memory[address[31:2]];

endmodule