// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 1
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : tb_mux2to1_rv32i.v
// Deskripsi  : Testbench untuk multiplexer 2-ke-1 generik 32-bit

`timescale 1ns / 1ps

module tb_mux2to1_rv32i;

    // Deklarasi sinyal testbench
    reg [31:0] in0_tb, in1_tb;
    reg        sel_tb;
    wire [31:0] out_tb;

    // Instansiasi Unit Under Test (UUT)
    mux2to1_rv32i #(32) uut (
        .in0(in0_tb),
        .in1(in1_tb),
        .sel(sel_tb),
        .out(out_tb)
    );

    initial begin
        // Konfigurasi pencatatan waveform
        $dumpfile("mux_sim.vcd");
        $dumpvars(0, tb_mux2to1_rv32i);

        // Kasus uji: sel = 0, in0 ke out
        in0_tb = 32'hAAAAAAAA; in1_tb = 32'h55555555; sel_tb = 0; #10;
        // Kasus uji: sel = 1, in1 ke out
        sel_tb = 1; #10;
        // Kasus uji: Perubahan input saat sel = 0
        in0_tb = 32'h12345678; in1_tb = 32'hABCDEF01; sel_tb = 0; #10;
        // Kasus uji: Perubahan input saat sel = 1
        in0_tb = 32'h87654321; in1_tb = 32'hFEDCBA98; sel_tb = 1; #10;

        $display("Simulasi multiplexer selesai.");
        $finish;
    end

endmodule
