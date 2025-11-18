// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 3
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : tb_pc_rv32i.v
// Deskripsi  : Testbench untuk Program Counter 32-bit

`timescale 1ns / 1ps

module tb_pc_rv32i;

    // Deklarasi sinyal testbench
    reg        clk_tb;
    reg        reset_tb;
    reg [31:0] next_pc_tb;
    wire [31:0] pc_tb;

    // Instansiasi Unit Under Test (UUT)
    pc_rv32i uut (
        .clk(clk_tb),
        .reset(reset_tb),
        .next_pc(next_pc_tb),
        .pc(pc_tb)
    );

    // Generasi clock
    initial begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb; // Perioda clock 10ns
    end

    initial begin
        // Konfigurasi pencatatan waveform
        $dumpfile("pc_sim.vcd");
        $dumpvars(0, tb_pc_rv32i);

        // Inisialisasi: aktifkan reset
        reset_tb   = 1;
        next_pc_tb = 32'h1000; #10; // PC harus 0 karena reset

        // Nonaktifkan reset, amati pembaruan PC
        reset_tb   = 0;
        #10; // PC akan jadi 0, lalu pada posedge clk berikutnya jadi 0x1000
        next_pc_tb = 32'h1004; #10; // Harapannya: PC = 0x1004
        next_pc_tb = 32'h1008; #10; // Harapannya: PC = 0x1008

        // Skenario lompat/cabang
        next_pc_tb = 32'hC000; #10; // Harapannya: PC = 0xC000
        next_pc_tb = 32'hC004; #10; // Harapannya: PC = 0xC004

        // Aktifkan reset kembali
        reset_tb   = 1; #10; // Harapannya: PC = 0

        $display("Simulasi Program Counter selesai.");
        $finish;
    end

endmodule
