//   +ROM cung cấp chỉ-lệnh cho CPU thực thi, không thay đổi trong lúc chạy
//
//   +ROM thường dùng initial + $readmemh(...) để nạp lệnh ban đầu
//
//
//   + luồng : addr -> instruction
//
//
//
//
//          addr -> |  ROM  |-> instruction
//
//
//
//
//
//
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module rom (
    input  wire [7:0] addr,          // địa chỉ chương trình
    output reg  [7:0] instruction    // lệnh đầu ra
);

    // Bộ nhớ chương trình (ROM)
    reg [7:0] rom_mem [0:255];

    // Load dữ liệu từ file (chỉ dùng khi mô phỏng hoặc preload trên FPGA)
    initial begin
        $readmemh("program.hex", rom_mem);  // bạn có thể đổi sang .mem nếu cần
    end

    always @(*) begin
        instruction = rom_mem[addr];
    end

endmodule
