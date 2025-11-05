// ============================================================================
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul        : 1
// Percobaan    : 3
// Tanggal      : 5 November 2025
// Kelompok     : 
// Rombongan    : Rabu
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Darren Johan (13223032)
// Nama File    : data_mem_rv32i.v
// Deskripsi    :
// Modul ini merepresentasikan Data Memory (DMEM) untuk prosesor RV32I.
// Akses tulis dilakukan pada tepi jatuh clock (Write @negedge via clock terbalik),
// sedangkan pembacaan dilakukan secara asinkron (keluaran mengikuti alamat).
// Hindari konflik tulis/baca pada alamat yang sama jika membahayakan timing.
// ============================================================================

`timescale 1ns/1ps
module data_mem_rv32i (
    input  wire        clock,
    input  wire        cu_store,        // WE dari Control Unit
    input  wire [1:0]  cu_storetype,    // 00=SW, 01=SH, 10=SB
    input  wire [31:0] dmem_addr,       // alamat byte
    input  wire [31:0] rs2,             // data yang akan ditulis
    output wire [31:0] dmem_out         // data yang dibaca (asinkron)
);

    wire [7:0] waddr = dmem_addr[9:2];
    reg [3:0] be;
    always @* begin
        case (cu_storetype)
            2'b00: be = 4'b1111;                                        // SW (Word)
            2'b01: be = (dmem_addr[1]) ? 4'b1100 : 4'b0011;             // SH (Halfword)
            2'b10: case (dmem_addr[1:0])                                 // SB (Byte)
                       2'b00: be = 4'b0001;
                       2'b01: be = 4'b0010;
                       2'b10: be = 4'b0100;
                       default: be = 4'b1000;
                   endcase
            default: be = 4'b0000;
        endcase
    end

    reg [31:0] wr_data_aligned;
    always @* begin
        case (cu_storetype)
            2'b00: wr_data_aligned = rs2;                               // SW
            2'b01: wr_data_aligned = (dmem_addr[1]) ? 
                                      {rs2[15:0], 16'b0} :              // SH
                                      {16'b0, rs2[15:0]};
            2'b10: case (dmem_addr[1:0])                                // SB
                       2'b00: wr_data_aligned = {24'b0, rs2[7:0]};
                       2'b01: wr_data_aligned = {16'b0, rs2[7:0], 8'b0};
                       2'b10: wr_data_aligned = {8'b0, rs2[7:0], 16'b0};
                       default: wr_data_aligned = {rs2[7:0], 24'b0};
                   endcase
            default: wr_data_aligned = 32'b0;
        endcase
    end

    // Clock negatif ya untuk menghindari konflik tulis-baca
    wire clk_n = ~clock;

    // RAM internal (altsyncram)
    // - Write dilakukan pada falling edge
    // - Read bersifat asinkron (keluaran langsung mengikuti alamat)
    wire [31:0] q_ram;
    assign dmem_out = q_ram;

    altsyncram #(
        .operation_mode   ("SINGLE_PORT"),
        .width_a          (32),
        .widthad_a        (8),
        .outdata_reg_a    ("UNREGISTERED"),   // read async
        .init_file        ("dmemory.mif"),
        .width_byteena_a  (4)
    ) ram (
        .clock0    (clk_n),                   // tulis pada tepi jatuh clock
        .wren_a    (cu_store),
        .address_a (waddr),
        .data_a    (wr_data_aligned),
        .q_a       (q_ram),
        .byteena_a (be)
    );

endmodule

/*
cd D:/ARSIKOM/EL3011_1_20251105_13223048/Tugas3; vlib work; vmap work work; vlog data_mem_rv32i.v data_mem_rv32i_tb.v; vsim data_mem_rv32i_tb; run 500ns
*/
