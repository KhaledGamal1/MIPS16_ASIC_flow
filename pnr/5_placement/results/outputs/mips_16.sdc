################################################################################
#
# Design name:  mips_16_placement
#
# Created by icc2 write_sdc on Sat Aug 29 10:04:51 2026
#
################################################################################

set sdc_version 2.1
set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA

################################################################################
#
# Units
# time_unit               : 1e-09
# resistance_unit         : 1000000
# capacitive_load_unit    : 1e-15
# voltage_unit            : 1
# current_unit            : 1e-06
# power_unit              : 1e-12
################################################################################


# Mode: default
# Corner: default
# Scenario: default

# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 44
set_case_analysis 0 [get_ports {test_mode}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 50
create_clock -name fun_clk -period 15 -waveform {0 7.5} [get_ports {fun_clk}]
set_load -pin_load 5 [get_ports {pc_out[15]}]
set_load -pin_load 5 [get_ports {pc_out[14]}]
set_load -pin_load 5 [get_ports {pc_out[13]}]
set_load -pin_load 5 [get_ports {pc_out[12]}]
set_load -pin_load 5 [get_ports {pc_out[11]}]
set_load -pin_load 5 [get_ports {pc_out[10]}]
set_load -pin_load 5 [get_ports {pc_out[9]}]
set_load -pin_load 5 [get_ports {pc_out[8]}]
set_load -pin_load 5 [get_ports {pc_out[7]}]
set_load -pin_load 5 [get_ports {pc_out[6]}]
set_load -pin_load 5 [get_ports {pc_out[5]}]
set_load -pin_load 5 [get_ports {pc_out[4]}]
set_load -pin_load 5 [get_ports {pc_out[3]}]
set_load -pin_load 5 [get_ports {pc_out[2]}]
set_load -pin_load 5 [get_ports {pc_out[1]}]
set_load -pin_load 5 [get_ports {pc_out[0]}]
set_load -pin_load 5 [get_ports {alu_result[15]}]
set_load -pin_load 5 [get_ports {alu_result[14]}]
set_load -pin_load 5 [get_ports {alu_result[13]}]
set_load -pin_load 5 [get_ports {alu_result[12]}]
set_load -pin_load 5 [get_ports {alu_result[11]}]
set_load -pin_load 5 [get_ports {alu_result[10]}]
set_load -pin_load 5 [get_ports {alu_result[9]}]
set_load -pin_load 5 [get_ports {alu_result[8]}]
set_load -pin_load 5 [get_ports {alu_result[7]}]
set_load -pin_load 5 [get_ports {alu_result[6]}]
set_load -pin_load 5 [get_ports {alu_result[5]}]
set_load -pin_load 5 [get_ports {alu_result[4]}]
set_load -pin_load 5 [get_ports {alu_result[3]}]
set_load -pin_load 5 [get_ports {alu_result[2]}]
set_load -pin_load 5 [get_ports {alu_result[1]}]
set_load -pin_load 5 [get_ports {alu_result[0]}]
set_ideal_network [get_ports {fun_clk}]
set_ideal_network [get_ports {scan_clk}]
set_clock_uncertainty 0.45 [get_ports {fun_clk}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 51
set_input_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {fun_reset}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 52
set_input_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {scan_clk}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 53
set_input_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {scan_reset}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 54
set_input_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {test_mode}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 55
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[15]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 56
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[14]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 57
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[13]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 58
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[12]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 59
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[11]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 60
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[10]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 61
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[9]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 62
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[8]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 63
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[7]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 64
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[6]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 65
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[5]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 66
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[4]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 67
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[3]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 68
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[2]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 69
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[1]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 70
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {pc_out[0]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 71
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[15]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 72
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[14]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 73
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[13]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 74
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[12]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 75
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[11]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 76
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[10]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 77
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[9]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 78
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[8]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 79
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[7]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 80
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[6]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 81
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[5]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 82
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[4]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 83
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[3]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 84
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[2]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 85
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[1]}]
# /mnt/hgfs/Shared_files/mips_16/syn/results/worst/outputs/mips_16.sdc, line 86
set_output_delay -clock [get_clocks {fun_clk}] 1.5 [get_ports {alu_result[0]}]
set_max_transition 0.5 [current_design]
set_max_capacitance 50 [current_design]
