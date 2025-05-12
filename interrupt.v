// + luồng : irq_time | irq_uart_rx | irq_ext -> ir (báo ngắt)+ ir_vec(mã lệnh)
//
//
//      irq_time     - > |           | -> ir
//                       | interrupt | 
//      irq_uart_rx  - > |           | -> ir_vec
//                       |           |
//      irq_ext      - > |__________ |
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
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CODE CU
//input wire        irq,
//input wire [2:0]  irq_vec,
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//if (irq) begin
//    case (irq_vec)
//        3'b001: begin
            // xử lý timer interrupt
            // ví dụ: ghi UART "timeout", reset counter, v.v.
//        end
//        3'b010: begin
            // xử lý UART RX interrupt
//        end
//        3'b100: begin
            // xử lý ngắt ngoài (nút nhấn)
 //       end
 //       default: begin
            // fallback
//        end
//    endcase
//end else begin
    // xử lý theo opcode như thường
//end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module irq_controller(
    input  wire irq_timer,               // ngắt khi tie tràn
    input  wire irq_uart_rx,             // ngắt sau khi rx nhận xong 1 byte        
    input  wire irq_ext,                 // ngắt từ ngoại vi

            output reg  [2:0] irq_vec,   // mã xác định ngắt từ đâu, làm gì 
    output reg        irq                // ngắt , tạm dừng chương trình chính
); 
    always @(*) begin
                // Ưu tiên từ cao xuống thấp
        if (irq_timer) begin
            irq_vec = 3'b001;
            irq     = 1;
        end else if (irq_uart_rx) begin
            irq_vec = 3'b010;
            irq     = 1;
        end else if (irq_ext) begin
            irq_vec = 3'b100;
            irq     = 1;
        end else begin
            irq_vec = 3'b000;
            irq     = 0;
        end
    end
endmodule
