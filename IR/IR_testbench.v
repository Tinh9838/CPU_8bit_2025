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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module instruction_register_tb;

    // Các tín hiệu để kết nối với module instruction_register
    reg             clk_tb;
    reg             rst_tb;
    reg             ir_load_tb;
    reg [7:0]       ir_in_tb;
    wire [3:0]      opcode_tb;
    wire [3:0]      operand_tb;

    // Khởi tạo clock
    initial begin
        clk_tb = 0;
        forever #10 clk_tb = ~clk_tb;  // Tạo xung clock với chu kỳ 20ns
    end

    // Khởi tạo các tín hiệu khác và tiến hành test
    initial begin
        rst_tb = 1;      // Khởi tạo reset
        ir_load_tb = 0;
        ir_in_tb = 8'h00;

        // In tiêu đề của bảng kết quả
        $display("Time\tReset\tIR_Load\tIR_In\tOpcode\tOperand");
        $display("--------------------------------------------------");

        #20 rst_tb = 0;    // Bỏ reset sau 20ns

        // Test case 1: Chỉ reset
        #10 $display("%0t\t%b\t%b\t%h\t%h\t%h", $time, rst_tb, ir_load_tb, ir_in_tb, opcode_tb, operand_tb);

        // Test case 2: Load instruction
        ir_load_tb = 1;
        ir_in_tb = 8'hAF;  // Opcode = A, Operand = F
        #10 $display("%0t\t%b\t%b\t%h\t%h\t%h", $time, rst_tb, ir_load_tb, ir_in_tb, opcode_tb, operand_tb);

        // Test case 3: Load another instruction
        ir_in_tb = 8'h3C;  // Opcode = 3, Operand = C
        #10 $display("%0t\t%b\t%b\t%h\t%h\t%h", $time, rst_tb, ir_load_tb, ir_in_tb, opcode_tb, operand_tb);

        // Test case 4: Disable load, change input (shouldn't affect output)
        ir_load_tb = 0;
        ir_in_tb = 8'h05;
        #10 $display("%0t\t%b\t%b\t%h\t%h\t%h", $time, rst_tb, ir_load_tb, ir_in_tb, opcode_tb, operand_tb);

        #10 $finish;    // Kết thúc mô phỏng
    end

    // Khởi tạo instance của module instruction_register
    instruction_register dut (
        .clk(clk_tb),
        .rst(rst_tb),
        .ir_load(ir_load_tb),
        .ir_in(ir_in_tb),
        .opcode(opcode_tb),
        .operand(operand_tb)
    );

endmodule
