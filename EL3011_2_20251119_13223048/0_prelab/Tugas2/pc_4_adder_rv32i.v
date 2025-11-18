// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 2
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : pc_4_adder_rv32i.v
// Deskripsi  : 32-bit Adder to calculate PCold + 4

module pc_4_adder_rv32i (
    input  wire [31:0] PCold,
    output wire [31:0] PC_4_inc
);
    // Add 4 to PCold
    assign PC_4_inc = PCold + 32'd4;
endmodule
