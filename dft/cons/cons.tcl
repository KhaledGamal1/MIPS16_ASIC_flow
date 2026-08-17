
#######################################################################
	# --------------- Scan Configuration ------------- #
#######################################################################

set_scan_configuration -style multiplexed_flip_flop 	\
			-replace true 			\
			-clock_mixing no_mix 		\
			-chain_count 1


#######################################################################
	# --------------- Port Configuration ------------- #
#######################################################################
# Creation of ports that doesn't exist in netlist or rtl files
create_port -direction in Scan_Data_In
create_port -direction out Scan_Data_Out
create_port -direction in Scan_En

set_ideal_network [get_ports Scan_En]

set_case_analysis 1 [get_ports test_mode]

# Clock Signal
set_dft_signal -port [get_ports scan_clk] 	-type ScanClock 	-view existing_dft 	-timing {45 55}


# Reset signal
set_dft_signal -port [get_ports scan_reset] 	-type Reset 	-view existing_dft 	-active 1


# Test Mode signal 
set_dft_signal -port [get_ports test_mode] 	-type Constant 	-view existing_dft 	-active 1
set_dft_signal -port [get_ports test_mode] 	-type TestMode 	-view spec 	-active 1

# Scan data signals
set_dft_signal -port [get_ports Scan_Data_In] 	-type ScanDataIn 	-view spec
set_dft_signal -port [get_ports Scan_Data_Out] 	-type ScanDataOut 	-view spec

# Scan Enable
set_dft_signal -port [get_ports Scan_En] 	-type ScanEnable 	-view spec 	-active 1 	-usage scan

