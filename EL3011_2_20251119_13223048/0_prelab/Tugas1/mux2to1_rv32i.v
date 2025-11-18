// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 1
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : mux2to1_rv32i.v
// Deskripsi  : Desain multiplexer 2-ke-1 generik 32-bit

module mux2to1_rv32i (
    input wire [31:0] A, 
    input wire [31:0] B,  
    input wire Selector,   
    output reg [31:0] Y 
);

    always @(*) begin
        if (Selector == 1'b0) begin
            Y = A; 
        end
        else begin
            Y = B; 
        end
    end

endmodule