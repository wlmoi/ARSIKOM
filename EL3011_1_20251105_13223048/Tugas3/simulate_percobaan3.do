transcript on

# Pindah ke folder tempat file Verilog kamu
cd D:/ARSIKOM/EL3011_1_20251105_13223048/Tugas3

# Buat dan petakan library kerja
vlib work
vmap work work

# Kompilasi library bawaan Quartus (VERSI PRO)
vlog "C:/intelFPGA_pro/18.1/quartus/eda/sim_lib/altera_primitives.v"
vlog "C:/intelFPGA_pro/18.1/quartus/eda/sim_lib/220model.v"
vlog "C:/intelFPGA_pro/18.1/quartus/eda/sim_lib/sgate.v"
vlog "C:/intelFPGA_pro/18.1/quartus/eda/sim_lib/altera_mf.v"

# Kompilasi desain dan testbench
vlog instr_rom_rv32i.v
vlog instr_rom_rv32i_tb.v

# Jalankan simulasi
vsim work.instr_rom_rv32i_tb

# Tambahkan semua sinyal penting ke waveform
add wave sim:/instr_rom_rv32i_tb/*
run 1000ns

# do D:/ARSIKOM/EL3011_1_20251105_13223048/Tugas3/simulate_percobaan3.do
