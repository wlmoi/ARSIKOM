// ============================================================================
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul        : 1
// Percobaan    : 4
// Tanggal      : 5 November 2025
// Kelompok     : 
// Rombongan    : Rabu
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Darren Johan (13223032)
// Nama File    : reg_file_tb.v
// Deskripsi    : Testbench self-checking untuk reg_file_rv32i
//                Menulis 4 register (x1–x4) lalu membaca x0–x9
//                dengan sinkronisasi penuh rising edge-falling edge.
// ============================================================================


`timescale 1ns/1ps

module reg_file_tb;

    // Deklarasi sinyal-sinyal untuk DUT (Device Under Test)
    reg         clock;
    reg         cu_rdwrite; // write enable
    reg  [4:0]  rs1_addr;   // alamat baca port 1
    reg  [4:0]  rs2_addr;   // alamat baca port 2
    reg  [4:0]  rd_addr;    // alamat tulis
    reg  [31:0] rd_in;      // data tulis
    wire [31:0] rs1;        // data baca port 1
    wire [31:0] rs2;        // data baca port 2

    // Array untuk mempermudah perbandingan expected
    reg [31:0] expected_rf [0:9];
    integer errors;     // Deklarasi jumlah error di tingkat modul
    integer k;          // Deklarasi variabel loop 'k' di tingkat modul
    integer reg_idx;    // Deklarasi variabel loop 'reg_idx' di tingkat modul
    reg [31:0] data_aktual; // Variabel untuk menyimpan data yang dibaca, deklarasi di tingkat modul

    // Unit Under Test (UUT) - reg_file_rv32i
    reg_file_rv32i uut (
        .clock(clock),
        .cu_rdwrite(cu_rdwrite),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .rd_in(rd_in),
        .rs1(rs1),
        .rs2(rs2)
    );

    // Siapkan nilai diharapkan untuk register file agar bisa verifikasi.
    initial begin
        expected_rf[0] = 32'h00000000; // x0 selalu 0
        expected_rf[1] = 32'h000000aa;
        expected_rf[2] = 32'h000000bb;
        expected_rf[3] = 32'h000000cc;
        expected_rf[4] = 32'h000000dd;
        // Register x5 sampai x9 tidak ditulis, jadi seharusnya 0
        for (k = 5; k <= 9; k = k + 1) begin // Gunakan int k yang sudah dideklarasikan di tingkat modul
            expected_rf[k] = 32'h00000000;
        end
    end

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // Clock period 10ns
    end

    // Test sequence utama
    initial begin
        $dumpfile("reg_file_tb.vcd");
        $dumpvars(0, reg_file_tb);

        $display("===== MULAI TEST REGISTER FILE RV32I =====");

        errors = 0; // Inisialisasi errors di sini

        // Inisialisasi awal semua signal kontrol
        cu_rdwrite = 0;
        rd_addr    = 0;
        rd_in      = 0;
        rs1_addr   = 0; // Harus dimulai dari 0 untuk biar x0 diverif
        rs2_addr   = 0;

        #10; // Tunggu satu siklus clock awal agar sistem stabil (Kalau ga nanti aneh di perpindahan data)

        $display("FASE PENULISAN (Write Phase)");

        // Penulisan ke x1
        cu_rdwrite = 1; // Aktifkan write enable
        rd_addr    = 5'd1; // Alamat x1
        rd_in      = 32'h000000aa; 
        #10; 

        // Penulisan ke x2
        rd_addr    = 5'd2; // Alamat x2
        rd_in      = 32'h000000bb; 
        #10;

        // Penulisan ke x3
        rd_addr    = 5'd3; // Alamat x3
        rd_in      = 32'h000000cc; 
        #10;

        // Penulisan ke x4
        rd_addr    = 5'd4; // Alamat x4
        rd_in      = 32'h000000dd; 
        #10;

        // Coba menulis ke x0 (seharusnya diabaikan)
        rd_addr    = 5'd0; // Alamat x0
        rd_in      = 32'hFFFFFFFF; // Masukkan datanya sembarang, seharusnya tidak berpengaruh samsek 
                                   ///ke x0
        #10;

        cu_rdwrite = 0; // Nonaktifkan write enable setelah semua penulisan
        $display("FASE PENULISAN done.");
        #10; // Tunggu sebentar setelah penulisan selesai, pastikan tidak ada efek samping

        $display("FASE PEMBACAAN DAN VERIFIKASI (Read & Verify Phase)");
        
        // ********************************************************************
        // PENYESUAIAN TIMING PEMBACAAN
        // ********************************************************************
        // (1) Set alamat baca awal ke x0

    /*
        Sinkronisasikan proses baca tulis yang terjadi pada register. 
        Proses pembacaan data pada register berlangsung pada saat falling edge clock sedangkan 
        penulisan data pada register berlangsung pada saat rising edge clock.
    */
        rs1_addr = 0;
        #5; 
        
        // Menunggu sampai falling edge clock pertama dari fase pembacaan

        // (2) Membaca 10 alamat (x0 - x9) dan melakukan self-checking
        for (reg_idx = 0; reg_idx <= 9; reg_idx = reg_idx + 1) begin
            // Pada titik ini (tepat setelah #5, yaitu di falling edge), rs1_addr sudah diatur
            // dan rs1 seharusnya sudah update.
            data_aktual = rs1; // Ambil data aktual dari port baca

            if (data_aktual == expected_rf[reg_idx]) begin
                $display("PASS: x%0d. Nilai Asli: %h. Ekspetasi: %h", reg_idx, data_aktual, expected_rf[reg_idx]);
            end else begin
                $display("FAIL: x%0d. Nilai Asli: %h. Ekspetasi: %h", reg_idx, data_aktual, expected_rf[reg_idx]);
                errors = errors + 1;
            end
            
            // Siapkan pengaturan alamat baca untuk iterasi berikutnya (kalo bukan yang terakhir)
            // dan tunggu satu siklus penuh (rising edge + falling edge) untuk pembacaan berikutnya.
            // Ini akan membuat rs1_addr stabil sebelum falling edge
            // dan memberi waktu bagi rs1 untuk update.
            if (reg_idx < 9) begin
                rs1_addr = reg_idx + 1;
                #10; // Tunggu satu siklus clock penuh (rising edge + falling edge)
            end
        end


        // ********************************************************************
        // VALIDASI AKHIRRRRRR! 

        if (errors == 0) begin
            $display("===== TEST SUKSES: Tidak ada kesalahan ditemukan =====");
        end else begin
            $display("===== TEST GAGAL: %0d kesalahan ditemukan =====", errors);
        end
        
        #10; // Beri waktu sedikit sebelum $finish
        $finish; // Mengakhiri simulasi
    end

endmodule

/*
cd D:\ARSIKOM\EL3011_1_20251105_13223048\Tugas3
iverilog -o reg_file_tb.out reg_file_tb.v reg_file_rv32i.v
vvp reg_file_tb.out
gtkwave reg_file_tb.vcd
*/
