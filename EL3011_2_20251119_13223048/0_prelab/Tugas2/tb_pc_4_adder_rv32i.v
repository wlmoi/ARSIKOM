// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 2
// Tanggal    : 17 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : tb_pc_4_adder_rv32i.v
// Deskripsi  : Testbench for 32-bit Adder (PCold + 4)

`timescale 1ns / 1ps

module tb_pc_4_adder_rv32i;

    // Inputs
    reg [31:0] PCold;

    // Outputs
    wire [31:0] PC_4_inc;

    // Instantiate the Unit Under Test (UUT)
    pc_4_adder_rv32i uut (
        .PCold(PCold),
        .PC_4_inc(PC_4_inc)
    );

    initial begin
        // Initialize PCold
        PCold = 32'h00000000;
        #10;
        // Expected: PC_4_inc = 00000004

        // Test Case 1: PCold = 0x00000004
        PCold = 32'h00000004;
        #10;
        // Expected: PC_4_inc = 00000008

        // Test Case 2: PCold = 0xFFFFFFFC (wraps around)
        PCold = 32'hFFFFFFFC;
        #10;
        // Expected: PC_4_inc = 00000000

        // Test Case 3: Arbitrary value
        PCold = 32'h12345678;
        #10;
        // Expected: PC_4_inc = 1234567C

        // Test Case 4: Another arbitrary value
        PCold = 32'hABCDEF01;
        #10;
        // Expected: PC_4_inc = ABCDEF05

        $display("Simulation finished.");
        $finish;
    end

endmodule
