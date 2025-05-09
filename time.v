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
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module timer #(
    parameter MAX_COUNT = 100_000_000  // đếm 100 triệu chu kỳ (ví dụ 1s nếu clk 100 MHz)
)(
    input  wire clk,
    input  wire rst,        // reset đồng bộ
    input  wire start,      // bắt đầu đếm
    output reg  timeout     // báo đã hết thời gian
);

    reg [$clog2(MAX_COUNT)-1:0] counter;
    reg running;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            timeout <= 0;
            running <= 0;
        end else begin
            if (start) begin
                running <= 1;
                counter <= 0;
                timeout <= 0;
            end else if (running) begin
                if (counter == MAX_COUNT - 1) begin
                    timeout <= 1;
                    running <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end else begin
                timeout <= 0;
            end
        end
    end

endmodule
