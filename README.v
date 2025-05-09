

//       addr   -> |        |
//       we     -> |  RAM   | ->data_out
//       re     -> |        |
//       data_in-> |________|

//          addr -> |  ROM  |-> instruction

//    pc_en  -> |      | 
//              | PC   | -> pc_out
//    pc_load ->|      |
//    pc_in   ->|______|

//  ir_load ->|  IR   | -> opcode
//  ir_in   ->|_______| -> operand

//      we       -> |         |
//      wr_addr  -> | R_file  |
//      wr_data     |         |
//                  |         |
//      rd_addr1 -> |         | -> rd_data1
//      rd_addr2 -> |_________| -> rd_data2

//                       alu_op     ->|      |
//                       operand_a  ->| ALU  |-> alu_resulte     
//                       operand_a  ->|______|

//                        |            | -> pc_en
//                        |            | -> pc_load
//     op_code ->         |            | 
//                        |            | -> ir_load
//                        |            |
//                        |     CU     | -> refile_we
//                        |            |
//                        |            | -> alu_op
//                        |            |
//                        |            | -> mem_re
//                        |            |
//                        |____________| -> mem_we

//   tx_start   -> |      | -> tx_busy
//   tx_data    -> |      | -> tx
//                 | UART |
//   rx         -> |      | -> rx_data
//                 |______| -> rx_ready

//
//    addr   -> |       |
//              |       |
//    we     -> |       | -> led 
//   data_in -> | IO    | -> uart_tx_reg
//              |       |
//              |       |
//   re      -> |       |
//   button  -> |       | -> data_out
//  uart_rx  -> |_______|


