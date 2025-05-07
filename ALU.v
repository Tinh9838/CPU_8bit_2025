//       + module này dùng lệnh case chọn cách thực hiện phép tính giữa 2 toán tử operrand a và operrand b
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
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module alu (
    input  wire [3:0] alu_op,       // mã lệnh: chọn phép toán
    input  wire [7:0] operand_a,    // toán hạng A
    input  wire [7:0] operand_b,    // toán hạng B

    output reg  [7:0] alu_result,   // kết quả ALU
    output wire       zero_flag,    // cờ kết quả bằng 0
    output reg        carry_flag,   // cờ nhớ (carry)
    output reg        overflow_flag // cờ tràn (overflow)
);

    wire [8:0] sum = operand_a + operand_b;
    wire [8:0] sub = operand_a - operand_b;

    always @(*) begin
        carry_flag     = 0;
        overflow_flag  = 0;
        alu_result     = 8'h00;

        case (alu_op)
            4'b0000: begin // ADD
                alu_result    = sum[7:0];
                carry_flag    = sum[8];
                overflow_flag = (~operand_a[7] & ~operand_b[7] & alu_result[7]) |
                                ( operand_a[7] &  operand_b[7] & ~alu_result[7]);
            end

            4'b0001: begin // SUB
                alu_result    = sub[7:0];
                carry_flag    = sub[8]; // borrow
                overflow_flag = (~operand_a[7] &  operand_b[7] & alu_result[7]) |
                                ( operand_a[7] & ~operand_b[7] & ~alu_result[7]);
            end

            4'b0010: alu_result = operand_a & operand_b; // AND
            4'b0011: alu_result = operand_a | operand_b; // OR
            4'b0100: alu_result = operand_a ^ operand_b; // XOR
            4'b0101: alu_result = ~operand_a;            // NOT (chỉ A)
            4'b0110: alu_result = operand_a << 1;        // SHL
            4'b0111: alu_result = operand_a >> 1;        // SHR
            4'b1000: alu_result = (operand_a == operand_b) ? 8'b1 : 8'b0; // CMP (=)

            default: alu_result = 8'h00;
        endcase
    end

    assign zero_flag = (alu_result == 8'b00000000);

endmodule
