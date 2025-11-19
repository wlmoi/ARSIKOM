// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 2
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : tb_imm_select_rv32i.v
// Deskripsi  : Testbench untuk Immediate Selector (imm_select_rv32i)

`timescale 1ns / 1ps

module tb_imm_select_rv32i;

    // Deklarasi sinyal testbench
    reg  [24:0] trimmed_instr_tb;
    reg  [2:0]  cu_immtype_tb;
    wire [31:0] imm_tb;

    // Instansiasi Unit Under Test (UUT)
    // Diasumsikan imm_select_rv32i.v ada di direktori yang sama
    imm_select_rv32i uut (
        .trimmed_instr(trimmed_instr_tb),
        .cu_immtype(cu_immtype_tb),
        .imm(imm_tb)
    );

    initial begin
        // Konfigurasi pencatatan waveform
        $dumpfile("imm_sim.vcd");
        $dumpvars(0, tb_imm_select_rv32i);

        // Inisialisasi awal
        trimmed_instr_tb = 25'b0; cu_immtype_tb = 3'b0; #10;

        // --- Kasus Uji I-type (cu_immtype = 3'b000) ---
        $display("\n--- Uji I-type ---");
        // ADDI x5, x5, -1 (Machine Code: FFF28293) -> trimmed_instr: FFF2829
        // imm[11:0] = FFF (-1)
        trimmed_instr_tb = 25'hFFF2829; cu_immtype_tb = 3'b000; #10;
        // Output imm_tb diharapkan: 32'hFFFFFFFF (-1)

        // LW x9, 12(x2) (Machine Code: 00C12483) -> trimmed_instr: 00C1248
        // imm[11:0] = 00C (12)
        trimmed_instr_tb = 25'h00C1248; cu_immtype_tb = 3'b000; #10;
        // Output imm_tb diharapkan: 32'h0000000C (12)

        // --- Kasus Uji S-type (cu_immtype = 3'b001) ---
        $display("\n--- Uji S-type ---");
        // SW x9, -16(x2) (Machine Code: FFF12423) -> trimmed_instr: FFF1242
        // imm[11:0] = {inst[31:25], inst[11:7]} = {1111111, 00000} = F80, sign extended
        trimmed_instr_tb = 25'hFFF1242; cu_immtype_tb = 3'b001; #10;
        // Output imm_tb diharapkan: 32'hFFFFFFF0 (-16)

        // --- Kasus Uji B-type (cu_immtype = 3'b010) ---
        $display("\n--- Uji B-type ---");
        // BEQ x5, x0, -12 (Machine Code: FF028063) -> trimmed_instr: FF02806
        // imm = {imm[12], imm[11], imm[10:5], imm[4:1], 1'b0} = -12
        trimmed_instr_tb = 25'hFF02806; cu_immtype_tb = 3'b010; #10;
        // Output imm_tb diharapkan: 32'hFFFFFFF4 (-12)

        // --- Kasus Uji U-type (cu_immtype = 3'b011) ---
        $display("\n--- Uji U-type ---");
        // LUI x20, 0x00012 (Machine Code: 00012A37) -> trimmed_instr: 00012A3
        // imm[31:12] = 0x00012
        trimmed_instr_tb = 25'h00012A3; cu_immtype_tb = 3'b011; #10;
        // Output imm_tb diharapkan: 32'h00012000

        // --- Kasus Uji J-type (cu_immtype = 3'b100) ---
        $display("\n--- Uji J-type ---");
        // JAL x1, 80 (Machine Code: 050000EF) -> trimmed_instr: 050000E
        // imm = {imm[20], imm[10:1], imm[11], imm[19:12], 1'b0} = 80
        trimmed_instr_tb = 25'h050000E; cu_immtype_tb = 3'b100; #10;
        // Output imm_tb diharapkan: 32'h00000050 (80)

        // --- Kasus Uji Default ---
        $display("\n--- Uji Default ---");
        cu_immtype_tb = 3'b111; // Contoh tipe tidak dikenal
        #10;
        // Output imm_tb diharapkan: 32'h00000000 (0)

        $display("\nSimulasi Immediate Selector selesai.");
        $finish;
    end

endmodule
