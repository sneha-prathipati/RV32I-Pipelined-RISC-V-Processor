`timescale 1ns/1ps

module instruction_cache(

    input clk,
    input [31:0] address,

    output reg [31:0] instruction,
    output wire hit

);

reg valid [0:63];
reg [23:0] tag [0:63];
reg [31:0] data [0:63];

wire [5:0] index;
wire [23:0] addr_tag;

assign index = address[7:2];
assign addr_tag = address[31:8];

assign hit = valid[index] && (tag[index] == addr_tag);

integer i;
initial begin
    for(i=0;i<64;i=i+1)
    begin
        valid[i] = 0;
        tag[i]   = 0;
        data[i]  = 32'h00000013; // NOP
    end

    $readmemh("program.mem", data);
end

always @(posedge clk)
begin

   if (hit) begin

    instruction <= data[index];

end
else begin

    valid[index] <= 1'b1;
    tag[index]   <= addr_tag;

    // Mark cache line as valid (temporary model)
    instruction <= data[index];

end

end

endmodule