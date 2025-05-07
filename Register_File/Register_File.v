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
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module register_file #(
    parameter REG_WIDTH = 8,
    parameter REG_COUNT = 8
)(
    input  wire                  clk,
    input  wire                  rst,
    input  wire                  we,         // Write enable

    input  wire [$clog2(REG_COUNT)-1:0] wr_addr,   // Write address
    input  wire [$clog2(REG_COUNT)-1:0] rd_addr1,  // Read address 1
    input  wire [$clog2(REG_COUNT)-1:0] rd_addr2,  // Read address 2

    input  wire [REG_WIDTH-1:0]  wr_data,    // Dữ liệu ghi
    output wire [REG_WIDTH-1:0]  rd_data1,   // Dữ liệu đọc 1
    output wire [REG_WIDTH-1:0]  rd_data2    // Dữ liệu đọc 2
);

    // Bộ nhớ thanh ghi: 8 thanh ghi 8-bit
    reg [REG_WIDTH-1:0] registers [0:REG_COUNT-1];

    integer i;

    // Reset tất cả thanh ghi (đồng bộ)
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < REG_COUNT; i = i + 1)
                registers[i] <= 0;
        end else if (we) begin
            registers[wr_addr] <= wr_data;
        end
    end

    // Đọc không đồng bộ (combinational)
    assign rd_data1 = registers[rd_addr1];
    assign rd_data2 = registers[rd_addr2];

endmodule
