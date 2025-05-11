// kịch bản   + khởi tạo module tb
//            + tạo clk
//            + tạo rst bỏ sau # 20
//            + kích các 2 tín hiệu vào xem xét lệnh pc++ và nhảy có hoạt động đúng ko :
//                                  tình huống 1 chỉ rst,2 chỉ pc_en,3 chỉ pc_load ,4 vừa pc_en và pc_load (kết quả vẫn ưu tiên load),5 tắt pc_load
//
//
//      Time    Reset   PC_En  PC_Load PC_In  PC_Out
//     --------------------------------------------------
//     20      1       0      0       00     00
//     30      0       1      0       00     01
//     40      0       1      0       00     02
//     50      0       0      1       55     55
//     60      0       1      0       AA     55
//     70      0       1      0       00     56
//     80      0       0      0       00     56
//
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module program_counter_tb;

    // Các tín hiệu để kết nối với module program_counter
    reg            clk_tb;
    reg            rst_tb;
    reg            pc_en_tb;
    reg            pc_load_tb;
    reg [7:0]      pc_in_tb;
    wire [7:0]      pc_out_tb;

    // Khởi tạo clock
    initial begin
        clk_tb = 0;
        forever #10 clk_tb = ~clk_tb;  // Tạo xung clock với chu kỳ 20ns
    end

    // Khởi tạo các tín hiệu khác và tiến hành test
    initial begin
        rst_tb = 1;     // Khởi tạo reset
        pc_en_tb = 0;
        pc_load_tb = 0;
        pc_in_tb = 8'h00;

        // In tiêu đề của bảng kết quả
        $display("Time\tReset\tPC_En\tPC_Load\tPC_In\tPC_Out");
        $display("--------------------------------------------------");

        #20 rst_tb = 0;    // Bỏ reset sau 20ns

        // Test case 1: Chỉ reset
        #10 $display("%0t\t%b\t%b\t%b\t%h\t%h", $time, rst_tb, pc_en_tb, pc_load_tb, pc_in_tb, pc_out_tb);

        // Test case 2: Chỉ enable đếm
        pc_en_tb = 1;
        #10 $display("%0t\t%b\t%b\t%b\t%h\t%h", $time, rst_tb, pc_en_tb, pc_load_tb, pc_in_tb, pc_out_tb);
        #10 $display("%0t\t%b\t%b\t%b\t%h\t%h", $time, rst_tb, pc_en_tb, pc_load_tb, pc_in_tb, pc_out_tb);

        // Test case 3: Load địa chỉ mới
        pc_load_tb = 1;
        pc_in_tb = 8'h55;
        #10 $display("%0t\t%b\t%b\t%b\t%h\t%h", $time, rst_tb, pc_en_tb, pc_load_tb, pc_in_tb, pc_out_tb);

        // Test case 4: Vừa load địa chỉ mới, vừa enable đếm (ưu tiên load)
        pc_en_tb = 1;
        pc_in_tb = 8'hAA;  // Giá trị này bị bỏ qua vì pc_load_tb đang active
        #10 $display("%0t\t%b\t%b\t%b\t%h\t%h", $time, rst_tb, pc_en_tb, pc_load_tb, pc_in_tb, pc_out_tb);

        // Test case 5: Chỉ enable đếm sau khi load
        pc_load_tb = 0;
        #10 $display("%0t\t%b\t%b\t%b\t%h\t%h", $time, rst_tb, pc_en_tb, pc_load_tb, pc_in_tb, pc_out_tb);
        #10 $display("%0t\t%b\t%b\t%b\t%h\t%h", $time, rst_tb, pc_en_tb, pc_load_tb, pc_in_tb, pc_out_tb);

        #10 $finish;    // Kết thúc mô phỏng
    end

    // Khởi tạo instance của module program_counter
    program_counter dut (
        .clk(clk_tb),
        .rst(rst_tb),
        .pc_en(pc_en_tb),
        .pc_load(pc_load_tb),
        .pc_in(pc_in_tb),
        .pc_out(pc_out_tb)
    );

endmodule
