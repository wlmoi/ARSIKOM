// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 3
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : pc_rv32i.v
// Deskripsi  : 32-bit Program Counter for Single-Cycle RV32I

module pc_rv32i (
    input  wire        clk,
    input  wire        reset, // Active high asynchronous reset
    input  wire [31:0] next_pc,
    output reg  [31:0] pc
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'h0; // Initialize PC to 0 on active high asynchronous reset
        end else begin
            pc <= next_pc; // Update PC with the next_pc value
        end
    end

endmodule
