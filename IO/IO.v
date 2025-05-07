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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module io_module (
    input  wire        clk,
    input  wire        we,
    input  wire        re,
    input  wire [7:0]  addr,
    input  wire [7:0]  data_in,
    output reg  [7:0]  data_out,

     // Giao tiếp ngoại vi
    output reg  [7:0]  led,
    input  wire [7:0]  button,
    output wire        uart_tx,
    input  wire        uart_rx
);
always @(posedge clk) begin
    if (we) begin
        case (addr)
            8'h01: led <= data_in;         // ghi LED
            8'h03: uart_tx_reg <= data_in; // ghi UART TX (giả định)
            // thêm ngoại vi khác nếu có
        endcase
    end
    if (re) begin
        case (addr)
            8'h02: data_out <= button;     // đọc nút nhấn
            8'h04: data_out <= uart_rx_reg; // đọc UART RX (giả định)
            // thêm ngoại vi khác nếu có
            default: data_out <= 8'h00;
        endcase
    end
end
