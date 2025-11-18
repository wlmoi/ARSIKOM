// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 3
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : tb_pc_rv32i.v
// Deskripsi  : Testbench for 32-bit Program Counter

`timescale 1ns / 1ps

module tb_pc_rv32i;

    // Inputs
    reg        clk;
    reg        reset;
    reg [31:0] next_pc;

    // Outputs
    wire [31:0] pc;

    // Instantiate the Unit Under Test (UUT)
    pc_rv32i uut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    initial begin
        // Initialize Inputs
        reset   = 1; // Assert reset
        next_pc = 32'h1000;
        #10;

        // Deassert reset, PC should be 0, then update to next_pc
        reset   = 0;
        #10; // PC should become 0 at posedge clk, then 1000 at next posedge clk
        next_pc = 32'h1004;
        #10;
        // Expected: pc = 1000, then 1004

        // Test Case 1: Sequential PC increment
        next_pc = 32'h1008;
        #10;
        next_pc = 32'h100C;
        #10;
        // Expected: pc = 1008, then 100C

        // Test Case 2: Jump/Branch scenario
        next_pc = 32'hC000; // Simulate a jump to a new address
        #10;
        next_pc = 32'hC004;
        #10;
        // Expected: pc = C000, then C004

        // Test Case 3: Re-assert reset
        reset   = 1;
        #10;
        // Expected: pc = 0

        reset   = 0;
        next_pc = 32'h2000;
        #10;
        // Expected: pc = 2000

        $display("Simulation finished.");
        $finish;
    end

endmodule
