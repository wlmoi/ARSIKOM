// ============================================================================
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul        : 1
// Percobaan    : 2
// Tanggal      : 5 November 2025
// Kelompok     : 
// Rombongan    : Rabu
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Darren Johan (13223032)
// Nama File    : instr_rom_rv32i.v 
// Deskripsi    : Instruction ROM 32x32 (RV32I) via ALTSYNCRAM + .mif 
// ============================================================================


`timescale 1ns/1ps 
module instr_rom_rv32i ( 
    input  wire        clock, 
    input  wire [31:0] PC,      // byte address 
    output wire [31:0] INSTR 
); 
  // Word index untuk 32 word 
  wire [4:0] waddr = PC[6:2]; 
 
  altsyncram #( 
    .operation_mode("ROM"), 
    .width_a(32), 
    .widthad_a(5),                  // 32 word 
    .init_file("imemory_rv32i.mif"), 
    .outdata_reg_a("UNREGISTERED") 
  ) rom ( 
    .clock0   (clock), 
    .address_a(waddr), 
    .q_a      (INSTR), 
    .wren_a   (1'b0), 
    .data_a   (32'b0) 
  ); 
endmodule 

/*

# Buka Command Prompt
cd D:\ARSIKOM\EL3011_1_20251105_13223048\Tugas2


vlib work
vlog instr_rom_rv32i.v instr_rom_rv32i_tb.v
vsim instr_rom_rv32i_tb

run 1000ns


PERTAMA delete work...:
del /F /Q work
rmdir /S /Q work
vlib work
vlog instr_rom_rv32i.v instr_rom_rv32i_tb.v

KEDUA JALANKAN 
vlib work
vmap work work


vlog instr_rom_rv32i.v instr_rom_rv32i_tb.v

vsim instr_rom_rv32i_tb
run 500ns

Kalo malas ya gini TARUK DI MODELSIMNYA CONSOLE:
cd D:/ARSIKOM/EL3011_1_20251105_13223048/Tugas2; vlib work; vmap work work; vlog instr_rom_rv32i.v instr_rom_rv32i_tb.v; vsim instr_rom_rv32i_tb; run 500ns

KALAU ALTERA TIDAK KETEMU
vlog "C:/intelFPGA_lite/18.1/quartus/eda/sim_lib/altera_mf.v"
vlog "C:/altera/91sp2/quartus/eda/sim_lib/altera_mf.v" 
yang 9.1 <--- Ini bisa

vlog instr_rom_rv32i.v instr_rom_rv32i_tb.v
vsim instr_rom_rv32i_tb
run 500ns


*/