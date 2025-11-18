// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 1
// Tanggal    : 17 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : mux2to1_rv32i.v
// Deskripsi  : 32-bit 2-to-1 Multiplexer

module mux2to1_rv32i #(parameter WIDTH = 32) (
    input  wire [WIDTH-1:0] in0,
    input  wire [WIDTH-1:0] in1,
    input  wire sel,
    output wire [WIDTH-1:0] out
);
    assign out = sel ? in1 : in0;
endmodule
