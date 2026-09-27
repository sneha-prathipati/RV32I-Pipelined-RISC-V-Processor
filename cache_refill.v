`timescale 1ns/1ps

module cache_refill(

    input clk,
    input rst,

    input cache_miss,

    output reg busy,
    output reg refill_done

);

reg [2:0] state;

parameter IDLE    = 3'd0;
parameter REFILL  = 3'd1;
parameter FINISH  = 3'd2;

always @(posedge clk)
begin

    if(rst)
    begin
        state <= IDLE;
        busy <= 0;
        refill_done <= 0;
    end
    else
    begin

        case(state)

        IDLE:
        begin
            refill_done <= 0;

            if(cache_miss)
            begin
                busy <= 1;
                state <= REFILL;
            end
        end

        REFILL:
        begin
            state <= FINISH;
        end

        FINISH:
        begin
            busy <= 0;
            refill_done <= 1;
            state <= IDLE;
        end

        endcase

    end

end

endmodule