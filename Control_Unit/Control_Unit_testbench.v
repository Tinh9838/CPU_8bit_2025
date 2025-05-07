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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module control_unit_tb;

    // Inputs to control_unit
    reg  [3:0]  opcode_tb;
    reg          zero_tb;
    reg          carry_tb;

    // Outputs from control_unit
    wire [2:0]  alu_op_tb;
    wire         regfile_we_tb;
    wire         pc_en_tb;
    wire         pc_load_tb;
    wire         ir_load_tb;
    wire         mem_we_tb;
    wire         mem_re_tb;
    wire [1:0]  sel_mux_a_tb;
    wire [1:0]  sel_mux_b_tb;

    // Instantiate the control_unit
    control_unit dut (
        .opcode(opcode_tb),
        .zero(zero_tb),
        .carry(carry_tb),
        .alu_op(alu_op_tb),
        .regfile_we(regfile_we_tb),
        .pc_en(pc_en_tb),
        .pc_load(pc_load_tb),
        .ir_load(ir_load_tb),
        .mem_we(mem_we_tb),
        .mem_re(mem_re_tb),
        .sel_mux_a(sel_mux_a_tb),
        .sel_mux_b(sel_mux_b_tb)
    );

    // Helper task to display the signals
    task display_signals;
        begin
            $display(
                "Time:%0t Opcode:%b zero:%b carry:%b | alu_op:%b regfile_we:%b pc_en:%b pc_load:%b ir_load:%b mem_we:%b mem_re:%b sel_mux_a:%b sel_mux_b:%b",
                $time, opcode_tb, zero_tb, carry_tb,
                alu_op_tb, regfile_we_tb, pc_en_tb, pc_load_tb, ir_load_tb, mem_we_tb, mem_re_tb, sel_mux_a_tb, sel_mux_b_tb
            );
        end
    endtask

    // Main testbench logic
    initial begin
        // Initialize inputs
        opcode_tb = 4'b0000;
        zero_tb   = 0;
        carry_tb  = 0;

        // Print header
        $display("----------------------------------------------------------------------------------------------------------------------------------------------------------");
        $display("                                                              Control Unit Testbench");
        $display("----------------------------------------------------------------------------------------------------------------------------------------------------------");
        $display("Time  Opcode  zero  carry  |  alu_op  regfile_we  pc_en  pc_load  ir_load  mem_we  mem_re  sel_mux_a  sel_mux_b");
        $display("----------------------------------------------------------------------------------------------------------------------------------------------------------");

        // Test Cases
        #10 display_signals();  // Initial state

        // Test NOP
        opcode_tb = 4'b0000;
        #10 display_signals();

        // Test LDI
        opcode_tb = 4'b0001;
        #10 display_signals();

        // Test MOV
        opcode_tb = 4'b0010;
        #10 display_signals();

        // Test ADD
        opcode_tb = 4'b0011;
        #10 display_signals();

        // Test SUB
        opcode_tb = 4'b0100;
        #10 display_signals();

        // Test JMP
        opcode_tb = 4'b0101;
        #10 display_signals();

        // Test JZ (zero = 0)
        opcode_tb = 4'b0110;
        zero_tb   = 0;
        #10 display_signals();

        // Test JZ (zero = 1)
        opcode_tb = 4'b0110;
        zero_tb   = 1;
        #10 display_signals();

        // Test JC (carry = 0)
        opcode_tb = 4'b0111;
        carry_tb  = 0;
        #10 display_signals();

        // Test JC (carry = 1)
        opcode_tb = 4'b0111;
        carry_tb  = 1;
        #10 display_signals();

        // Test LOAD
        opcode_tb = 4'b1000;
        #10 display_signals();

        // Test STORE
        opcode_tb = 4'b1001;
        #10 display_signals();

        // Test DEFAULT
        opcode_tb = 4'b1111;
        #10 display_signals();

        #10 $finish;
    end

endmodule
