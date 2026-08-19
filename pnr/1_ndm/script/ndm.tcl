######################################################################################
# Project name 		: MIPS_16
# Target Technology 	: saed90nm
# Step Name 		: STD_NDM Creation
# Target Tool 		: Library Manager (Synopsys)
# Created by 		: Khaled Gamal
# Version 		: 1.00
######################################################################################



######################################################################################
	# ------------------ WorkSpace ------------------ #
######################################################################################

# Depend on (technology file) process of creating a reference library 
set tech_file "/home/ICer/Downloads/Lib/process/astro/tech/astroTechFile.tf"
create_workspace -flow exploration -technology $tech_file saed90_ndm

######################################################################################
	# ------------------ Activate Options ------------------ #
######################################################################################
# To save design and layout views in the NDM

# It ensure that physical-only cells like decap cells, end cap cells 
# and filler cells are not accedintally dropped during NDM creation
set_app_options -list {lib.workspace.keep_all_physical_cells	 {true}	}  

# Creates the view used for PnR 
set_app_options -list {lib.workspace.save_design_views		 {true}	}

# Creates the view used for GDS export and DRC
set_app_options -list {lib.workspace.save_layout_views		 {true}	}


######################################################################################
	# ------------------ Logic Files (.db) ------------------ #
######################################################################################

read_db "/home/ICer/Downloads/Lib/synopsys/models/saed90nm_max.db"


######################################################################################
	# ------------------ Physical Files (.lef) ------------------ #
######################################################################################

read_lef "/home/ICer/Downloads/Lib/lef/saed90nmEditted.lef"

######################################################################################
	# ------------------ Group Libraries ------------------ #
######################################################################################

# Based on (logical, physical) source libraries in the group
group_libs


######################################################################################
	# ------------------ Reference library creation ------------------ #
######################################################################################
# Checks and commits workspaces in one step

process_workspaces -directory /mnt/hgfs/Shared_files/mips_16/pnr/1_ndm/ndm




