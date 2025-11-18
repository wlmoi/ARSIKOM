## Copyright (C) 1991-2010 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.

## VENDOR "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 9.1 Build 350 03/24/2010 Service Pack 2 SJ Web Edition"

## DATE "11/05/2025 14:39:36"

## 
## Device: Altera EP2S15F484C3 Package FBGA484
## 

## 
## This Tcl script should be used for PrimeTime (Verilog) only
## 

## This file can be sourced in primetime

set report_default_significant_digits 3
set hierarchy_separator .

set quartus_root "c:/altera/91sp2/quartus/"
set search_path [list . [format "%s%s" $quartus_root "eda/synopsys/primetime/lib"]  ]

set link_path [list *  stratixii_lcell_comb_lib.db  stratixii_lcell_ff_lib.db  stratixii_asynch_io_lib.db  stratixii_io_register_lib.db  stratixii_termination_lib.db  bb2_lib.db  stratixii_ram_internal_lib.db  stratixii_memory_register_lib.db  stratixii_memory_addr_register_lib.db  stratixii_mac_out_internal_lib.db stratixii_mac_mult_internal_lib.db  stratixii_mac_register_lib.db  stratixii_lvds_receiver_lib.db stratixii_lvds_transmitter_lib.db  stratixii_asmiblock_lib.db stratixii_crcblock_lib.db  stratixii_jtag_lib.db stratixii_rublock_lib.db  stratixii_pll_lib.db  stratixii_dll_lib.db alt_vtl.db]

read_verilog  stratixii_all_pt.v 

##########################
## DESIGN ENTRY SECTION ##
##########################

read_verilog  reg_file_rv32i.vo
current_design reg_file_rv32i
link
## Set variable timing_propagate_single_condition_min_slew to false only for versions 2004.06 and earlier
regexp {([1-9][0-9][0-9][0-9]\.[0-9][0-9])} $sh_product_version dummy version
if { [string compare "2004.06" $version ] != -1 } {
   set timing_propagate_single_condition_min_slew false
}
set_operating_conditions -analysis_type single
read_sdf reg_file_rv32i_v.sdo

################################
## TIMING CONSTRAINTS SECTION ##
################################


## Start clock definition ##
# WARNING:  The required clock period is not set. The default value (100 ns) is used. 
create_clock -period 100.000 -waveform {0.000 50.000} [get_ports { clock } ] -name clock  

set_propagated_clock [all_clocks]
## End clock definition ##

## Start create collections ##
## End create collections ##

## Start global settings ##
## End global settings ##

## Start collection commands definition ##

## End collection commands definition ##

## Start individual pin commands definition ##
## End individual pin commands definition ##

## Start Output pin capacitance definition ##
set_load -pin_load 0 [get_ports { rs1[0] } ]
set_load -pin_load 0 [get_ports { rs1[10] } ]
set_load -pin_load 0 [get_ports { rs1[11] } ]
set_load -pin_load 0 [get_ports { rs1[12] } ]
set_load -pin_load 0 [get_ports { rs1[13] } ]
set_load -pin_load 0 [get_ports { rs1[14] } ]
set_load -pin_load 0 [get_ports { rs1[15] } ]
set_load -pin_load 0 [get_ports { rs1[16] } ]
set_load -pin_load 0 [get_ports { rs1[17] } ]
set_load -pin_load 0 [get_ports { rs1[18] } ]
set_load -pin_load 0 [get_ports { rs1[19] } ]
set_load -pin_load 0 [get_ports { rs1[1] } ]
set_load -pin_load 0 [get_ports { rs1[20] } ]
set_load -pin_load 0 [get_ports { rs1[21] } ]
set_load -pin_load 0 [get_ports { rs1[22] } ]
set_load -pin_load 0 [get_ports { rs1[23] } ]
set_load -pin_load 0 [get_ports { rs1[24] } ]
set_load -pin_load 0 [get_ports { rs1[25] } ]
set_load -pin_load 0 [get_ports { rs1[26] } ]
set_load -pin_load 0 [get_ports { rs1[27] } ]
set_load -pin_load 0 [get_ports { rs1[28] } ]
set_load -pin_load 0 [get_ports { rs1[29] } ]
set_load -pin_load 0 [get_ports { rs1[2] } ]
set_load -pin_load 0 [get_ports { rs1[30] } ]
set_load -pin_load 0 [get_ports { rs1[31] } ]
set_load -pin_load 0 [get_ports { rs1[3] } ]
set_load -pin_load 0 [get_ports { rs1[4] } ]
set_load -pin_load 0 [get_ports { rs1[5] } ]
set_load -pin_load 0 [get_ports { rs1[6] } ]
set_load -pin_load 0 [get_ports { rs1[7] } ]
set_load -pin_load 0 [get_ports { rs1[8] } ]
set_load -pin_load 0 [get_ports { rs1[9] } ]
set_load -pin_load 0 [get_ports { rs2[0] } ]
set_load -pin_load 0 [get_ports { rs2[10] } ]
set_load -pin_load 0 [get_ports { rs2[11] } ]
set_load -pin_load 0 [get_ports { rs2[12] } ]
set_load -pin_load 0 [get_ports { rs2[13] } ]
set_load -pin_load 0 [get_ports { rs2[14] } ]
set_load -pin_load 0 [get_ports { rs2[15] } ]
set_load -pin_load 0 [get_ports { rs2[16] } ]
set_load -pin_load 0 [get_ports { rs2[17] } ]
set_load -pin_load 0 [get_ports { rs2[18] } ]
set_load -pin_load 0 [get_ports { rs2[19] } ]
set_load -pin_load 0 [get_ports { rs2[1] } ]
set_load -pin_load 0 [get_ports { rs2[20] } ]
set_load -pin_load 0 [get_ports { rs2[21] } ]
set_load -pin_load 0 [get_ports { rs2[22] } ]
set_load -pin_load 0 [get_ports { rs2[23] } ]
set_load -pin_load 0 [get_ports { rs2[24] } ]
set_load -pin_load 0 [get_ports { rs2[25] } ]
set_load -pin_load 0 [get_ports { rs2[26] } ]
set_load -pin_load 0 [get_ports { rs2[27] } ]
set_load -pin_load 0 [get_ports { rs2[28] } ]
set_load -pin_load 0 [get_ports { rs2[29] } ]
set_load -pin_load 0 [get_ports { rs2[2] } ]
set_load -pin_load 0 [get_ports { rs2[30] } ]
set_load -pin_load 0 [get_ports { rs2[31] } ]
set_load -pin_load 0 [get_ports { rs2[3] } ]
set_load -pin_load 0 [get_ports { rs2[4] } ]
set_load -pin_load 0 [get_ports { rs2[5] } ]
set_load -pin_load 0 [get_ports { rs2[6] } ]
set_load -pin_load 0 [get_ports { rs2[7] } ]
set_load -pin_load 0 [get_ports { rs2[8] } ]
set_load -pin_load 0 [get_ports { rs2[9] } ]
## End Output pin capacitance definition ##

## Start clock uncertainty definition ##
## End clock uncertainty definition ##

## Start Multicycle and Cut Path definition ##
## End Multicycle and Cut Path definition ##

## Destroy Collections ##

update_timing
