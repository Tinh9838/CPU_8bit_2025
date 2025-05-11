//
//   kịch bản   :   + khởi tạo module testbench
//
//                  + tạo bản sao alu 
//
//                  + mỗi phép tính trên alu lấy 1 vd cụ thể
//
//
//
//     | STT | Phép toán      | `alu_op` | `A (operand_a)` | `B (operand_b)` | Mục tiêu kiểm tra                                           |
//     | --- | -------------- | -------- | --------------- | --------------- | ----------------------------------------------------------- |
//     | 1   | ADD            | `0000`   | `0x05`          | `0x0A`          | Kiểm tra phép cộng cơ bản, không carry, không overflow      |
//     | 2   | ADD (carry)    | `0000`   | `0xFF`          | `0x01`          | Kiểm tra carry flag khi tổng vượt 8 bit                     |
//     | 3   | ADD (overflow) | `0000`   | `0x7F`          | `0x01`          | Kiểm tra overflow khi dương + dương → âm (signed overflow)  |
//     | 4   | SUB            | `0001`   | `0x0A`          | `0x05`          | Kiểm tra phép trừ cơ bản, không borrow, không overflow      |
//     | 5   | SUB (borrow)   | `0001`   | `0x05`          | `0x0A`          | Kiểm tra borrow (có thể kiểm tra carry hoặc bit mượn)       |
//     | 6   | SUB (overflow) | `0001`   | `0x80`          | `0x01`          | Kiểm tra overflow khi âm - dương → dương (signed overflow)  |
//     | 7   | AND            | `0010`   | `0x0F`          | `0x3C`          | Kiểm tra phép AND bitwise                                   |
//     | 8   | OR             | `0011`   | `0x0F`          | `0x3C`          | Kiểm tra phép OR bitwise                                    |
//     | 9   | XOR            | `0100`   | `0x0F`          | `0x3C`          | Kiểm tra phép XOR bitwise                                   |
//     | 10  | NOT            | `0101`   | `0x55`          | `0x00`          | Kiểm tra phép NOT (B không ảnh hưởng)                       |
//     | 11  | SHL            | `0110`   | `0x0A`          | `0x00`          | Kiểm tra dịch trái 1 bit                                    |
//     | 12  | SHR            | `0111`   | `0xA0`          | `0x00`          | Kiểm tra dịch phải 1 bit                                    |
//     | 13  | CMP (=)        | `1000`   | `0x12`          | `0x12`          | So sánh bằng nhau, kiểm tra zero flag                       |
//     | 14  | CMP (≠)        | `1000`   | `0x12`          | `0x34`          | So sánh khác nhau, kiểm tra zero flag = 0                   |
//     | 15  | Mặc định       | `1111`   | `0xAA`          | `0xBB`          | Kiểm tra xử lý opcode không xác định (default case của ALU) |
//
//
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module alu_tb;                                                                          // module testbench

    reg [3:0] alu_op_tb;
    reg [7:0] operand_a_tb;
    reg [7:0] operand_b_tb;
    wire [7:0] alu_result_tb;
    wire zero_flag_tb;
    wire carry_flag_tb;
    wire overflow_flag_tb;

                                                                                       // Khởi tạo instance của module alu        //dut (device under test)   // bản sao của alu
    alu dut (
        .alu_op(alu_op_tb),
        .operand_a(operand_a_tb),
        .operand_b(operand_b_tb),
        .alu_result(alu_result_tb),
        .zero_flag(zero_flag_tb),
        .carry_flag(carry_flag_tb),
        .overflow_flag(overflow_flag_tb)
    );

    initial begin                                                                      // mỗi phép toán lấy 1 vd, in ra màn hình sau mỗi ví dụ
        // In tiêu đề của bảng kết quả
        $display("Time\tALU Op\tA\tB\tResult\tZero\tCarry\tOverflow");
        $display("------------------------------------------------------------");

        // Test case 1: Phép cộng (ADD)
        alu_op_tb = 4'b0000;
        operand_a_tb = 8'h05;
        operand_b_tb = 8'h0A;
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 2: Phép cộng có carry
        alu_op_tb = 4'b0000;
        operand_a_tb = 8'hFF;
        operand_b_tb = 8'h01;
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 3: Phép cộng có overflow (số dương + số dương = số âm)
        alu_op_tb = 4'b0000;
        operand_a_tb = 8'h7F; // 127
        operand_b_tb = 8'h01; // 1
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 4: Phép trừ (SUB)
        alu_op_tb = 4'b0001;
        operand_a_tb = 8'h0A;
        operand_b_tb = 8'h05;
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 5: Phép trừ có borrow
        alu_op_tb = 4'b0001;
        operand_a_tb = 8'h05;
        operand_b_tb = 8'h0A;
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 6: Phép trừ có overflow (số âm - số dương = số dương)
        alu_op_tb = 4'b0001;
        operand_a_tb = 8'h80; // -128
        operand_b_tb = 8'h01; // 1
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 7: Phép AND
        alu_op_tb = 4'b0010;
        operand_a_tb = 8'h0F;
        operand_b_tb = 8'h3C;
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 8: Phép OR
        alu_op_tb = 4'b0011;
        operand_a_tb = 8'h0F;
        operand_b_tb = 8'h3C;
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 9: Phép XOR
        alu_op_tb = 4'b0100;
        operand_a_tb = 8'h0F;
        operand_b_tb = 8'h3C;
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 10: Phép NOT
        alu_op_tb = 4'b0101;
        operand_a_tb = 8'h55;
        operand_b_tb = 8'h00; // B không ảnh hưởng
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 11: Phép SHL
        alu_op_tb = 4'b0110;
        operand_a_tb = 8'h0A;
        operand_b_tb = 8'h00; // B không ảnh hưởng
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 12: Phép SHR
        alu_op_tb = 4'b0111;
        operand_a_tb = 8'hA0;
        operand_b_tb = 8'h00; // B không ảnh hưởng
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 13: Phép CMP (bằng nhau)
        alu_op_tb = 4'b1000;
        operand_a_tb = 8'h12;
        operand_b_tb = 8'h12;
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 14: Phép CMP (khác nhau)
        alu_op_tb = 4'b1000;
        operand_a_tb = 8'h12;
        operand_b_tb = 8'h34;
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        // Test case 15: Trường hợp default
        alu_op_tb = 4'b1111;
        operand_a_tb = 8'hAA;
        operand_b_tb = 8'hBB;
        #10 $display("%0t\t%b\t%h\t%h\t%h\t%b\t%b\t%b", $time, alu_op_tb, operand_a_tb, operand_b_tb, alu_result_tb, zero_flag_tb, carry_flag_tb, overflow_flag_tb);

        #10 $finish; // Kết thúc mô phỏng
    end

endmodule
