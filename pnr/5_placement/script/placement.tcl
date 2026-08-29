#######################################################################
#		ASIC PHYSICAL DESIGN AUTOMATION SCRIPT 		      #
#######################################################################
# Author		: Khaled Gamal
# Project		: MIPS16
# Block/Top		: mips_16
# Technology		: saed90nm
# EDA Tool		: Synopsys (ICC2)
# Script Name 		: placement.tcl
# Usage 		: icc2_shell -f script/placement.tcl -output_log log/placement.log
# Prerequisites		: Powerplan created
# Creation Date		: 2026-08-26
# Educational 		: ITI_summer_camp_2026_R3
#######################################################################


#######################################################################
	# --------------- Variable setup ------------- #
#######################################################################

set design 	"mips_16"
set std_worst 	"saed90nm_max.db"
set target_library $std_worst
set corner 	"worst"

set project_dir "/mnt/hgfs/Shared_files/${design}"
set Lib_path    "/home/ICer/Downloads/Lib"
set dlib_path   "${project_dir}/pnr/2_design_lib/library"

set prev_stage      "powerplan"
set current_stage   "placement"

#######################################################################
	# --------------- dlib setup ------------- #
#######################################################################

open_block  ${dlib_path}/${design}.dlib:${design}_${prev_stage}.design

# copying the (clean) block from the previous stage (dlib) to just preserve it and work on the new one which is the present stage (floorplan)
#to make sure if any errors happened through the current stage, it will be easy to restore the previous stage
copy_block -from_block ${design}.dlib:${design}_${prev_stage}.design -to_block ${design}_${current_stage}

current_block ${design}_${current_stage}.design
start_gui

#######################################################################
	# --------------- Important Checks ------------- #
#######################################################################

# --- Ensure the PG network is good Execpt Std cells because not placed
check_pg_connectivity -check_std_cell_pins none
# --- Catch PG shorts/spacing issues early before placement
check_pg_drc -ignore_std_cells

# --- Ensure all required stack-ups are present for PG.
check_pg_missing_vias
# --- Legality check before placement for Macros and IPs (not required at this stage)
# check_legality -verbose

# --- check for issues that could block placement (most important)
check_design -checks pre_placement_stage


#######################################################################
	# --------------- Placement options global settings ------------- #
#######################################################################
# These are some constraints that we define in the tool to tweak the placement engine (can be accessed from file -> application options in the GUI)

# --- Enable advanced legalizer for better legalization quality and row alignment.
set_app_options -name place.legalize.enable_advanced_legalizer   -value true
set_app_options -name place.legalize.legalizer_search_and_repair -value true
# --- Let placer control density and timing automatically < balance timing vs congestion>
set_app_options -name place.coarse.auto_density_control -value true
set_app_options -name place.coarse.auto_timing_control -value true
# --- Improves legalization predictability during coarse placeme
set_app_options -name place.coarse.legalizer_driven_placement -value true
# --- If you need continue without def file
set_app_options -list {place.coarse.continue_on_missing_scandef {true}}
set_app_options -list {place.coarse.detect_detours {true}}

# --- OPtimizations options
# --- Limit Fanout of Tie cell/fanout nets
set_app_options -list {opt.tie_cell.max_fanout 1}
set_app_options -list {opt.common.max_fanout {10}}

# --- Limit the maximum density value
set_app_options -list {place.coarse.max_density {0.3}}

# --- Enhance for timing
set_app_options -list {opt.timing.effort {high}}
# --- Enhance for Congestion
set_app_options -list {place_opt.congestion.effort {high}}

# ---- Prefix for Inserted Cells through HFNS
set_app_options -name opt.common.user_instance_name_prefix -value "PLACE_"


#######################################################################
	# --------------- Handled Ideal network ------------- #
#######################################################################

report_ideal_network
remove_ideal_network {fun_reset scan_reset test_mode}
# --- Keep clocks ideal during placement (CTS will build them later)
report_ideal_network


#######################################################################
	# --------------- Detailed Placement ------------- #
#######################################################################

