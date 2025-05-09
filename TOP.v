//
//  |      | 
//  | PC   | -> pc_out ---------------->   addr -> |  ROM  |-> instruction ->   ir_in     -> |  IR   | -> operan ->   rd_addr1 -> |         | -> rd_data1 -> operand_a -> | ALU  |-
//  |      |                           ____________                                          |       |                rd_addr2 -> |         | -> rd_data2 -> operand_b -> |      |
//  |      |                          |            | -> ir_load --------------> ir_load   -> |       |                            |         |                             |      |            
//  |      |                          |            | <- op_code <----------------- dopcode <-|_______|                wr_addr  -> | R_file  |                             |      |
//  |      |                          |            |                                                                  wr_data  -> |         | <----------- alu_resulte <- |      |
//  |      | <- pc_in   <- pc_in   <- |            |                                                                              |         |                             |      |
//  |      | <- pc_load <- pc_load <- |            | -> refile_we --------------------------------------------------> we       -> |_________|                             |      |
//  |______| <- pc_en   <- pc_en   <- |            |                                                                                                                      |      |
//                                    |            | -> alu_op------------------------------------------------------------------------------------------------>alu_op  -> |______|
//                                    |            |  
//                                    |            |
//                                    |     CU     | 
//                                    |            |
//                                    |            |                              
//                                    |            |  
//                                    |            | -> mem_re ----------> re     -> |        |    
//                                    |            |                                 |        |           
//                                    |            | -> mem_we ----------> we     -> |  RAM   | ->data_out
//                                    |            |                       addr   -> |        |
//                                    |            |                       data_in-> |________|
//                                    |            |
//                                    |            |
//                                    |            |
//                                    |            |                   addr   -> |       |
//                                    |            |                             |       |
//                                    |            |                   we     -> |       | -> led 
//                                    |            |                  data_in -> | IO    | -> uart_tx_reg
//                                    |            |                             |       |
//                                    |            |                             |       |
//                                    |            |                  re      -> |       |
//                                    |            |                  button  -> |       | -> data_out
//                                    |            |                 uart_rx  -> |_______|      
//            
//     
//   tx_start   -> |      | -> tx_busy
//   tx_data    -> |      | -> tx
//                 | UART |
//   rx         -> |      | -> rx_data
//                 |______| -> rx_ready     
//      
//
//
//
//
//
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module cpu_top (
    input  wire        clk,
    input  wire        rst,
    input  wire        uart_rx,
    output wire        uart_tx
);

    // === Wires for interconnect ===
    wire [7:0] pc_out, instruction, ir_opcode, ir_operand1, ir_operand2;
    wire [7:0] reg_data1, reg_data2, alu_result;
    wire [7:0] mem_data_out, io_data_out;
    wire [7:0] io_data_in, mem_data_in;

    wire        regfile_we, mem_we, mem_re, ir_load;
    wire        pc_en, pc_load;
    wire [3:0]  alu_op;
    wire        zero_flag, carry_flag, overflow_flag;

    wire        io_we, io_re;
    wire [7:0]  io_addr;

    // === UART wires ===
    wire [7:0] uart_rx_data;
    wire       uart_rx_ready;
    wire       uart_tx_busy;
    wire [7:0] uart_tx_data;
    wire       uart_tx_start;

    // === ROM: Program Memory ===
    rom rom_inst (
        .addr(pc_out),
        .instruction(instruction)
    );

    // === Program Counter ===
    program_counter pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_en(pc_en),
        .pc_load(pc_load),
        .pc_in(alu_result),
        .pc_out(pc_out)
    );

    // === Instruction Register ===
    instruction_register ir_inst (
        .clk(clk),
        .rst(rst),
        .ir_load(ir_load),
        .ir_in(instruction),
        .opcode(ir_opcode),
        .operand1(ir_operand1),
        .operand2(ir_operand2)
    );

    // === Register File ===
    register_file regfile_inst (
        .clk(clk),
        .rst(rst),
        .we(regfile_we),
        .wr_addr(ir_operand1[2:0]),
        .rd_addr1(ir_operand1[2:0]),
        .rd_addr2(ir_operand2[2:0]),
        .wr_data(alu_result),
        .rd_data1(reg_data1),
        .rd_data2(reg_data2)
    );

    // === ALU ===
    alu alu_inst (
        .alu_op(alu_op),
        .operand_a(reg_data1),
        .operand_b(reg_data2),
        .alu_result(alu_result),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag)
    );

    // === RAM ===
    ram ram_inst (
        .clk(clk),
        .addr(ir_operand2),
        .we(mem_we),
        .re(mem_re),
        .data_in(reg_data2),
        .data_out(mem_data_out)
    );

    // === I/O (kết nối UART) ===
    io_uart_bridge io_inst (
        .clk(clk),
        .we(io_we),
        .re(io_re),
        .addr(io_addr),
        .data_in(reg_data2),
        .data_out(io_data_out),
        .tx_data(uart_tx_data),
        .tx_start(uart_tx_start),
        .tx_busy(uart_tx_busy),
        .rx_data(uart_rx_data),
        .rx_ready(uart_rx_ready)
    );

    // === UART ===
    uart uart_inst (
        .clk(clk),
        .rst(rst),
        .tx_data(uart_tx_data),
        .tx_start(uart_tx_start),
        .tx_busy(uart_tx_busy),
        .tx(uart_tx),
        .rx(uart_rx),
        .rx_data(uart_rx_data),
        .rx_ready(uart_rx_ready)
    );

    // === Control Unit ===
    control_unit cu_inst (
        .opcode(ir_opcode),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag),

        .alu_op(alu_op),
        .regfile_we(regfile_we),
        .pc_en(pc_en),
        .pc_load(pc_load),
        .ir_load(ir_load),
        .mem_we(mem_we),
        .mem_re(mem_re),
        .io_we(io_we),
        .io_re(io_re),
        .io_addr(ir_operand2)  // hoặc map từ opcode
    );

endmodule
