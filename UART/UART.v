// + Tx và Rx
//
//   tx_start   -> |      | -> tx_busy
//   tx_data    -> |      | -> tx
//                 | UART |
//   rx         -> |      | -> rx_data
//                 |______| -> rx_ready
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

module uart #(
    parameter CLK_FREQ = 100_000_000,    // 100 MHz clock
    parameter BAUD_RATE = 9600
)(
    input  wire       clk,
    input  wire       rst,

    // Transmit interface
    input  wire [7:0] tx_data,
    input  wire       tx_start,
    output reg        tx_busy,
    output wire       tx,

    // Receive interface
    output reg  [7:0] rx_data,
    output reg        rx_ready,
    input  wire       rx
);

    // -------- Baud rate generator --------
    localparam BAUD_DIV = CLK_FREQ / BAUD_RATE;

    reg [15:0] baud_cnt = 0;
    reg        baud_tick = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            baud_cnt  <= 0;
            baud_tick <= 0;
        end else begin
            if (baud_cnt == BAUD_DIV/2) begin
                baud_cnt  <= 0;
                baud_tick <= 1;
            end else begin
                baud_cnt  <= baud_cnt + 1;
                baud_tick <= 0;
            end
        end
    end

    // -------- TX (Transmit) --------
    reg [3:0] tx_bit_cnt = 0;
    reg [9:0] tx_shift = 10'b1111111111;

    assign tx = tx_shift[0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_shift   <= 10'b1111111111;
            tx_bit_cnt <= 0;
            tx_busy    <= 0;
        end else begin
            if (!tx_busy && tx_start) begin
                // Load start bit, data, stop bit
                tx_shift   <= {1'b1, tx_data, 1'b0}; // {STOP, DATA[7:0], START}
                tx_bit_cnt <= 0;
                tx_busy    <= 1;
            end else if (tx_busy && baud_tick) begin
                tx_shift <= {1'b1, tx_shift[9:1]};
                tx_bit_cnt <= tx_bit_cnt + 1;
                if (tx_bit_cnt == 9) begin
                    tx_busy <= 0;
                end
            end
        end
    end

    // -------- RX (Receive) --------
    reg [3:0] rx_bit_cnt = 0;
    reg [7:0] rx_shift = 0;
    reg [15:0] rx_clk_cnt = 0;
    reg        rx_sampling = 0;
    reg        rx_prev = 1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_ready     <= 0;
            rx_sampling  <= 0;
            rx_clk_cnt   <= 0;
            rx_bit_cnt   <= 0;
            rx_shift     <= 0;
        end else begin
            rx_ready <= 0;  // Clear after 1 cycle

            if (!rx_sampling) begin
                // Detect falling edge (start bit)
                if (rx_prev == 1 && rx == 0) begin
                    rx_sampling <= 1;
                    rx_clk_cnt  <= BAUD_DIV + (BAUD_DIV / 2); // sample in middle
                    rx_bit_cnt  <= 0;
                end
            end else begin
                if (rx_clk_cnt == 0) begin
                    rx_clk_cnt <= BAUD_DIV;
                    rx_bit_cnt <= rx_bit_cnt + 1;
                    if (rx_bit_cnt < 8) begin
                        rx_shift <= {rx[0], rx_shift[7:1]};
                    end
                    if (rx_bit_cnt == 8) begin
                        rx_data <= rx_shift;
                        rx_ready <= 1;
                        rx_sampling <= 0;
                    end
                end else begin
                    rx_clk_cnt <= rx_clk_cnt - 1;
                end
            end
            rx_prev <= rx;
        end
    end
endmodule

