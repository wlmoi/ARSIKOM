// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 3
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : tb_brancher_rv32i.v
// Deskripsi  : Testbench untuk Brancher RV32I

`timescale 1ns / 1ps

module tb_brancher_rv32i;

    // Deklarasi sinyal testbench untuk input Brancher
    reg  [31:0] pc_new_tb;   // PC+4 dari 4-adder (input ke Brancher)
    reg  [31:0] alu_out_tb;  // PC+imm dari ALU (target branch/jump)
    reg signed [31:0] in1_tb;    // Nilai register rs1
    reg signed [31:0] in2_tb;    // Nilai register rs2
    reg        cu_branch_tb;       // Enable branch dari CU
    reg  [2:0]  cu_branchtype_tb; // Tipe branch dari CU

    // Deklarasi sinyal testbench untuk output Brancher
    wire [31:0] pcin_tb; // PCin (alamat PC selanjutnya)

    // Instansiasi Unit Under Test (UUT)
    // Diasumsikan brancher_rv32i.v ada di direktori yang sama
    brancher_rv32i uut (
        .PCnew(pc_new_tb),
        .ALUout(alu_out_tb),
        .in1(in1_tb),
        .in2(in2_tb),
        .cu_branch(cu_branch_tb),
        .cu_branchtype(cu_branchtype_tb),
        .PCin(pcin_tb)
    );

    initial begin
        // Konfigurasi pencatatan waveform
        $dumpfile("brancher_sim.vcd");
        $dumpvars(0, tb_brancher_rv32i);

        // --- Inisialisasi ---
        pc_new_tb = 32'h00000004;
        alu_out_tb = 32'h00001000;
        in1_tb = 0; in2_tb = 0;
        cu_branch_tb = 0; cu_branchtype_tb = 3'b000; // Default: no branch, PCin = PCnew
        #10;
        // Output pcin_tb diharapkan: 0x00000004

        // --- Kasus Uji BEQ (Branch if Equal) ---
        $display("\n--- Uji BEQ ---");
        pc_new_tb = 32'h00000008; // PC+4 jika tidak branch
        alu_out_tb = 32'h00001100; // Target branch jika kondisi true
        in1_tb = 10; in2_tb = 10; // Kondisi true (in1 == in2)
        cu_branch_tb = 1; cu_branchtype_tb = 3'b000; // BEQ
        #10;
        // Output pcin_tb diharapkan: 0x00001100 (melompat)

        // Kasus BEQ (False)
        in1_tb = 10; in2_tb = 11; // Kondisi false (in1 != in2)
        #10;
        // Output pcin_tb diharapkan: 0x00000008 (tidak melompat, gunakan PCnew)

        // --- Kasus Uji BNE (Branch if Not Equal) ---
        $display("\n--- Uji BNE ---");
        pc_new_tb = 32'h00000012;
        alu_out_tb = 32'h00001200;
        in1_tb = 5; in2_tb = 10; // Kondisi true (in1 != in2)
        cu_branch_tb = 1; cu_branchtype_tb = 3'b101; // BNE
        #10;
        // Output pcin_tb diharapkan: 0x00001200 (melompat)

        // Kasus BNE (False)
        in1_tb = 10; in2_tb = 10; // Kondisi false (in1 == in2)
        #10;
        // Output pcin_tb diharapkan: 0x00000012 (tidak melompat, gunakan PCnew)

        // --- Kasus Uji BLT (Branch if Less Than - Signed) ---
        $display("\n--- Uji BLT ---");
        pc_new_tb = 32'h00000016;
        alu_out_tb = 32'h00001300;
        in1_tb = -5; in2_tb = 0; // Kondisi true (-5 < 0)
        cu_branch_tb = 1; cu_branchtype_tb = 3'b011; // BLT
        #10;
        // Output pcin_tb diharapkan: 0x00001300 (melompat)

        // Kasus BLT (False)
        in1_tb = 5; in2_tb = 0; // Kondisi false (5 < 0 salah)
        #10;
        // Output pcin_tb diharapkan: 0x00000016 (tidak melompat)
        
        // --- Kasus Uji BGE (Branch if Greater or Equal - Signed) ---
        $display("\n--- Uji BGE ---");
        pc_new_tb = 32'h00000020;
        alu_out_tb = 32'h00001400;
        in1_tb = 10; in2_tb = 5; // Kondisi true (10 >= 5)
        cu_branch_tb = 1; cu_branchtype_tb = 3'b001; // BGE
        #10;
        // Output pcin_tb diharapkan: 0x00001400 (melompat)

        // Kasus BGE (False)
        in1_tb = 0; in2_tb = 5; // Kondisi false (0 >= 5 salah)
        #10;
        // Output pcin_tb diharapkan: 0x00000020 (tidak melompat)

        // --- Kasus Uji BLTU (Branch if Less Than - Unsigned) ---
        $display("\n--- Uji BLTU ---");
        pc_new_tb = 32'h00000024;
        alu_out_tb = 32'h00001500;
        in1_tb = 32'h0000000A; // 10 (unsigned)
        in2_tb = 32'h00000014; // 20 (unsigned)
        // (10 < 20) true
        cu_branch_tb = 1; cu_branchtype_tb = 3'b100; // BLTU
        #10;
        // Output pcin_tb diharapkan: 0x00001500 (melompat)

        // Kasus BLTU (False - perbandingan unsigned)
        in1_tb = 32'hFFFFFFFF; // -1 (signed) -> 4294967295 (unsigned)
        in2_tb = 32'h0000000A; // 10 (unsigned)
        // (4294967295 < 10) false
        #10;
        // Output pcin_tb diharapkan: 0x00000024 (tidak melompat)


        // --- Kasus Uji BGEU (Branch if Greater or Equal - Unsigned) ---
        $display("\n--- Uji BGEU ---");
        pc_new_tb = 32'h00000028;
        alu_out_tb = 32'h00001600;
        in1_tb = 32'hFFFFFFF0; // -16 (signed) -> 4294967280 (unsigned)
        in2_tb = 32'h00000064; // 100 (unsigned)
        // (4294967280 >= 100) true
        cu_branch_tb = 1; cu_branchtype_tb = 3'b010; // BGEU
        #10;
        // Output pcin_tb diharapkan: 0x00001600 (melompat)

        // Kasus BGEU (False)
        in1_tb = 32'h00000005; // 5 (unsigned)
        in2_tb = 32'h0000000A; // 10 (unsigned)
        // (5 >= 10) false
        #10;
        // Output pcin_tb diharapkan: 0x00000028 (tidak melompat)

        // --- Non-branching (cu_branch = 0) ---
        $display("\n--- Uji Non-branching ---");
        pc_new_tb = 32'h00000030;
        cu_branch_tb = 0; // Pastikan tidak ada branch, PCin harus selalu PCnew
        #10;
        // Output pcin_tb diharapkan: 0x00000030

        $display("\nSimulasi Brancher selesai.");
        $finish;
    end

endmodule
