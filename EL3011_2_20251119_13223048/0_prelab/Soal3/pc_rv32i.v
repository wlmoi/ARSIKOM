// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 3
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : pc_rv32i.v
// Deskripsi  : Desain Program Counter (PC) 32-bit untuk RV32I

module pc_rv32i (
    input wire clk,
    input wire reset, 
    input wire [31:0] PCin,         
    output reg [31:0] PCout 
);
    always @(posedge clk or negedge reset) begin
        if (reset == 1'b0) begin
            PCout <= 32'h0;
        end
        else begin
            PCout <= PCin;
        end
    end
endmodule
