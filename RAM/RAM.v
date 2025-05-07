// +Bộ nhớ 256 ô, mỗi ô 8 bit
//
//
//
//
// + luồng : bus tín hiệu we + bus địa chỉ addr + data_in = ghi vào ram
//
//           bus tín hiệu re + bus địa chỉ addr = đọc ram = data_out
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ram (
    input  wire        clk,             // xung nhịp
    input  wire [7:0]  addr,            // địa chỉ
    input  wire        we,              // write enable
    input  wire        re,              // read enable
    input  wire [7:0]  data_in,         // dữ liệu ghi

    output reg  [7:0]  data_out         // dữ liệu đọc ra
);

    // Bộ nhớ 256 ô, mỗi ô 8-bit
    reg [7:0] memory [0:255];

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in;       // ghi dữ liệu vào RAM
        end
        if (re) begin
            data_out <= memory[addr];      // chỉ đọc khi re = 1
        end
    end

endmodule
