// luồng 
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module timer #(
    parameter MAX_COUNT = 100_000_000
)(
    input  wire clk,
    input  wire rst,
    input  wire start,
    output reg  timeout,
    output reg  irq       // tín hiệu ngắt ra ngoài
);
    reg [$clog2(MAX_COUNT)-1:0] counter;
    reg running;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            timeout <= 0;
            irq <= 0;
            running <= 0;
        end else begin
            if (start) begin
                running <= 1;
                counter <= 0;
                timeout <= 0;
                irq <= 0;
            end else if (running) begin
                if (counter == MAX_COUNT - 1) begin
                    timeout <= 1;
                    irq <= 1;
                    running <= 0;
                end else begin
                    counter <= counter + 1;
                    irq <= 0;
                end
            end else begin
                timeout <= 0;
                irq <= 0;
            end
        end
    end
endmodule

