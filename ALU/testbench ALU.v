//      3 bước  :   + khởi tạo module testbench
//
//                  + tạo bản sao alu 
//
//                  + mỗi phép tính trên alu lấy 1 vd cụ thể
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
