//  + sau khi lấy lệnh ,lệnh tách ra thành  opcode, operand để xử lý bước tiếp theo .
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
//  ir_load ->|  IR   | -> opcode
//  ir_in   ->|_______| -> operand
//
//
//
//
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module instruction_register (
    input  wire       clk,
    input  wire       rst,
    input  wire       ir_load,       //tín hiệu nhận lệnh
  input  wire [7:0] ir_in,           // lệnh

    output reg  [3:0] opcode,
    output reg  [3:0] operand
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            opcode  <= 4'b0000;
            operand <= 4'b0000;
        end else if (ir_load) begin
            opcode  <= ir_in[7:4];
            operand <= ir_in[3:0];
        end
    end

endmodule
