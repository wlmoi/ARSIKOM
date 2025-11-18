// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 3
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : pc_rv32i.v
// Deskripsi  : Desain Program Counter (PC) 32-bit untuk RV32I

module pc_rv32i (
    input  wire        clk,      // Sinyal clock
    input  wire        reset,    // Sinyal reset (asinkron aktif-tinggi)
    input  wire [31:0] next_pc,  // Alamat PC selanjutnya
    output reg  [31:0] pc        // Output Program Counter
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'h0;      // Reset PC ke 0
        end else begin
            pc <= next_pc;    // Perbarui PC pada tepi naik clock
        end
    end

endmodule
