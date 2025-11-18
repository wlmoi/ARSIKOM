# HANYA UNTUK SIMULASI FUNCTIONAL DENGAN GTKWave

cd D:\ARSIKOM\EL3011_2_20251119_13223048\0_prelab\Tugas1

# Kompilasi kedua file Verilog
iverilog -o mux_sim mux2to1_rv32i.v tb_mux2to1_rv32i.v

# Jalankan simulasi (file VCD akan dibuat oleh testbench)
vvp mux_sim

# Buka waveform dengan GTKWave
gtkwave mux_sim.vcd

cd D:\ARSIKOM\EL3011_2_20251119_13223048\0_prelab\Tugas2

# Kompilasi kedua file Verilog
iverilog -o adder_sim pc_4_adder_rv32i.v tb_pc_4_adder_rv32i.v

# Jalankan simulasi (file VCD akan dibuat oleh testbench)
vvp adder_sim

# Buka waveform dengan GTKWave
gtkwave adder_sim.vcd

cd D:\ARSIKOM\EL3011_2_20251119_13223048\0_prelab\Tugas3

# Kompilasi kedua file Verilog
iverilog -o pc_sim pc_rv32i.v tb_pc_rv32i.v

# Jalankan simulasi (file VCD akan dibuat oleh testbench)
vvp pc_sim

# Buka waveform dengan GTKWave
gtkwave pc_sim.vcd
