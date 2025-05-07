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
