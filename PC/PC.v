//
//     module này cung cấp địa chỉ lệnh 
//
//
//    +luồng :  pc_en -> tăng địa chỉ + 1
//
//
//              pc_load -> nhảy tới địa chỉ  pc_in
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
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module program_counter (
    input  wire        clk,
    input  wire        rst,
    input  wire        pc_en,                // enable đếm
    input  wire        pc_load,              // load địa chỉ mới
    input  wire [7:0]  pc_in,                // địa chỉ mới cần load

    output reg  [7:0]  pc_out                // địa chỉ hiện tại
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out <= 8'b00000000;           // rst
        end else if (pc_load) begin
            pc_out <= pc_in;                 // Load địa chỉ nhảy
        end else if (pc_en) begin
            pc_out <= pc_out + 1;            // pc++
        end
    end

endmodule
