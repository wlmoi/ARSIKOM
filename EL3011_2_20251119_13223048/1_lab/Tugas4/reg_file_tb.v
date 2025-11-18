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

    // Deklarasi sinyal modul register
    reg         clock;
    reg         cu_rdwrite;// write enable
    reg  [4:0]  rs1_addr;// alamat baca port 1
    reg  [4:0]  rs2_addr;// alamat baca port 2
    reg  [4:0]  rd_addr;// alamat tulis
    reg  [31:0] rd_in;// data tulis
    wire [31:0] rs1;// data baca port 1
    wire [31:0] rs2;// data baca port 2
    // Deklarasi array output expected dan variavle testing
    reg [31:0] expected_rf [0:9];
    integer errors;
    integer k;// var. looping
    integer reg_idx;// var. register ke x
    reg [31:0] data_aktual; // var. data real

    // deklarasi unit yang di test
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

    // hasil yang diinginkan
    initial begin
        expected_rf[0] = 32'h00000000; // x0 selalu 0
        expected_rf[1] = 32'h000000a1;
        expected_rf[2] = 32'h00000abc;
        expected_rf[3] = 32'h12345678;
        expected_rf[4] = 32'hFFFFFFFF;
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
        // write ke register 0-4 sesuai dengan expected values kita, lalu delay, supaya tidak ada kemungkinantiming error
        cu_rdwrite = 1; // Turn on write enable
        
        rd_addr    = 5'd0; 
        rd_in      = 32'hc0c0c0c0; //nilai random aja,harusnya reg 0 tetap 0
        #10;

        rd_addr    = 5'd1; 
        rd_in      = 32'h000000a1; 
        #10; 

        rd_addr    = 5'd2; 
        rd_in      = 32'h00000abc; 
        #10;

        rd_addr    = 5'd3; 
        rd_in      = 32'h12345678; 
        #10;

        rd_addr    = 5'd4; 
        rd_in      = 32'hffffffff; 
        #10;

        cu_rdwrite = 0;
        $display("Write done.");
        #10;

        $display("Verify output");
        
        //baca dari register 0
        rs1_addr = 0;
        #5; 
        
        // tunggu half cycle atau falling edge supaya reading dapat dilakukan.
        
        //read register expected output dari 0-9, karena 5-9 tidak diisi jadi tetap nol, dna x0 tetap nol
        for (reg_idx = 0; reg_idx <= 9; reg_idx = reg_idx + 1) begin
            data_aktual = rs1; // store reading di register ke dalam var. data_aktual
			
			//compare dengan seharusnya
            if (data_aktual == expected_rf[reg_idx]) begin
                $display("PASS");
            end else begin
                $display("FAIL: Alamat x%0d; Actual: %h. Expected: %h", reg_idx, data_aktual, expected_rf[reg_idx]);
                errors = errors + 1;
            end
            
            //iterate ke register selanjutnya
            if (reg_idx < 9) begin
                rs1_addr = reg_idx + 1;
                #10;
            end
        end
		//output
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
cd D:\ARSIKOM\EL3011_1_20251105_13223048\Tugas4
iverilog -o reg_file_tb.out reg_file_tb.v reg_file_rv32i.v
vvp reg_file_tb.out
gtkwave reg_file_tb.vcd
*/