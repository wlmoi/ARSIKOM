// ============================================================================
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul        : 1
// Percobaan    : 2
// Tanggal      : 5 November 2025
// Kelompok     :
// Rombongan    : Rabu
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Darren Johan (13223032)
// Nama File    : instr_rom_rv32i_tb.v
// Deskripsi    : Testbench untuk instr_rom_rv32i (ALTSYNCRAM + .mif)
// Lokasi File  : D:\ARSIKOM\EL3011_1_20251105_13223048\Tugas2
// ============================================================================
//
// Catatan:
// - Jika modul instr_rom_rv32i menggunakan megafunction altsyncram yang tergantung
//   pada library Quartus, iverilog mungkin tidak mensimulasikannya langsung.
//   Untuk simulasi dengan iverilog, gunakan versi instr_rom_rv32i yang
//   bersifat behavioral (mis. memakai reg array + $readmemh/$readmemb) atau
//   pastikan model simulasi altsyncram tersedia.
// - Testbench ini menguji keluaran fungsional dan memverifikasi nilai sesuai MIF
//
// ============================================================================

`timescale 1ns/1ps

module instr_rom_rv32i_tb;

  // sinyal testbench <-> DUT
  reg  [31:0] PC;       // alamat byte dari PC
  reg         clock;
  wire [31:0] INSTR;   // keluaran instruksi dari DUT

  // instansiasi DUT (file instr_rom_rv32i.v harus ada di folder yang sama)
  instr_rom_rv32i dut (
    .clock(clock),
    .PC(PC),
    .INSTR(INSTR)
  );

  // parameter
  localparam CLK_PERIOD = 10;  // ns
  integer i;

  // nilai yang diharapkan sesuai isi imemory.mif (WIDTH=32, DEPTH=32)
  reg [31:0] expected [0:31];

  // inisialisasi expected berdasarkan MIF yang diberikan di tugas:
  // 00 : 00500093;  -- addi x1,x0,5
  // 01 : 00700113;  -- addi x2,x0,7
  // 02 : 002081B3;  -- add  x3,x1,x2
  // 03 : 00302023;  -- sw   x3,0(x0)
  // [04..1F] : 00000013; -- NOP
  initial begin
    expected[0]  = 32'h00500093;
    expected[1]  = 32'h00700113;
    expected[2]  = 32'h002081B3;
    expected[3]  = 32'h00302023;
    for (i = 4; i < 32; i = i + 1) expected[i] = 32'h00000013;
  end

  // pembangkit clock
  initial begin
    clock = 0;
    forever #(CLK_PERIOD/2) clock = ~clock;
  end

  // dump waveform
  initial begin
    $dumpfile("instr_rom_rv32i_tb.vcd");
    $dumpvars(0, instr_rom_rv32i_tb);
  end

  // proses pengujian utama
  initial begin
    // Inisialisasi PC
    PC = 32'd0;

    // Tunggu beberapa siklus agar DUT "siap"
    repeat (2) @(posedge clock);

    // Uji tiap alamat word-aligned: 0,4,8,...,124
    for (i = 0; i < 32; i = i + 1) begin
      PC = i * 4;             // byte address (word-aligned)
      // Karena beberapa implementasi ROM (altsyncram) memperbarui keluaran
      // secara combinational atau synchronous tergantung setelan, tunggu
      // sedikit (satu tepi clock atau delay kecil).
      // Kita tunggu satu posedge clock lalu beri sedikit delay.
      @(posedge clock); #1;
      if (INSTR !== expected[i]) begin
        $display("GAGAL: PC byte=%0d (word idx %0d) -> INSTR=%h, seharusnya=%h", i*4, i, INSTR, expected[i]);
      end else begin
        $display("OK   : PC byte=%0d (word idx %0d) -> INSTR=%h", i*4, i, INSTR);
      end
    end

    // Uji alamat tidak sejajar kata (low 2 bit != 0)
    // Contoh: PC = 1 harus memetakan ke word 0; PC = 5 harus ke word 1
    PC = 32'd1; @(posedge clock); #1;
    if (INSTR !== expected[0]) $display("GAGAL: Unaligned PC=1 -> INSTR=%h (harus %h)", INSTR, expected[0]);
    else                      $display("OK   : Unaligned PC=1 -> INSTR=%h (map ke word 0)", INSTR);

    PC = 32'd5; @(posedge clock); #1;
    if (INSTR !== expected[1]) $display("GAGAL: Unaligned PC=5 -> INSTR=%h (harus %h)", INSTR, expected[1]);
    else                      $display("OK   : Unaligned PC=5 -> INSTR=%h (map ke word 1)", INSTR);

    // Jika DUT menggunakan .mif "imemory_rv32i.mif", pastikan nama file tersebut
    // sesuai dan berada pada direktori proyek Quartus saat mensintesis / simulasi.

    $display("Selesai pengujian fungsional. Periksa waveform di instr_rom_rv32i_tb.vcd jika perlu.");
    $finish;
  end

endmodule

/*
GABAKAL KERJA KARENA HARUS PAKAI QUARTUS II BRO
cd D:\ARSIKOM\EL3011_1_20251105_13223048\Tugas2
iverilog -o instr_rom_tb.vvp instr_rom_rv32i.v instr_rom_rv32i_tb.v
vvp instr_rom_tb.vvp
gtkwave instr_rom_rv32i_tb.vcd


*/