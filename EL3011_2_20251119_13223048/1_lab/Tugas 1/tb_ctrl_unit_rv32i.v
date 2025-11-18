// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 1
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File  : tb_ctrl_unit_rv32i.v
// Deskripsi  : Testbench untuk Control Unit (CU) RV32I

`timescale 1ns / 1ps

module tb_ctrl_unit_rv32i;

    // Deklarasi sinyal testbench untuk input CU
    reg [6:0] opcode_tb;
    reg [2:0] funct3_tb;
    reg [6:0] funct7_tb;

    // Deklarasi sinyal testbench untuk output CU
    wire       cu_ALU1src_tb;
    wire       cu_ALU2src_tb;
    wire [2:0] cu_immtype_tb;
    wire [1:0] cu_ALUtype_tb;
    wire       cu_adtype_tb;
    wire [1:0] cu_gatype_tb;
    wire [1:0] cu_shiftype_tb;
    wire       cu_sltype_tb;
    wire [1:0] cu_rdtype_tb;
    wire       cu_rdwrite_tb;
    wire [2:0] cu_loadtype_tb;
    wire       cu_store_tb;
    wire [1:0] cu_storetype_tb;
    wire       cu_branch_tb;
    wire [2:0] cu_branchtype_tb;
    wire       cu_PCtype_tb;

    // Instansiasi Unit Under Test (UUT)
    // Diasumsikan ctrl_unit_rv32i.v ada di direktori yang sama
    ctrl_unit_rv32i uut (
        .opcode(opcode_tb),
        .funct3(funct3_tb),
        .funct7(funct7_tb),

        .cu_ALU1src(cu_ALU1src_tb),
        .cu_ALU2src(cu_ALU2src_tb),
        .cu_immtype(cu_immtype_tb),
        .cu_ALUtype(cu_ALUtype_tb),
        .cu_adtype(cu_adtype_tb),
        .cu_gatype(cu_gatype_tb),
        .cu_shiftype(cu_shiftype_tb),
        .cu_sltype(cu_sltype_tb),
        .cu_rdtype(cu_rdtype_tb),
        .cu_rdwrite(cu_rdwrite_tb),
        .cu_loadtype(cu_loadtype_tb),
        .cu_store(cu_store_tb),
        .cu_storetype(cu_storetype_tb),
        .cu_branch(cu_branch_tb),
        .cu_branchtype(cu_branchtype_tb),
        .cu_PCtype(cu_PCtype_tb)
    );

    initial begin
        // Konfigurasi pencatatan waveform
        $dumpfile("cu_sim.vcd");
        $dumpvars(0, tb_ctrl_unit_rv32i);

        // Inisialisasi awal
        opcode_tb = 7'b0; funct3_tb = 3'b0; funct7_tb = 7'b0; #10;

        // --- Kasus Uji R-type (opcode = 7'h33) ---
        $display("\n--- Uji R-type ---");
        // ADD (funct3=0, funct7=0)
        opcode_tb = 7'h33; funct3_tb = 3'h0; funct7_tb = 7'h00; #10;
        // Output diharapkan: cu_rdwrite=1, cu_ALUtype=00, cu_adtype=0, sisanya default/don't care

        // SUB (funct3=0, funct7=0x20)
        funct7_tb = 7'h20; #10;
        // Output diharapkan: cu_rdwrite=1, cu_ALUtype=00, cu_adtype=1

        // SLL (funct3=1, funct7=0)
        funct3_tb = 3'h1; funct7_tb = 7'h00; #10;
        // Output diharapkan: cu_rdwrite=1, cu_ALUtype=10

        // SLTU (funct3=3, funct7=0)
        funct3_tb = 3'h3; funct7_tb = 7'h00; #10;
        // Output diharapkan: cu_rdwrite=1, cu_ALUtype=11, cu_sltype=1

        // XOR (funct3=4, funct7=0)
        funct3_tb = 3'h4; funct7_tb = 7'h00; #10;
        // Output diharapkan: cu_rdwrite=1, cu_ALUtype=01, cu_gatype=10

        // SRL (funct3=5, funct7=0)
        funct3_tb = 3'h5; funct7_tb = 7'h00; #10;
        // Output diharapkan: cu_rdwrite=1, cu_ALUtype=10, cu_shiftype=01

        // SRA (funct3=5, funct7=0x20)
        funct7_tb = 7'h20; #10;
        // Output diharapkan: cu_rdwrite=1, cu_ALUtype=10, cu_shiftype=11

        // --- Kasus Uji I-type (ALU) (opcode = 7'h13) ---
        $display("\n--- Uji I-type (ALU) ---");
        // ADDI (funct3=0, funct7=0)
        opcode_tb = 7'h13; funct3_tb = 3'h0; funct7_tb = 7'h00; #10;
        // Output diharapkan: cu_ALU2src=1, cu_rdwrite=1, cu_immtype=000, cu_ALUtype=00, cu_adtype=0

        // XORI (funct3=4, funct7=0)
        funct3_tb = 3'h4; funct7_tb = 7'h00; #10;
        // Output diharapkan: cu_ALU2src=1, cu_rdwrite=1, cu_immtype=000, cu_ALUtype=01, cu_gatype=10

        // --- Kasus Uji Load (I-type, opcode = 7'h03) ---
        $display("\n--- Uji Load ---");
        // LW (funct3=2)
        opcode_tb = 7'h03; funct3_tb = 3'h2; #10;
        // Output diharapkan: cu_ALU2src=1, cu_immtype=000, cu_rdtype=01, cu_rdwrite=1, cu_loadtype=010

        // LBU (funct3=3)
        funct3_tb = 3'h3; #10;
        // Output diharapkan: cu_ALU2src=1, cu_immtype=000, cu_rdtype=01, cu_rdwrite=1, cu_loadtype=011

        // --- Kasus Uji S-type (Store) (opcode = 7'h23) ---
        $display("\n--- Uji Store ---");
        // SW (funct3=2)
        opcode_tb = 7'h23; funct3_tb = 3'h2; #10;
        // Output diharapkan: cu_ALU2src=1, cu_immtype=001, cu_store=1, cu_storetype=10

        // SB (funct3=0)
        funct3_tb = 3'h0; #10;
        // Output diharapkan: cu_ALU2src=1, cu_immtype=001, cu_store=1, cu_storetype=00

        // --- Kasus Uji B-type (Branch) (opcode = 7'h63) ---
        $display("\n--- Uji Branch ---");
        // BEQ (funct3=0)
        opcode_tb = 7'h63; funct3_tb = 3'h0; #10;
        // Output diharapkan: cu_ALU1src=1, cu_ALU2src=1, cu_immtype=010, cu_branch=1, cu_PCtype=1, cu_branchtype=000

        // BNE (funct3=1)
        funct3_tb = 3'h1; #10;
        // Output diharapkan: cu_ALU1src=1, cu_ALU2src=1, cu_immtype=010, cu_branch=1, cu_PCtype=1, cu_branchtype=101

        // --- Kasus Uji U-type (LUI/AUIPC) ---
        $display("\n--- Uji U-type ---");
        // LUI (opcode=7'h37)
        opcode_tb = 7'h37; #10;
        // Output diharapkan: cu_ALU2src=1, cu_immtype=011, cu_rdtype=11, cu_rdwrite=1

        // AUIPC (opcode=7'h17)
        opcode_tb = 7'h17; #10;
        // Output diharapkan: cu_ALU1src=1, cu_ALU2src=1, cu_immtype=011, cu_rdwrite=1, cu_rdtype=00

        // --- Kasus Uji J-type (JAL/JALR) ---
        $display("\n--- Uji J-type ---");
        // JAL (opcode=7'h6F)
        opcode_tb = 7'h6F; #10;
        // Output diharapkan: cu_ALU1src=1, cu_ALU2src=1, cu_immtype=100, cu_rdtype=10, cu_rdwrite=1, cu_branch=1, cu_PCtype=1

        // JALR (opcode=7'h67)
        opcode_tb = 7'h67; #10;
        // Output diharapkan: cu_ALU1src=0 (default), cu_ALU2src=1, cu_immtype=000, cu_rdtype=10, cu_rdwrite=1, cu_branch=1, cu_PCtype=1

        $display("\nSimulasi Control Unit selesai.");
        $finish;
    end

endmodule
