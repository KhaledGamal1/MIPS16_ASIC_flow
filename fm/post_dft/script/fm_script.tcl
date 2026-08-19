
# Defining General Variables
set worst_case         "saed90nm_max_hvt.db"
set corner             "worst"
set design 	       "mips_16"

#######################################################################
	# --------------- Search Path ------------- #
#######################################################################

lappend search_path /home/ICer/Downloads/Lib/synopsys/models
lappend search_path /mnt/hgfs/Shared_files/mips_16/syn/rtl

#######################################################################
	# --------------- Define Top module ------------- #
#######################################################################
set top_module mips_16

#######################################################################
	# --------------- Formality Setup File ------------- #
#######################################################################

set synopsys_auto_setup true

set_svf "../../../dft/run/${design}.svf"

#######################################################################
	# --------------- Read Reference Tech libs ------------- #
#######################################################################

set SSLIB_HVT "saed90nm_max_hvt.db"

read_db -container Ref [list $SSLIB_HVT]


#######################################################################
	# --------------- Read Reference Design files ------------- #
#######################################################################

read_verilog -container Ref [glob /mnt/hgfs/Shared_files/mips_16/syn/rtl/*.v]

#######################################################################
	# --------------- Set the top Refernce Design ------------- #
#######################################################################

set_reference_design mips_16
set_top mips_16


#######################################################################
	# --------------- Read Implementation Tech libs ------------- #
#######################################################################
read_db -container Imp [list $SSLIB_HVT]

#######################################################################
	# --------------- Read Implementation design files ------------- #
#######################################################################

read_verilog -container Imp -netlist "/mnt/hgfs/Shared_files/mips_16/dft/results/$corner/outputs/${design}.v"


#######################################################################
	# --------------- Set the top Implementation Design ------------- #
#######################################################################

set_implementation_design mips_16
set_top mips_16


#######################################################################
	# --------------- Constants ------------- #
#######################################################################

# Test mode
set_constant Ref:/WORK/*/test_mode 0
set_constant Imp:/WORK/*/test_mode 0

# Matching compare points 
match

# Verify 

set successful [verify]
if {!$successful} {
diagnose
analyze_points -failing
} else {
puts "successful"
}


report_passing_points 			> ../reports/passing_points.rpt
report_failing_points 			> ../reports/failing_points.rpt
report_aborted_points 			> ../reports/aborted_points.rpt
report_unverified_points 		> ../reports/unverified_points.rpt



