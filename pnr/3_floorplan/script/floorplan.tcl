#######################################################################
#		ASIC PHYSICAL DESIGN AUTOMATION SCRIPT 		      #
#######################################################################
# Author	    : Khaled Gamal
# Project	    : MIPS16
# Block/Top	    : mips_16
# Technology	: saed90nm
# EDA Tool	    : Synopsys (ICC2)
# Usage		    : icc2_shell -f script/floorplan.tcl -output_log log/floorplan.log
# Prerequisites	: Design Library created
# Creation Date	: 2026-08-20
# Educational 	: ITI_summer_camp_2026_R3
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

set prev_stage      "dlib"
set current_stage   "floorplan"

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
	# --------------- Layers setup ------------- #
#######################################################################
# Metal layers directions
set_attribute [get_layer {M1 M3 M5 M7 M9}] routing_direction horizontal
set_attribute [get_layer {M2 M4 M6 M8 MRDL}] routing_direction vertical;    # MRDL (Metal Redistribution Layer) is an extra-thick layer on the absolute top of the die used for power supply

# site def attribute (get unit tile name from the technology file)
set Name_unit [get_site_defs]
set_attribute $Name_unit is_default true

# flipping the unit tiles on the Y-axis to make common Vdd and Vss between every two site rows
set_attribute $Name_unit symmetry {Y}

# set_attribute [get_layers {M1}] track_offset 0.037

#######################################################################
	# --------------- Initialize Floorplan ------------- #
#######################################################################

# All parameters related to core and die
initialize_floorplan    -control_type core \
                        -core_utilization 0.6 \
                        -shape R \
                        -core_offset {10} \
                        -flip_first_row true \
                        -side_ratio {1 1}

#######################################################################
	# --------------- Placement Pins ------------- #
#######################################################################
# Auto pins placement (not preffered, manual is better)
place_pins -self -ports [get_ports *]

#######################################################################
	# --------------- Blockage Placement ------------- #
#######################################################################
#create_placement_blockage -boundary {{30 30} {50 50}} -name B1 -type hard

#create_placement_blockage -boundary {{5 3} {7 5}} -name B2 -type partial -blockage_percentage 40

#create_placement_blockage -boundary {{7 3} {9 5}} -name B3 -type soft

#######################################################################
	# --------------- TAPCell Placement ------------- #
#######################################################################
#create_tap_cells -lib_cell [get_lib_cell */SAEDVT14_TAPDS] -pattern stagger -distance 40

#seizeof_collection [get_cells tap*]
# remove_cell tap*

#create_tap_cells -lib_cell [get_lib_cell */SAEDVT14_TAPDS] -pattern every_row -distance 10
#get_cells tap*
# remove_cell tap*

#create_tap_cells -lib_cell [get_lib_cell */SAEDVT14_TAPDS] -pattern every_other_row -distance 10
#size_of[get_cells tap*]
# remove_cell tap*

#######################################################################
	# --------------- Files Handling ------------- #
#######################################################################
sh rm    -r ../results/reports
sh rm    -r ../results/outputs
sh mkdir -p ../results/reports
sh mkdir -p ../results/outputs


#######################################################################
	# --------------- Reports & Outputs ------------- #
#######################################################################
report_qor 			> ../results/reports/qor.rpt
report_utilization 		> ../results/reports/utilization_default.rpt
get_placement_blockages 	> ../results/reports/blockage.rpt

write_def 			  ../results/outputs/floorplan.def			
#######################################################################
	# --------------- Save Block ------------- #
#######################################################################
save_block -as ${design}_${current_stage} ${design}.dlib:${design}_${current_stage}.design
