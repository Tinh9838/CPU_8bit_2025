// + Tx và Rx
//
//      start-> |      | -> busy
//   data_in -> | UART | -> tx
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

module uart_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] data_in,
    input  wire       start,
    output wire       tx,
    output wire       busy
);
    parameter CLK_PER_BIT = 434;  // cho 115200 baud, 50MHz

    reg [3:0] bit_index = 0;
    reg [9:0] shift_reg;
    reg [15:0] clk_count = 0;
    reg tx_reg = 1;
    reg tx_busy = 0;

    assign tx = tx_reg;
    assign busy = tx_busy;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_reg <= 1;
            tx_busy <= 0;
            bit_index <= 0;
            clk_count <= 0;
        end else begin
            if (start && !tx_busy) begin
                // start bit (0) + 8 data bits + stop bit (1)
                shift_reg <= {1'b1, data_in, 1'b0};
                tx_busy <= 1;
                bit_index <= 0;
                clk_count <= 0;
            end else if (tx_busy) begin
                if (clk_count < CLK_PER_BIT - 1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    tx_reg <= shift_reg[0];
                    shift_reg <= {1'b1, shift_reg[9:1]};
                    bit_index <= bit_index + 1;

                    if (bit_index == 9) begin
                        tx_busy <= 0;
                        tx_reg <= 1;
                    end
                end
            end
        end
    end
endmodule
