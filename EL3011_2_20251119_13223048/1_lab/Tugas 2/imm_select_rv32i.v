// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 2
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File    : imm_select_rv32i.v
// Deskripsi    : Percobaan 2 yakni Immediate Selector untuk RV32I 

module imm_select_rv32i (
    input wire [24:0] trimmed_instr, // 25 MSB dari instruksi 
    input wire [2:0]  cu_immtype,    // Tipe immediate (I/S/B/U/J) 
    output reg [31:0] imm            // Nilai immediate 32-bit 
);

    always @ (*)
    begin
        case (cu_immtype)
            3'b000:  // I - type
                imm <= { {20{trimmed_instr[24]}}, trimmed_instr[24:13] };
                
            3'b001: // S - type
                imm <= { {20{trimmed_instr[24]}}, trimmed_instr[24:18], trimmed_instr[4:0] };

            3'b010: // B - type
                imm <= { {19{trimmed_instr[24]}}, trimmed_instr[24], trimmed_instr[0], trimmed_instr[23:18], trimmed_instr[4:1], 1'b0 };

            3'b011: // U - type
                imm <= { trimmed_instr[24:5], 12'h000 };

            3'b100: // J - type
                imm <= { {11{trimmed_instr[24]}}, trimmed_instr[24], trimmed_instr[12:5], trimmed_instr[13], trimmed_instr[23:14], 1'b0 };
            
            default: 
                imm <= 32'd0;
        endcase
    end

endmodule