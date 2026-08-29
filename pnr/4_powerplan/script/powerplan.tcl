#######################################################################
#		ASIC PHYSICAL DESIGN AUTOMATION SCRIPT 		      #
#######################################################################
# Author		: Khaled Gamal
# Project		: MIPS16
# Block/Top		: mips_16
# Technology		: saed90nm
# EDA Tool		: Synopsys (ICC2)
# Usage 		: icc2_shell -f script/powerplan.tcl -output_log log/powerplan.log
# Prerequisites		: Floorplan created
# Creation Date		: 2026-08-24
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

set prev_stage      "floorplan"
set current_stage   "powerplan"

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
	# --------------- Initialization ------------- #
#######################################################################
remove_pg_via_master_rules 	-all
remove_pg_patterns 		-all
remove_pg_strategies 		-all
remove_pg_strategy 		-all

# Creation VDD and VSS nets for Network
create_net -power VDD
create_net -ground VSS

#######################################################################
	# --------------- Ring VDD/VSS ------------- #
#######################################################################
# Create region, patterns, Define strategies, compile strategies
# variables
set ring_offset 	1;
set ring_width 		3;
set ring_spacing 	4;
set hm_top 		M9;
set vm_top 		M8;
set name_strategy core_ring;

# Create region to define region pg network
create_pg_region power_ring_region -core -expand_by_edge 	\
			"{{side: 1} {offset: $ring_offset}} 	\
			 {{side: 2} {offset: $ring_offset}} 	\
			 {{side: 3} {offset: $ring_offset}} 	\
			 {{side: 4} {offset: $ring_offset}}"


# Create pattern rings structure {Layers, width, space}
create_pg_ring_pattern ring_pattern 				\
			-horizontal_layer 	$hm_top 	-vertical_layer 	$vm_top		\
			-horizontal_width 	$ring_width 	-vertical_width 	$ring_width 	\
			-horizontal_spacing 	$ring_spacing 	-vertical_spacing 	$ring_spacing 	

# strategy for design rings
set_pg_strategy $name_strategy \
		-pg_regions 	{ power_ring_region } 	\
		-pattern 	{{ name: ring_pattern} {nets: "VDD VSS"}}


compile_pg -strategies $name_strategy

# If you need last compile 
#compile_pg -undo


#######################################################################
	# --------------- Straps VDD/VSS ------------- #
#######################################################################
# Create Mesh/Straps pattern {layer, width, offset, Pitch}
create_pg_mesh_pattern straps_vddvss -layers \
					{{{vertical_layer 	: M8 } {width: 3} {pitch: 20} {spacing: interleaving} {offset:1}} \
					 {{horizontal_layer 	: M9 } {width: 3} {pitch: 20} {spacing: interleaving} {offset:1}}}

# Strategy for design mesh
set_pg_strategy mesh_vddvss -core \
		-pattern 	{{pattern: straps_vddvss} {nets: VDD VSS}} \
		-extension 	{{stop: design_boundary_and_generate_pin}}


# Compile/ Implement Mesh
compile_pg -strategies mesh_vddvss

# If you need remove last compile 
#compile_pg -undo


# Create Mesh 2
create_pg_mesh_pattern straps_vddvss2 -layers \
					{{{vertical_layer 	: M6 } {width: 1.5} {pitch: 30} {spacing: interleaving} {offset:1}} \
					 {{horizontal_layer 	: M7 } {width: 1.5} {pitch: 30} {spacing: interleaving} {offset:1}}}
				
# Strategy for design mesh
set_pg_strategy mesh_vddvss2 -core \
		-pattern 	{{pattern: straps_vddvss2} {nets: VDD VSS}} \
		-extension 	{{stop: design_boundary_and_generate_pin}}
		
		#-extension  	{{stop: outermost_ring}}


# Compile/ Implement Mesh
compile_pg -strategies mesh_vddvss2

# If you need remove last compile 
#compile_pg -undo


#######################################################################
	# --------------- Rails VDD/VSS ------------- #
#######################################################################
# Variables
set rail_strategy 	rails_M1;
set rail_pattern 	std_cell_rail;
set rail_layer 		M1;
set rail_width 		0.16;

# Create rails {layer, Width}
create_pg_std_cell_conn_pattern $rail_pattern -layer $rail_layer -rail_width $rail_width

# Define strategies
set_pg_strategy $rail_strategy -core -pattern {{name: std_cell_rail} {nets: VDD VSS}}
compile_pg -strategies $rail_strategy


# Connect pins of cells and submodules to rails
# hierarchical (include top module + sub modules)
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]


# Verify routing of PG nets satisfies technology design rules (physical DRCs)
check_pg_drc

# Connectivity check for PG networks, standard cell PG pins
check_pg_connectivity
check_pg_missing_vias



#######################################################################
	# --------------- VIAs VDD/VSS ------------- #
#######################################################################

#create_pg_vias -nets {VDD VSS} -from_layers M6 -to_layers M1 -drc no_checks
#set_via_def -via_def -pictch " X Y " -vias [get_vias * -filter "via_def.name == "] -size "1 10"
#set_via_def -via_def -pictch " X Y " -vias [get_vias * -filter "via_def.name == "] -size "1 10"

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

check_pg_drc                    > ../results/reports/pg_drc.rpt
check_pg_connectivity           > ../results/reports/pg_connectivity.rpt
check_pg_missing_vias           > ../results/reports/missing_via.rpt


write_verilog -include {all}    ../results/outputs/${design}.v
write_sdc -output               ../results/outputs/${design}.sdc
write_def 			../results/outputs/${design}.def
			
#######################################################################
	# --------------- Save Block ------------- #
#######################################################################
save_block -as ${design}_${current_stage} ${design}.dlib:${design}_${current_stage}.design
