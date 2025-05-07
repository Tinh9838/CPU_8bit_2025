module register_file #(
    parameter REG_WIDTH = 8,       // Độ rộng của mỗi thanh ghi (8 bits mặc định)
    parameter REG_COUNT = 8      // Số lượng thanh ghi (8 thanh ghi mặc định)
)(
    input  wire                     clk,          // Xung clock
    input  wire                     rst,          // Reset (active high, đồng bộ)
    input  wire                     we,           // Write enable (cho phép ghi)
    input  wire [$clog2(REG_COUNT)-1:0] wr_addr,      // Địa chỉ ghi
    input  wire [$clog2(REG_COUNT)-1:0] rd_addr1,     // Địa chỉ đọc 1
    input  wire [$clog2(REG_COUNT)-1:0] rd_addr2,     // Địa chỉ đọc 2
    input  wire [REG_WIDTH-1:0]     wr_data,      // Dữ liệu để ghi
    output wire [REG_WIDTH-1:0]     rd_data1,     // Dữ liệu đọc từ địa chỉ 1
    output wire [REG_WIDTH-1:0]     rd_data2      // Dữ liệu đọc từ địa chỉ 2
);

    // Bộ nhớ thanh ghi: Khai báo một mảng các thanh ghi
    reg [REG_WIDTH-1:0] registers [0:REG_COUNT-1]; // Mảng có REG_COUNT phần tử, mỗi phần tử rộng REG_WIDTH

    integer i; // Biến đếm cho vòng lặp

    // Hoạt động ghi và reset của thanh ghi (tuần tự theo xung clock)
    always @(posedge clk) begin
        if (rst) begin // Nếu reset được kích hoạt
            for (i = 0; i < REG_COUNT; i = i + 1) begin // Duyệt qua tất cả các thanh ghi
                registers[i] <= 0;             // Gán giá trị 0 cho mỗi thanh ghi (reset)
            end
        end else if (we) begin // Nếu write enable được kích hoạt
            registers[wr_addr] <= wr_data; // Ghi dữ liệu wr_data vào thanh ghi có địa chỉ wr_addr
        end
        // Nếu không có reset hoặc write enable, giữ nguyên giá trị của thanh ghi
    end

    // Hoạt động đọc thanh ghi (tổ hợp - không phụ thuộc vào xung clock)
    assign rd_data1 = registers[rd_addr1]; // Đọc dữ liệu từ thanh ghi có địa chỉ rd_addr1
    assign rd_data2 = registers[rd_addr2]; // Đọc dữ liệu từ thanh ghi có địa chỉ rd_addr2

endmodule

// Testbench cho module register_file
module register_file_tb;

    // Các tham số cho testbench (giống với module register_file)
    parameter REG_WIDTH = 8;
    parameter REG_COUNT = 8;

    // Khai báo các tín hiệu
    reg                      clk_tb;
    reg                      rst_tb;
    reg                      we_tb;
    reg [$clog2(REG_COUNT)-1:0] wr_addr_tb;
    reg [$clog2(REG_COUNT)-1:0] rd_addr1_tb;
    reg [$clog2(REG_COUNT)-1:0] rd_addr2_tb;
    reg [REG_WIDTH-1:0]      wr_data_tb;
    wire [REG_WIDTH-1:0]     rd_data1_tb;
    wire [REG_WIDTH-1:0]     rd_data2_tb;

    // Khai báo biến integer để theo dõi
    integer i;

    // Khởi tạo clock
    initial begin
        clk_tb = 0;
        forever #10 clk_tb = ~clk_tb; // Tạo xung clock với chu kỳ 20ns
    end

    // Khởi tạo các tín hiệu khác và tiến hành test
    initial begin
        rst_tb = 1;  // Khởi tạo reset
        we_tb = 0;
        wr_addr_tb = 0;
        rd_addr1_tb = 0;
        rd_addr2_tb = 0;
        wr_data_tb = 0;

        // In tiêu đề
        $display("Time\tReset\tWriteEn\tWrAddr\tWrData\tRdAddr1\tRdData2\tRdData1Out\tRdData2Out");
        $display("-------------------------------------------------------------------------------------");

        #20 rst_tb = 0; // Bỏ reset sau 20ns

        // Test case 1: Ghi vào thanh ghi 0, đọc từ thanh ghi 0
        we_tb = 1;
        wr_addr_tb = 0;
        wr_data_tb = 8'h55;
        rd_addr1_tb = 0;
        rd_addr2_tb = 0;
        #10 $display("%0t\t%b\t%b\t%d\t%h\t%d\t%d\t%h\t%h", $time, rst_tb, we_tb, wr_addr_tb, wr_data_tb, rd_addr1_tb, rd_addr2_tb, rd_data1_tb, rd_data2_tb);

        // Test case 2: Ghi vào thanh ghi 1, đọc từ thanh ghi 0 và 1
        we_tb = 1;
        wr_addr_tb = 1;
        wr_data_tb = 8'hAA;
        rd_addr1_tb = 0;
        rd_addr2_tb = 1;
        #10 $display("%0t\t%b\t%b\t%d\t%h\t%d\t%d\t%h\t%h", $time, rst_tb, we_tb, wr_addr_tb, wr_data_tb, rd_addr1_tb, rd_addr2_tb, rd_data1_tb, rd_data2_tb);

       // Test case 3: Ghi vào thanh ghi 7, đọc từ 0,1,7
        we_tb = 1;
        wr_addr_tb = 7;
        wr_data_tb = 8'hFF;
        rd_addr1_tb = 0;
        rd_addr2_tb = 1;
        #10 $display("%0t\t%b\t%b\t%d\t%h\t%d\t%d\t%h\t%h", $time, rst_tb, we_tb, wr_addr_tb, wr_data_tb, rd_addr1_tb, rd_addr2_tb, rd_data1_tb, rd_data2_tb);

       // Test case 4: Đọc khi không ghi
        we_tb = 0;
        rd_addr1_tb = 0;
        rd_addr2_tb = 7;
        #10 $display("%0t\t%b\t%b\t%d\t%h\t%d\t%d\t%h\t%h", $time, rst_tb, we_tb, wr_addr_tb, wr_data_tb, rd_addr1_tb, rd_addr2_tb, rd_data1_tb, rd_data2_tb);

        #10 $finish; // Kết thúc mô phỏng
    end

    // Khởi tạo instance của module register_file
    register_file dut (
        .clk(clk_tb),
        .rst(rst_tb),
        .we(we_tb),
        .wr_addr(wr_addr_tb),
        .rd_addr1(rd_addr1_tb),
        .rd_addr2(rd_addr2_tb),
        .wr_data(wr_data_tb),
        .rd_data1(rd_data1_tb),
        .rd_data2(rd_data2_tb)
    );

endmodule
