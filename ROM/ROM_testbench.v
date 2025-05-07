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
////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module rom_tb;

    // Các tín hiệu để kết nối với module rom
    reg  [7:0]       addr_tb;
    wire [7:0]      instruction_tb;

    // Khởi tạo các tín hiệu
    initial begin
        addr_tb = 8'h00;
    end

    // Khởi tạo instance của module rom
    rom dut (
        .addr(addr_tb),
        .instruction(instruction_tb)
    );

    // Test
    initial begin
        // In tiêu đề
        $display("Time\tAddr\tInstruction");
        $display("--------------------------");

        // Test case 1: Đọc địa chỉ 0
        addr_tb = 8'h00;
        #10 $display("%0t\t%h\t%h", $time, addr_tb, instruction_tb);

        // Test case 2: Đọc địa chỉ 1
        addr_tb = 8'h01;
        #10 $display("%0t\t%h\t%h", $time, addr_tb, instruction_tb);

        // Test case 3: Đọc địa chỉ 10
        addr_tb = 8'h0A;
        #10 $display("%0t\t%h\t%h", $time, addr_tb, instruction_tb);

       // Test case 4: Đọc địa chỉ 255
        addr_tb = 8'hFF;
        #10 $display("%0t\t%h\t%h", $time, addr_tb, instruction_tb);

        #10 $finish;
    end

endmodule
