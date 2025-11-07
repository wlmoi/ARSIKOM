// ============================================================================
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul        : 1
// Percobaan    : 3
// Tanggal      : 5 November 2025
// Kelompok     : 
// Rombongan    : Rabu
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Darren Johan (13223032)
// Nama File    : data_mem_rv32i_tb.v
// Deskripsi    : Testbench untuk memverifikasi Data Memory RV32I berbasis ALTSYNCRAM
// ============================================================================

`timescale 1ns/1ps
module data_mem_rv32i_tb;

  // Deklarasi sinyal uji
  reg         clock;
  reg         cu_store;
  reg  [1:0]  cu_storetype;
  reg  [31:0] dmem_addr;
  reg  [31:0] rs2;
  wire [31:0] dmem_out;

  // Instansiasi modul data memory
  data_mem_rv32i uut (
    .clock(clock),
    .cu_store(cu_store),
    .cu_storetype(cu_storetype),
    .dmem_addr(dmem_addr),
    .rs2(rs2),
    .dmem_out(dmem_out)
  );

  // Membuat clock periodik
  initial begin
    clock = 0;
    forever #5 clock = ~clock;  // periode 10 ns
  end

  // Proses stimulasi input
  initial begin
    // Simpan hasil ke file .vcd
    $dumpfile("data_mem_rv32i_tb.vcd");
    $dumpvars(0, data_mem_rv32i_tb);

    // Inisialisasi awal
    cu_store = 0;
    cu_storetype = 2'b00;
    dmem_addr = 32'd0;
    rs2 = 32'd0;
    #10;

    // ----------------------------
    // Uji 1: Store Word (SW)
    // ----------------------------
    cu_store = 1;
    cu_storetype = 2'b00;   // SW
    dmem_addr = 32'h00000004;
    rs2 = 32'hAABBCCDD;
    #10 cu_store = 0;
    #10;

    // ----------------------------
    // Uji 2: Store Halfword (SH)
    // ----------------------------
    cu_store = 1;
    cu_storetype = 2'b01;   // SH
    dmem_addr = 32'h00000006;   // alamat genap
    rs2 = 32'h00001234;
    #10 cu_store = 0;
    #10;

    // ----------------------------
    // Uji 3: Store Byte (SB)
    // ----------------------------
    cu_store = 1;
    cu_storetype = 2'b10;   // SB
    dmem_addr = 32'h00000003;   // alamat byte ke-3
    rs2 = 32'h000000AB;
    #10 cu_store = 0;
    #10;

    // ----------------------------
    // Uji 4: Baca Data dari Memory
    // ----------------------------
    cu_store = 0;
    cu_storetype = 2'b00;
    dmem_addr = 32'h00000004;  // alamat SW sebelumnya
    #10;

    // Tampilkan hasil ke terminal
    $display("Waktu %t | Alamat = %h | Data keluar = %h", $time, dmem_addr, dmem_out);

    #50;
    $finish;
  end

endmodule

/* 
cd D:\ARSIKOM\EL3011_1_20251105_13223048\Tugas3
iverilog -o data_mem_tb.vvp data_mem_rv32i.v data_mem_rv32i_tb.v
vvp data_mem_tb.vvp
gtkwave data_mem_rv32i_tb.vcd
*/