# ---- Detailed Placement divided to { Coarse placment , legalized placement }
# --- Performs coarse {approximate locations for cells, Cells overlap,No logic optimization }
create_placement -effort high                 \
                 -timing_driven               \
                 -congestion                  \
                 -congestion_effort high
# ---- Legalized placement each illegal cell will be legal location
legalize_placement -incremental

report_net_fanout -threshold 20


#######################################################################
	# --------------- Attribute Cell ------------- #
#######################################################################

# --- TO be report all atrbuite about specfic cell
report_attributes -application -nosplit [get_lib_cell */TIEH] > TIEH_attr.rpt
# --- Change some attrbuite saed90nm_max_hvt/TIEL_HVT
set_attribute [get_lib_cells */*TIEH*] dont_touch false
set_attribute [get_lib_cells */*TIEL*] dont_touch false

set_attribute [get_lib_cells */*TIEL*] dont_use false
set_attribute [get_lib_cells */*TIEH*] dont_use false


#######################################################################
	# --------------- placement optimization ------------- #
#######################################################################

place_opt
sizeof_collection [get_cells "PLACE_*"]
#-- get_lib_cells >> INV/BUFF >> LEF (NDM Creation as layout view)
# ---- not found Inv/BUFF cells to implement HFS
# --- congestion is found to be a problem after placement and optimization It can improve
# refine_opt

#######################################################################
	# --------------- Spare Cells ------------- #
#######################################################################

# ---- Get library cells to insert as spare cells 
get_lib_cell */*NAND*
# --- add spare cells without legalized
add_spare_cells -num_cells {NAND2X1_HVT 20
                            INVX1   4
                            OR2X1   3
                            SDFFX1  3
                            MUX21X1 4}                       \
                -cell_name SpareCell                         \
                -random_distribution                         \
                -input_pin_connect_type tie_low
set spare_cells [get_cells *SpareCell*]
# --- Spread Cells
spread_spare_cells -cells $spare_cells
# --- legalized Sparecells
place_eco_cells -cells $spare_cells -legalize_only


#######################################################################
	# --------------- Tie Cells ------------- #
#######################################################################

set tie_cells_low      [get_lib_cells */*TIEL* ]
set tie_cells_high     [get_lib_cells */*TIEH* ]
set_attribute [get_lib_cells */*TIEH*] dont_touch false
add_tie_cells -objects $spare_cells              \
              -tie_low_lib_cells $tie_cells_low  \
              -tie_high_lib_cells $tie_cells_high \
              -legalize
set_dont_touch $spare_cells
set_fixed_objects $spare_cells

#######################################################################
	# --------------- Connect PG ------------- #
#######################################################################

connect_pg_net -net "VDD" [get_pins -hierarchical "*/VDD" ]
connect_pg_net -net "VSS" [get_pins -hierarchical "*/VSS" ]

#######################################################################
	# --------------- Files Handling ------------- #
#######################################################################

sh rm    -r ../results/reports
sh rm    -r ../results/outputs
sh mkdir -p ../results/reports
sh mkdir -p ../results/outputs

#######################################################################
	# --------------- Reports ------------- #
#######################################################################

report_cell                                > ../results/reports/cells.rpt
report_nets                                > ../results/reports/nets.rpt
report_qor                                 > ../results/reports/qor.rpt
report_timing                              > ../results/reports/timing.rpt
report_timing -delay max -max_paths 2      > ../results/reports/two_critical_path_setup.rpt
report_utilization                         > ../results/reports/utilization.rpt
get_placement_blockages                    > ../results/reports/Blockage.rpt
check_pg_drc                               > ../results/reports/pg_drc.rpt
check_pg_connectivity                      > ../results/reports/pg_connectivity.rpt
check_pg_missing_vias                      > ../results/reports/missing_via.rpt

#######################################################################
	# --------------- Save Block ------------- #
#######################################################################

write_def                  ../results/outputs/${design}.def
write_verilog -include {all} ../results/outputs/${design}.v
write_sdc -output          ../results/outputs/${design}.sdc

save_block
