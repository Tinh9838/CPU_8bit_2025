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
/////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module ram_tb;

    // Các tín hiệu để kết nối với module ram
    reg             clk_tb;
    reg [7:0]       addr_tb;
    reg             we_tb;
    reg             re_tb;
    reg [7:0]       data_in_tb;
    wire [7:0]      data_out_tb;

    // Khởi tạo clock
    initial begin
        clk_tb = 0;
        forever #10 clk_tb = ~clk_tb;  // Tạo xung clock với chu kỳ 20ns
    end

    // Khởi tạo các tín hiệu khác và tiến hành test
    initial begin
        we_tb     = 0;
        re_tb     = 0;
        addr_tb   = 8'h00;
        data_in_tb = 8'h00;

        // In tiêu đề của bảng kết quả
        $display("Time\tAddr\tWE\tRE\tDataIn\tDataOut");
        $display("------------------------------------------");

        // Test case 1: Ghi vào địa chỉ 0, đọc địa chỉ 0
        we_tb     = 1;
        re_tb     = 0;
        addr_tb   = 8'h00;
        data_in_tb = 8'h55;
        #10 $display("%0t\t%h\t%b\t%b\t%h\t%h", $time, addr_tb, we_tb, re_tb, data_in_tb, data_out_tb);

        we_tb     = 0;
        re_tb     = 1;
        #10 $display("%0t\t%h\t%b\t%b\t%h\t%h", $time, addr_tb, we_tb, re_tb, data_in_tb, data_out_tb);


        // Test case 2: Ghi vào địa chỉ 1, đọc địa chỉ 0 và 1
        we_tb     = 1;
        re_tb     = 0;
        addr_tb   = 8'h01;
        data_in_tb = 8'hAA;
        #10 $display("%0t\t%h\t%b\t%b\t%h\t%h", $time, addr_tb, we_tb, re_tb, data_in_tb, data_out_tb);

        we_tb     = 0;
        re_tb     = 1;
        addr_tb   = 8'h00;
        #10 $display("%0t\t%h\t%b\t%b\t%h\t%h", $time, addr_tb, we_tb, re_tb, data_in_tb, data_out_tb);
        addr_tb   = 8'h01;
        #10 $display("%0t\t%h\t%b\t%b\t%h\t%h", $time, addr_tb, we_tb, re_tb, data_in_tb, data_out_tb);

        // Test case 3: Ghi vào địa chỉ 2, đọc địa chỉ 0, 1, 2
        we_tb     = 1;
        re_tb     = 0;
        addr_tb   = 8'h02;
        data_in_tb = 8'hFF;
        #10 $display("%0t\t%h\t%b\t%b\t%h\t%h", $time, addr_tb, we_tb, re_tb, data_in_tb, data_out_tb);

        we_tb     = 0;
        re_tb     = 1;
        addr_tb   = 8'h00;
        #10 $display("%0t\t%h\t%b\t%b\t%h\t%h", $time, addr_tb, we_tb, re_tb, data_in_tb, data_out_tb);
        addr_tb   = 8'h01;
        #10 $display("%0t\t%h\t%b\t%b\t%h\t%h", $time, addr_tb, we_tb, re_tb, data_in_tb, data_out_tb);
        addr_tb   = 8'h02;
        #10 $display("%0t\t%h\t%b\t%b\t%h\t%h", $time, addr_tb, we_tb, re_tb, data_in_tb, data_out_tb);

        // Test case 4: Chỉ đọc (không ghi)
        we_tb     = 0;
        re_tb     = 1;
        addr_tb   = 8'h01;  // Đọc lại địa chỉ 1
        #10 $display("%0t\t%h\t%b\t%b\t%h\t%h", $time, addr_tb, we_tb, re_tb, data_in_tb, data_out_tb);

        // Test case 5: Ghi và đọc trên cùng một địa chỉ trong cùng một chu kỳ
        we_tb     = 1;
        re_tb     = 1;
        addr_tb   = 8'h03;
        data_in_tb = 8'h12;
        #10 $display("%0t\t%h\t%b\t%b\t%h\t%h", $time, addr_tb, we_tb, re_tb, data_in_tb, data_out_tb);

        #10 $finish;    // Kết thúc mô phỏng
    end

    // Khởi tạo instance của module ram
    ram dut (
        .clk(clk_tb),
        .addr(addr_tb),
        .we(we_tb),
        .re(re_tb),
        .data_in(data_in_tb),
        .data_out(data_out_tb)
    );

endmodule
