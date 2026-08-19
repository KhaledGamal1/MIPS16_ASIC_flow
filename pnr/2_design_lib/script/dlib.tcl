######################################################################################
# Project name 		: MIPS_16
# Target Technology 	: saed90nm
# Step Name 		: Design Library Creation
# Target Tool 		: Library Manager (Synopsys)
# Created by 		: Khaled Gamal
# Version 		: 1.00
######################################################################################



######################################################################################
	# ------------------ Variable setup ------------------ #
######################################################################################

set design 	"mips_16"
set std_worst 	"saed90nm_max.db"
set target_library $std_worst
set corner 	"worst"

# Project directory
set project_dir "/mnt/hgfs/Shared_files/$design"

# Technology file directory
set TECH_FILE "/home/ICer/Downloads/Lib/process/astro/tech/astroTechFile.tf"

# NDM library directory 
set reference_library [glob /mnt/hgfs/Shared_files/$design/pnr/1_ndm/ndm/*.ndm]
# Link library 
set_app_var link_library [list * $target_library]

######################################################################################
	# ------------------ DesignLib Creation ------------------ #
######################################################################################
# Technology file and reference library
create_lib -technology $TECH_FILE -ref_libs $reference_library  ../library/${design}.dlib

######################################################################################
	# ------------------ Read Netlist ------------------ #
######################################################################################
read_verilog -top ${design} ${project_dir}/syn/results/$corner/outputs/${design}.v
link_block;      # Links the Netlist with the NDM

######################################################################################
	# ------------------ Read SDC ------------------ #
######################################################################################
read_sdc ${project_dir}/syn/results/$corner/outputs/${design}.sdc


######################################################################################
	# ------------------ Read TLU+ files ------------------ #
######################################################################################
set tech_map 	"/home/ICer/Downloads/Lib/process/astro/tech/tech2itf.map"
set tluplus 	"/home/ICer/Downloads/Lib/Technology_Kit/starrcxt/tluplus"



# Read the TLU+ file and associate it with the corresponding map file 
read_parasitic_tech 	-layermap ${tech_map} \
			-tlup ${tluplus}/saed90nm_1p9m_1t_Cmax.tluplus \
			-name tlup_max

read_parasitic_tech 	-layermap ${tech_map} \
			-tlup ${tluplus}/saed90nm_1p9m_1t_Cmin.tluplus \
			-name tlup_min

set_parasitic_parameters -late_spec tlup_max -early_spec tlup_min



######################################################################################
	# ------------------ Save Block ------------------ #
######################################################################################

save_block -as ${design}_dlib ${design}.dlib:${design}.design
# 		Label Name 	Lib_Name    :    Block_Name.views


