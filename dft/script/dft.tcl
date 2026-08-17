#######################################################################
#		ASIC PHYSICAL DESIGN AUTOMATION SCRIPT 		      #
#######################################################################
# Author	: Khaled Gamal
# Project	: MIPS16
# Block/Top	: mips_16
# Technology	: saed90nm
# EDA Tool	: Synopsys Design Compiler (DC)
# Purpose	: Translate RTL to logic gates and initial met setup time by ideal clock.
# Usage		: dc_shell -f script/syn.tcl -output_log log/syn.log
# Prerequisites	: RTL clean and syntheizable
# Creation Date	: 2026-08-16
# Educational 	: ITI_summer_camp_2026_R3
#######################################################################


#######################################################################
	# --------------- Library setup ------------- #
#######################################################################

# Defining General Variables
set best_case 		"saed90nm_min_lvt.db"		
set worst_case 		"saed90nm_max_hvt.db"
set corner     		"worst"


# Tool Variables
set_app_var search_path 	"/home/ICer/Downloads/Lib/synopsys/models"
set_app_var target_library 	"$worst_case"
set_app_var link_library 	"* $target_library"        # " * " is for Designware and symbol library 


#######################################################################
	# --------------- work setup ------------- #
#######################################################################
sh rm -rf work
sh mkdir -p work
define_design_lib work -path ./work


#######################################################################
	# --------------- Design setup ------------- #
#######################################################################

# Design name
set design mips_16

# SVF file, important for Formal Verification
set_svf ${design}.svf

#######################################################################
	# --------------- Read Netlist ------------- #
#######################################################################

# Reading DDC netlist (binary format) and set current design
read_ddc ../../syn/results/$corner/outputs/${design}.ddc
current_design $design

#######################################################################
	# --------------- Read SDC ------------- #
#######################################################################

# Reading design constraints file (output from synthesis)
read_sdc ../../syn/results/$corner/outputs/${design}.sdc
current_design $design



#######################################################################
	# --------------- Compile ------------- #
#######################################################################

# Solve problem related to feedthrough, constant shared, outputs drive same net
set_fix_multiple_port_nets -all -buffer_constants

# Optimizing addition, sub, multiplication blocks for speed 
set_dp_smartgen_options -optimize_for speed

set_critical_range 1.0 $design; # used to report the critical paths within the critical range specified

# Scan Replacement and DFT insertion
compile -scan -map_effort high -incremental_mapping
compile -scan -map_effort high -incremental_mapping

#######################################################################
	# --------------- Source DFT Constraints ------------- #
#######################################################################
source -e -v ../cons/cons.tcl


#######################################################################
	# --------------- Test Protocol ------------- #
#######################################################################

create_test_protocol

#######################################################################
	# --------------- Scan Stitching & Checks ------------- #
#######################################################################

# Checking DRCs
dft_drc

# DFT stitching
insert_dft

# checking drc after stitching and showing the dft coverage percentage
dft_drc -coverage_estimate

# showing design scan chains
preview_dft

compile -scan -incremental_mapping;    # For more optimization



#######################################################################
	# --------------- Output Setup ------------- #
#######################################################################
sh rm -rf 	../results/$corner
sh mkdir -p 	../results/$corner
sh mkdir -p 	../results/$corner/reports
sh mkdir -p 	../results/$corner/outputs



#######################################################################
	# --------------- Reports ------------- #
#######################################################################
report_timing -delay_type max -max_path 2 				> ../results/$corner/reports/synth_timing_setup.rpt
report_timing -delay_type min -max_paths 2 				> ../results/$corner/reports/synth_timing_hold.rpt	
report_timing -delay_type max -slack_lesser_than 0 -max_paths 2 	> ../results/$corner/reports/synth_timing_setup_violated.rpt
report_timing -delay_type min -slack_lesser_than 0 -max_paths 2 	> ../results/$corner/reports/synth_timing_hold_violated.rpt

dft_drc -verbose 							> ../results/$corner/reports/drc.rpt
report_scan_path -chain all 						> ../results/$corner/reports/dft_violations.rpt
report_dft_signal -view existing_dft 					> ../results/$corner/reports/dft_existing.rpt
report_dft_signal -view spec 						> ../results/$corner/reports/dft_spec.rpt
dft_drc -coverage_estimate 						> ../results/$corner/reports/dft_drc_coverage.rpt

report_net_fanout -threshold 50 					> ../results/$corner/reports/dft_high_fanout.rpt

report_clocks 								> ../results/$corner/reports/clocks.rpt
report_area 								> ../results/$corner/reports/synth_area.rpt
report_cell 								> ../results/$corner/reports/synth_cells.rpt
report_qor 								> ../results/$corner/reports/synth_qor.rpt
report_power  								> ../results/$corner/reports/synth_power.rpt
report_constraint -all_violators	 				> ../results/$corner/reports/synth_violations.rpt


#######################################################################
	# --------------- Output ------------- #
#######################################################################
set verilogout_no_tri ture
set verilogout_equation false
#change_names -rule verilog

# Netlist and Verilog
write -format ddc -hierarchy -output ../results/$corner/outputs/${design}.ddc
write -format verilog -hierarchy -output ../results/$corner/outputs/${design}.v

# SDC file (Synopsys Design Constraints) >> for PNR Tool
write_sdc ../results/$corner/outputs/${design}.sdc;	# Synopsys design constraints

# SDF file (Standard Delay Format)
write_sdf ../results/$corner/outputs/${design}.sdf; 	# standard delay format

# Test Model (CTL file) >> For ATPG tool
write_test_model -output ../results/$corner/outputs/${design}.ctl

# SPF file (STIL Protocol File)
write_test_protocol -out ../results/$corner/outputs/${design}.spf

# def file (reorder scan chains placement step)
write_scan_def -output ../results/$corner/outputs/${design}.def
set_svf -off



















