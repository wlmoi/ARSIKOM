// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 2
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : tb_pc_4_adder_rv32i.v
// Deskripsi  : Testbench untuk 4-adder 32-bit

`timescale 1ns / 1ps

module tb_pc_4_adder_rv32i;

    // Deklarasi sinyal testbench
    reg [31:0] PCold_tb;
    wire [31:0] PC_4_inc_tb;

    // Instansiasi Unit Under Test (UUT)
    pc_4_adder_rv32i uut (
        .PCold(PCold_tb),
        .PC_4_inc(PC_4_inc_tb)
    );

    initial begin
        // Konfigurasi pencatatan waveform
        $dumpfile("adder_sim.vcd");
        $dumpvars(0, tb_pc_4_adder_rv32i);

        // Kasus uji: PCold = 0
        PCold_tb = 32'h00000000; #10; // Harapannya: PC_4_inc = 0x00000004
        // Kasus uji: PCold = 0x00000004
        PCold_tb = 32'h00000004; #10; // Harapannya: PC_4_inc = 0x00000008
        // Kasus uji: PCold mendekati nilai maksimum (wrap-around)
        PCold_tb = 32'hFFFFFFFC; #10; // Harapannya: PC_4_inc = 0x00000000
        // Kasus uji: Nilai acak
        PCold_tb = 32'h12345678; #10; // Harapannya: PC_4_inc = 0x1234567C

        $display("Simulasi 4-adder selesai.");
        $finish;
    end

endmodule
