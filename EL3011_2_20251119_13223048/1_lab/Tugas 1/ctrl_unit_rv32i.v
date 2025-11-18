// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 1
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File    : ctrl_unit_rv32i.v
// Deskripsi    : Control Unit (CU) untuk Percobaan 1 RV32I
//                [Register terletak pada cite: 141]

module ctrl_unit_rv32i (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    
    output reg cu_ALU1src,
    output reg cu_ALU2src,
    output reg [2:0] cu_immtype,
    output reg [1:0] cu_ALUtype,
    output reg cu_adtype,
    output reg [1:0] cu_gatype,
    output reg [1:0] cu_shiftype,
    output reg cu_sltype,
    output reg [1:0] cu_rdtype,
    output reg cu_rdwrite,
    output reg [2:0] cu_loadtype,
    output reg cu_store,
    output reg [1:0] cu_storetype,
    output reg cu_branch,
    output reg [2:0] cu_branchtype,
    output reg cu_PCtype
);

always @ (*) 
begin
    // [Register di cite: 146-187]
    cu_ALU1src    = 1'b0; // Dari rs1
    cu_ALU2src    = 1'b0; // Dari rs2
    cu_immtype    = 3'b000; // I-type
    cu_ALUtype    = 2'b00; // ADD/SUB
    cu_adtype     = 1'b0; // Addition
    cu_gatype     = 2'b00; // AND
    cu_shiftype   = 2'b00; // SLL
    cu_sltype     = 1'b0; // SLT (Signed)
    cu_rdtype     = 2'b00; // Dari ALU
    cu_rdwrite    = 1'b0; // No Write
    cu_loadtype   = 3'b010; // Load Word (LW) by default
    cu_store      = 1'b0; // No Store
    cu_storetype  = 2'b00; // Store Byte (SB) by default
    cu_branch     = 1'b0; // No Branch
    cu_branchtype = 3'b000; // BEQ
    cu_PCtype     = 1'b0; // PC + 4

    // --- Main Logic Decoder dengan Source Opcode ---
    case (opcode) 
    
        // R-type [Register di cite: 182]
        7'h33:
        begin
            cu_rdwrite = 1'b1; 
            case (funct3) 
                // ADD/SUB [Register di cite: 190]
                3'h0: 
                begin
                    if (funct7 == 7'h20) // SUB [Register di cite: 192]
                        cu_adtype = 1'b1;
                end
                // SLL [Register di cite: 193]
                3'h1: 
                begin
                    cu_ALUtype = 2'b10; // Shift op [Register di cite: 194]
                end
                // SLT [Register di cite: 196]
                3'h2:
                begin
                    cu_ALUtype = 2'b11; // SLT op [Register di cite: 197]
                end
                // SLTU [Register di cite: 199]
                3'h3:
                begin
                    cu_ALUtype = 2'b11; // SLT op [Register di cite: 201]
                    cu_sltype = 1'b1;  // Unsigned [Register di cite: 203]
                end
                // XOR [Register di cite: 205]
                3'h4:
                begin
                    cu_ALUtype = 2'b01; // Gate op [Register di cite: 207]
                    cu_gatype = 2'b10; // XOR (template salah, 2'b11 itu tidak ada) [Register di cite: 209, 30]
                end
                // SRL/SRA [Register di cite: 211]
                3'h5:
                begin
                    cu_ALUtype = 2'b10; // Shift op [Register di cite: 213]
                    if (funct7 == 7'h00)
                        cu_shiftype = 2'b01; // SRL [Register di cite: 214, 216]
                    else
                        cu_shiftype = 2'b11; // SRA [Register di cite: 217, 218]
                end
                // OR [Register di cite: 221]
                3'h6:
                begin
                    cu_ALUtype = 2'b01; // Gate op [Register di cite: 224]
                    cu_gatype = 2'b01; // OR [Register di cite: 224]
                end
                // AND [Register di cite: 225]
                3'h7:
                begin
                    cu_ALUtype = 2'b01; // Gate op [Register di cite: 227]
                    // cu_gatype = 2'b00 nilainya pasti default
                end
            endcase
        end
        
        // I-type (ALU) [Register di cite: 228]
        7'h13:
        begin
            cu_ALU2src = 1'b1; // Dari immediate
            cu_rdwrite = 1'b1; // Tulis ke rd
            // cu_immtype = 3'b000 (I-type) bernilai pasti default
            
            case (funct3)
                // ADDI (default, tidak perlu di-case)
                // 3'h0: 
                
                // SLLI [Register di cite: 232]
                3'h1:
                begin
                    cu_ALUtype = 2'b10; // Shift op
                    // cu_shiftype = 2'b00 (SLL) bernilai pasti default
                end
                // SLTI [Register di cite: 234]
                3'h2:
                begin
                    cu_ALUtype = 2'b11; // SLT op
                    // cu_sltype = 1'b0 (Signed) sudah default
                end
                // SLTIU
                3'h3:
                begin
                    cu_ALUtype = 2'b11; // SLT op
                    cu_sltype = 1'b1;  // Unsigned
                end
                // XORI
                3'h4:
                begin
                    cu_ALUtype = 2'b01; // Gate op
                    cu_gatype = 2'b10; // XOR
                end
                // SRLI/SRAI
                3'h5:
                begin
                    cu_ALUtype = 2'b10; // Shift op
                    if (funct7 == 7'h00)
                        cu_shiftype = 2'b01; // SRLI
                    else
                        cu_shiftype = 2'b11; // SRAI
                end
                // ORI
                3'h6:
                begin
                    cu_ALUtype = 2'b01; // Gate op
                    cu_gatype = 2'b01; // OR
                end
                // ANDI
                3'h7:
                begin
                    cu_ALUtype = 2'b01; // Gate op
                    // cu_gatype = 2'b00 (AND) bernilai pasti default
                end
            endcase
        end

        // Load (I-type) [Register di cite: 240]
        7'h03:
        begin
            cu_ALU2src = 1'b1; // Dari immediate
            // cu_immtype = 3'b000 (I-type) bernilai pasti default
            cu_rdtype = 2'b01; // Dari memori
            cu_rdwrite = 1'b1; // Tulis ke rd
            
            case (funct3)
                3'h0: cu_loadtype = 3'b000; // LB
                3'h1: cu_loadtype = 3'b001; // LH
                3'h2: cu_loadtype = 3'b010; // LW
                3'h3: cu_loadtype = 3'b011; // LBU
                3'h4: cu_loadtype = 3'b100; // LHU
            endcase
        end

        // S-type (Store) [Register di cite: 243]
        7'h23:
        begin
            cu_ALU2src = 1'b1; // Dari immediate
            cu_immtype = 3'b001; // S-type
            cu_store = 1'b1;   // Aktifkan store
            
            case (funct3)
                3'h0: cu_storetype = 2'b00; // SB
                3'h1: cu_storetype = 2'b01; // SH
                3'h2: cu_storetype = 2'b10; // SW
            endcase
        end

        // B-type (Branch) [Register di cite: 247]
        7'h63:
        begin
            cu_ALU1src = 1'b1; // Dari PC
            cu_ALU2src = 1'b1; // Dari immediate
            cu_immtype = 3'b010; // B-type
            cu_branch = 1'b1;   // Aktifkan branch
            cu_PCtype = 1'b1;   // Ambil PC dari ALU (target branch)
            
            case (funct3)
                3'h0: cu_branchtype = 3'b000; // BEQ
                3'h1: cu_branchtype = 3'b101; // BNE
                3'h4: cu_branchtype = 3'b011; // BLT
                3'h5: cu_branchtype = 3'b001; // BGE
                3'h6: cu_branchtype = 3'b100; // BLTU
                3'h7: cu_branchtype = 3'b010; // BGEU
            endcase
        end
        
        // LUI (U-type) [Register di cite: 251]
        7'h37:
        begin
            cu_ALU2src = 1'b1; // Dari immediate
            cu_immtype = 3'b011; // U-type
            cu_rdtype = 2'b11; // Dari immediate (ke rd)
            cu_rdwrite = 1'b1; // Tulis ke rd
        end

        // AUIPC (U-type) [Register di cite: 255]
        7'h17:
        begin
            cu_ALU1src = 1'b1; // Dari PC
            cu_ALU2src = 1'b1; // Dari immediate
            cu_immtype = 3'b011; // U-type
            cu_rdwrite = 1'b1; // Tulis ke rd
            // cu_rdtype = 2'b00 (Dari ALU) bernilai pasti default
        end

        // JAL (J-type) [Register di cite: 259]
        7'h6F:
        begin
            cu_ALU1src = 1'b1; // Dari PC
            cu_ALU2src = 1'b1; // Dari immediate
            cu_immtype = 3'b100; // J-type
            cu_rdtype = 2'b10; // Dari PC+4
            cu_rdwrite = 1'b1; // Tulis ke rd
            cu_branch = 1'b1;   // Aktifkan jump
            cu_PCtype = 1'b1;   // Ambil PC dari ALU (target jump)
        end
        
        // JALR (I-type) [Register di cite: 263]
        7'h67:
        begin
            // cu_ALU1src = 1'b0 (Dari rs1) bernilai pasti default
            cu_ALU2src = 1'b1; // Dari immediate
            // cu_immtype = 3'b000 (I-type) bernilai pasti default
            cu_rdtype = 2'b10; // Dari PC+4
            cu_rdwrite = 1'b1; // Tulis ke rd
            cu_branch = 1'b1;   // Aktifkan jump
            cu_PCtype = 1'b1;   // Ambil PC dari ALU (target jump)
        end

    endcase
end

endmodule