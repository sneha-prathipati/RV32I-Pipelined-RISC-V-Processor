`timescale 1ns/1ps

module data_cache(

    input clk,

    input MemRead,
    input MemWrite,

    input [31:0] address,
    input [31:0] write_data,

    output wire [31:0] read_data,
    output wire hit

);

reg valid [0:63];
reg [23:0] tag [0:63];
reg [31:0] data [0:63];

wire [5:0] index;
wire [23:0] addr_tag;

assign index = address[7:2];
assign addr_tag = address[31:8];


//--------------------------------------------------------
// Cache Hit Logic
//--------------------------------------------------------

assign hit = !(MemRead || MemWrite) ||
             (valid[index] && (tag[index] == addr_tag));


//--------------------------------------------------------
// Combinational Read
//--------------------------------------------------------

assign read_data = (MemRead && valid[index] &&
                    (tag[index] == addr_tag))
                   ? data[index]
                   : 32'd0;


//--------------------------------------------------------
// Cache Initialization
//--------------------------------------------------------

integer i;

initial
begin
    for(i = 0; i < 64; i = i + 1)
    begin
        valid[i] = 1'b0;
        tag[i]   = 24'd0;
        data[i]  = 32'd0;
    end
end


//--------------------------------------------------------
// Write Operation
//--------------------------------------------------------

always @(posedge clk)
begin

    if(MemWrite)
    begin
        valid[index] <= 1'b1;
        tag[index]   <= addr_tag;
        data[index]  <= write_data;
    end

end

endmodule