// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul      : 2
// Percobaan  : 3
// Tanggal    : 19 November 2025
// Nama (NIM) 1 : William Anthony (13223048)
// Nama (NIM) 2 : Agita Trinanda Ilmi (13223003)
// Nama File    : brancher_rv32i.v
// Deskripsi    : Brancher untuk RV32I 

module brancher_rv32i(
    input wire [31:0] PCnew,   // PC+4 dari 4-adder 
    input wire [31:0] ALUout,  // PC+imm dari ALU 
    input wire signed [31:0] in1, // Nilai di rs1
    input wire signed [31:0] in2, // Nilai di rs2 
    input wire cu_branch,       // Enable branch 
    input wire [2:0] cu_branchtype, // Tipe branch 
    output reg [31:0] PCin
);

    // N I L A I N Y A          DI B E R I K A N 
    // $BEQ=3'b000, $BGE=3'b001, $BGEU=3'b010, $BLT=3'b011,
    // $BLTU=3'b100, $BNE=3'b101 [cite: 379, 382-383]

    always @ (*)
    begin
        if (cu_branch) 
        begin
            case (cu_branchtype) 
                // BEQ (Branch if Equal)
                3'b000: 
                    PCin <= (in1 == in2) ? ALUout : PCnew;
                
                // BGE (Branch if Greater or Equal - Signed)
                3'b001: 
                    PCin <= (in1 >= in2) ? ALUout : PCnew; 
                
                // BGEU (Branch if Greater or Equal - Unsigned)
                3'b010: 
                    PCin <= ($unsigned(in1) >= $unsigned(in2)) ? ALUout : PCnew; 
                
                // BLT (Branch if Less Than - Signed)
                3'b011: 
                    PCin <= (in1 < in2) ? ALUout : PCnew; 
                
                // BLTU (Branch if Less Than - Unsigned)
                3'b100: 
                    PCin <= ($unsigned(in1) < $unsigned(in2)) ? ALUout : PCnew; 
                
                // BNE (Branch if Not Equal)
                3'b101: 
                    PCin <= (in1 != in2) ? ALUout : PCnew; 
                
                // Default: jika tidak ada branch, teruskan PC+4
                default: 
                    PCin <= PCnew; 
            endcase
        end
        else
        begin
            PCin <= PCnew; 
        end
    end

endmodule