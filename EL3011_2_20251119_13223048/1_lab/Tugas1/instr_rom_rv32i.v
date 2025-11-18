// ============================================================================
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul        : 1
// Percobaan    : 1
// Tanggal      : 5 November 2025
// Kelompok     : 
// Rombongan    : Rabu
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Darren Johan (13223032)
// Nama File    : instr_rom_rv32i.v
// Deskripsi    : Instruction ROM RV32I, 32x32, baca sinkron @posedge clock
// ============================================================================


module instr_rom_rv32i ( 
    input  wire [31:0] ADDR,   // byte address dari PC 
    input  wire        clock, 
    input  wire        reset, 
    output reg  [31:0] INSTR   // instruksi 32-bit 
); 
  // 32 word x 32-bit 
  reg [31:0] mem [0:31]; 
  // Word index = PC[6:2] (bit [1:0] = 2'b00) 
  wire [4:0] waddr = ADDR[6:2]; 
 
  integer i; 
  initial begin 
    // Default: semua NOP (addi x0,x0,0) 
    for (i = 0; i < 32; i = i + 1) mem[i] = 32'h00000013; 
 
    // Isi program (ganti sesuai dengan "Machine Code" dari Venus pada Tugas Pendahuluan nomor 3!): 
    mem[0] = 32'h00500093; // addi x1,x0,5 
    mem[1] = 32'h00700113; // addi x2,x0,7 
    mem[2] = 32'h002081B3; // add  x3,x1,x2 
    mem[3] = 32'h00302023; // sw   x3,0(x0) 
    
    // Alternatif: load dari file heksa 
    //$readmemh("imemory_rv32i.hex", mem); 
  end 
 
  // Baca sinkron; reset keluarkan NOP 
  always @(posedge clock or posedge reset) begin 
    if (reset) INSTR <= 32'h00000013;   // NOP RV32I 
    else       INSTR <= mem[waddr]; 
  end 
endmodule