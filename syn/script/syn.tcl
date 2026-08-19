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
# Creation Date	: 2026-08-14
# Educational 	: ITI_summer_camp_2026_R3
#######################################################################


#######################################################################
	# --------------- Library setup ------------- #
#######################################################################

# Defining General Variables
set worst_case         "saed90nm_max.db"
set corner             "worst"


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
	# --------------- Analyze RTL ------------- #
#######################################################################

# Check syntax errors and generate intermediate files
analyze -library work -format verilog ../rtl/${design}.v


#######################################################################
	# --------------- Elaborate ------------- #
#######################################################################

# Translate from RTL to getech netlist and check linting and design issues
elaborate $design -lib work

# Make Top Level Design 
current_design $design

# Debug warnings through elaborate
check_design

#######################################################################
	# --------------- Constraints ------------- #
#######################################################################
source -e -v ../cons/cons.tcl


#######################################################################
	# --------------- Compile ------------- #
#######################################################################

set_critical_range 1.00 $design; # used to report the critical paths within the critical range specified

# map all RTL MUXs to MUX cell instead of (AOI) cells to reduce congestion
set compile_prefer_mux true
set hdlin_infer_mux all

# Mapping and Optimization 
compile -map_effort high -incremental_mapping
compile -map_effort high -incremental_mapping


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
report_clocks 								> ../results/$corner/reports/clocks.rpt
report_area 								> ../results/$corner/reports/synth_area.rpt
report_cell 								> ../results/$corner/reports/synth_cells.rpt
report_qor 								> ../results/$corner/reports/synth_qor.rpt
report_power  								> ../results/$corner/reports/synth_power.rpt
report_timing -delay_type max -max_path 2 				> ../results/$corner/reports/synth_timing_setup.rpt
report_timing -delay_type max -slack_lesser_than 0 -max_paths 2 	> ../results/$corner/reports/synth_timing_setup_violated.rpt
report_timing -delay_type min -max_paths 2 				> ../results/$corner/reports/synth_timing_hold.rpt	
report_constraint -all_violators	 				> ../results/$corner/reports/synth_violations.rpt


#######################################################################
	# --------------- Output ------------- #
#######################################################################
set verilogout_no_tri ture
set verilogout_equation false
change_names -rule verilog

# Netlist
write -f ddc -hierarchy -output ../results/$corner/outputs/${design}.ddc
write -hierarchy -format verilog -output ../results/$corner/outputs/${design}.v

# Another
write_sdf ../results/$corner/outputs/${design}.sdf; 	# standard delay format
write_sdc ../results/$corner/outputs/${design}.sdc;	# Synopsys design constraints


set_svf -off




