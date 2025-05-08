+-----------------+
|  Control Unit   |
|                 |
| Inputs:         |
| clk    ------>  | 
| rst    ------>  | 
| opcode[3:0] --> | ----> alu_op[3:0] ----> [ALU]
| zero_flag  -->  | ----> regfile_we -----> [Register File]
| carry_flag -->  | ----> pc_en ----------> [Program Counter]
| overflow_flag -> | ----> pc_load --------> [Program Counter]
|                 | ----> ir_load --------> [Instruction Register]
|                 | ----> mem_we ---------> [RAM]
|                 | ----> mem_re ---------> [RAM]
|                 | ----> io_we ----------> [IO Module]
|                 | ----> io_re ----------> [IO Module]
|                 | ----> sel_mux_reg_wr[1:0] -> [MUX_REG_WR]
|                 | ----> sel_mux_alu_a -----> [MUX_ALU_A]
|                 | ----> sel_mux_alu_b -----> [MUX_ALU_B]
+-----------------+
//
//
//
//
//
//
//
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module control_unit (
    input  wire [3:0] opcode,
    input  wire       zero,
    input  wire       carry,

    output reg  [2:0] alu_op,
    output reg        regfile_we,
    output reg        pc_en,
    output reg        pc_load,
    output reg        ir_load,
    output reg        mem_we,
    output reg        mem_re,
    output reg  [1:0] sel_mux_a,
    output reg  [1:0] sel_mux_b
);

    always @(*) begin
        // Mặc định
        alu_op     = 3'b000;
        regfile_we = 0;
        pc_en      = 0;
        pc_load    = 0;
        ir_load    = 1;
        mem_we     = 0;
        mem_re     = 0;
        sel_mux_a  = 2'b00;
        sel_mux_b  = 2'b00;

        case (opcode)
            4'b0000: begin // NOP
                pc_en = 1;
            end

            4'b0001: begin // LDI
                regfile_we = 1;
                sel_mux_a  = 2'b01; // chọn immediate
                pc_en = 1;
            end

            4'b0010: begin // MOV
                regfile_we = 1;
                sel_mux_a  = 2'b00; // chọn từ reg khác
                pc_en = 1;
            end

            4'b0011: begin // ADD
                regfile_we = 1;
                alu_op     = 3'b001;
                sel_mux_a  = 2'b10; // ALU input A
                sel_mux_b  = 2'b00; // ALU input B
                pc_en = 1;
            end

            4'b0100: begin // SUB
                regfile_we = 1;
                alu_op     = 3'b010;
                pc_en = 1;
            end

            4'b0101: begin // JMP
                pc_load = 1;
            end

            4'b0110: begin // JZ
                if (zero) pc_load = 1;
                else pc_en = 1;
            end

            4'b0111: begin // JC
                if (carry) pc_load = 1;
                else pc_en = 1;
            end

            4'b1000: begin // LOAD từ RAM vào thanh ghi
                mem_re = 1;
                regfile_we = 1;
                sel_mux_a = 2'b11; // từ RAM
                pc_en = 1;
            end

            4'b1001: begin // STORE từ thanh ghi vào RAM
                mem_we = 1;
                pc_en = 1;
            end

            default: begin
                pc_en = 1; // fallback
            end
        endcase
    end

endmodule
