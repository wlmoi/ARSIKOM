// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 1
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : tb_mux2to1_rv32i.v
// Deskripsi  : Testbench untuk MUX 2 ke 1 lebar 32 bit dengan selector

`timescale 1ns / 1ps

module tb_mux2to1_rv32i;
    reg [31:0] A_tb, B_tb;
    reg        Selector_tb;
    wire [31:0] Y_tb;

    // Instansiasi Unit Under Test (UUT)
        .A(A_tb),
        .B(B_tb),
        .Selector(Selector_tb),
        .Y(Y_tb)
    );

    initial begin
        $dumpfile("mux_sim.vcd");
        $dumpvars(0, tb_mux2to1_rv32i);

        // Kasus uji 1: Selector = 0, A ke Y
        A_tb = 32'h00000011; B_tb = 32'h00000022; Selector_tb = 0; #10;
        // Output diharapkan: 00000011

        // Kasus uji 2: Selector = 1, B ke Y
        Selector_tb = 1; #10;
        // Output diharapkan: 00000022

        // Kasus uji 3: Perubahan input dan Selector
        A_tb = 32'hABCDEF00; B_tb = 32'h12345678; Selector_tb = 0; #10;
        // Output diharapkan: ABCDEF00
        Selector_tb = 1; #10;
        // Output diharapkan: 12345678

        $display("Simulasi multiplexer selesai.");
        $finish;
    end

endmodule
