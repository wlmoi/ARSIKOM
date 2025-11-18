// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 1
// Tanggal    : 17 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : tb_mux2to1_rv32i.v
// Deskripsi  : Testbench for 32-bit 2-to-1 Multiplexer

`timescale 1ns / 1ps

module tb_mux2to1_rv32i;

    // Parameters
    parameter WIDTH = 32;

    // Inputs
    reg [WIDTH-1:0] in0;
    reg [WIDTH-1:0] in1;
    reg             sel;

    // Outputs
    wire [WIDTH-1:0] out;

    // Instantiate the Unit Under Test (UUT)
    mux2to1_rv32i #(WIDTH) uut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );

    initial begin
        // Initialize Inputs
        in0 = 32'h00000000;
        in1 = 32'hFFFFFFFF;
        sel = 0;
        #10;

        // Test Case 1: sel = 0, out should be in0
        in0 = 32'hAAAAAAAA;
        in1 = 32'h55555555;
        sel = 0;
        #10;
        // Expected: out = AAAAAAAA

        // Test Case 2: sel = 1, out should be in1
        sel = 1;
        #10;
        // Expected: out = 55555555

        // Test Case 3: Change in0/in1 while sel is 0
        in0 = 32'h12345678;
        in1 = 32'hABCDEF01;
        sel = 0;
        #10;
        // Expected: out = 12345678

        // Test Case 4: Change in0/in1 while sel is 1
        in0 = 32'h87654321;
        in1 = 32'hFEDCBA98;
        sel = 1;
        #10;
        // Expected: out = FEDCBA98

        // Test Case 5: sel changes rapidly
        in0 = 32'hAAAAAAAA;
        in1 = 32'h55555555;
        #5  sel = 0;
        #5  sel = 1;
        #5  sel = 0;
        #5  sel = 1;
        #10;
        // Expected: out alternates between AAAAAAAA and 55555555

        $display("Simulation finished.");
        $finish;
    end

endmodule
