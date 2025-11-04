// ============================================================================
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul        : 1
// Percobaan    : 1
// Tanggal      : 5 November 2025
// Kelompok     : 
// Rombongan    : Rabu
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Darren Johan (13223032)
// Nama File    : instr_rom_rv32i_tb.v
// Deskripsi    : Testbench untuk menguji modul instr_rom_rv32i (Instruction ROM RV32I)
// Lokasi File  : D:\ARSIKOM\EL3011_1_20251105_13223048\Tugas1
// ============================================================================

`timescale 1ns/1ps

module instr_rom_rv32i_tb;

  // --------------------------------------------------------------------------
  // Deklarasi sinyal untuk menghubungkan testbench dengan DUT (Device Under Test)
  // --------------------------------------------------------------------------
  reg  [31:0] ADDR;   // alamat byte (input)
  reg         clock;  // sinyal clock
  reg         reset;  // sinyal reset
  wire [31:0] INSTR;  // instruksi keluaran (output)

  // --------------------------------------------------------------------------
  // Instansiasi modul yang diuji (instr_rom_rv32i)
  // --------------------------------------------------------------------------
  instr_rom_rv32i dut (
    .ADDR(ADDR),
    .clock(clock),
    .reset(reset),
    .INSTR(INSTR)
  );

  // --------------------------------------------------------------------------
  // Parameter dan variabel bantu
  // --------------------------------------------------------------------------
  localparam NOP        = 32'h00000013;   // Instruksi NOP RV32I (addi x0,x0,0)
  localparam CLK_PERIOD = 10;             // Periode clock 10 ns (100 MHz)
  integer i;

  // Array untuk nilai instruksi yang diharapkan
  reg [31:0] expected [0:31];

  // --------------------------------------------------------------------------
  // Inisialisasi nilai ekspektasi (harus sama dengan isi mem di modul utama)
  // --------------------------------------------------------------------------
  initial begin
    // Semua alamat berisi NOP secara default
    for (i = 0; i < 32; i = i + 1)
      expected[i] = NOP;

    // Isi instruksi sesuai dengan program contoh pada modul
    expected[0] = 32'h00500093; // addi x1,x0,5
    expected[1] = 32'h00700113; // addi x2,x0,7
    expected[2] = 32'h002081B3; // add  x3,x1,x2
    expected[3] = 32'h00302023; // sw   x3,0(x0)
  end

  // --------------------------------------------------------------------------
  // Pembangkit clock periodik
  // --------------------------------------------------------------------------
  initial begin
    clock = 0;
    forever #(CLK_PERIOD/2) clock = ~clock;
  end

  // --------------------------------------------------------------------------
  // Simpan data simulasi ke file VCD agar bisa dilihat di GTKWave
  // --------------------------------------------------------------------------
  initial begin
    $dumpfile("instr_rom_rv32i_tb.vcd");
    $dumpvars(0, instr_rom_rv32i_tb);
  end

  // --------------------------------------------------------------------------
  // Proses pengujian utama
  // --------------------------------------------------------------------------
  initial begin
    // Tahap 1: Reset awal
    ADDR  = 32'd0;
    reset = 1'b1;

    // Tunggu dua siklus clock untuk memastikan reset bekerja
    repeat (2) @(posedge clock);
    if (INSTR !== NOP)
      $display("GAGAL: Saat reset, INSTR = %h (seharusnya NOP = %h)", INSTR, NOP);
    else
      $display("OK: Saat reset, INSTR = NOP (%h)", INSTR);

    // Tahap 2: Lepaskan reset
    @(posedge clock);
    reset = 1'b0;

    // Tahap 3: Uji pembacaan setiap alamat word-aligned (0,4,8,...,124)
    for (i = 0; i < 32; i = i + 1) begin
      ADDR = i * 4;           // byte address
      @(posedge clock); #1;   // tunggu perubahan output
      if (INSTR !== expected[i])
        $display("GAGAL: addr=%0d (byte %0d) -> INSTR=%h, seharusnya=%h", i, i*4, INSTR, expected[i]);
      else
        $display("BERHASIL: addr=%0d (byte %0d) -> INSTR=%h", i, i*4, INSTR);
    end

    // Tahap 4: Uji alamat tidak sejajar word (misal ADDR = 1 dan 5)
    ADDR = 32'd1;
    @(posedge clock); #1;
    if (INSTR !== expected[0])
      $display("GAGAL: Alamat 1 tidak memetakan ke word 0. INSTR=%h", INSTR);
    else
      $display("OK: Alamat 1 memetakan ke word 0 -> INSTR=%h", INSTR);

    ADDR = 32'd5;
    @(posedge clock); #1;
    if (INSTR !== expected[1])
      $display("GAGAL: Alamat 5 tidak memetakan ke word 1. INSTR=%h", INSTR);
    else
      $display("OK: Alamat 5 memetakan ke word 1 -> INSTR=%h", INSTR);

    // Tahap 5: Uji ulang reset di akhir
    reset = 1'b1;
    @(posedge clock); #1;
    if (INSTR !== NOP)
      $display("GAGAL: Setelah reset ulang, INSTR=%h (seharusnya NOP=%h)", INSTR, NOP);
    else
      $display("OK: Setelah reset ulang, INSTR = NOP (%h)", INSTR);

    reset = 1'b0;
    @(posedge clock);

    $display("SEMUA PENGUJIAN SELESAI TANPA ERROR.");
    $finish;
  end

endmodule

 /*
 cd D:\ARSIKOM\EL3011_1_20251105_13223048\Tugas1
 iverilog -o instr_rom_tb.vvp instr_rom_rv32i.v instr_rom_rv32i_tb.v
 vvp instr_rom_tb.vvp
 gtkwave instr_rom_rv32i_tb.vcd
 */
