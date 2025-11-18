// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 2
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : pc_4_adder_rv32i.v
// Deskripsi  : Desain 4-adder 32-bit untuk perhitungan PCin + 4

module pc_4_adder_rv32i (
    input  wire [31:0] PCin,      // Program lama
    output wire [31:0] PCout    // PCin + 4
);
    assign PCout = PCin + 32'd4; // Penjumlahan PCin dengan 4
endmodule
