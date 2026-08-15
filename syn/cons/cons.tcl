
#######################################################################
	# --------------- Clock Definitions ------------- #
#######################################################################

set CLK_PERIOD 15.0
set CLK_UNCR [expr $CLK_PERIOD * 0.03]

create_clock -name fun_clk -period $CLK_PERIOD -waveform [list 0.0 [expr {$CLK_PERIOD / 2.0}]] [get_ports fun_clk]

set_clock_uncertainty -setup $CLK_UNCR [get_port fun_clk]
set_clock_uncertainty -hold $CLK_UNCR [get_port fun_clk]

set_input_delay -clock fun_clk -max [expr $CLK_PERIOD * 0.1] [remove_from_collection [all_inputs] [get_ports fun_clk]]
set_input_delay -clock fun_clk -min [expr $CLK_PERIOD * 0.1] [remove_from_collection [all_inputs] [get_ports fun_clk]]

set_output_delay -clock fun_clk -max [expr $CLK_PERIOD * 0.1] [all_outputs]
set_output_delay -clock fun_clk -min [expr $CLK_PERIOD * 0.1] [all_outputs]

# Prevent the tool from inserting beffuers through clock network
set_ideal_network [get_clocks fun_clk]
set_ideal_network [get_port fun_reset]


#######################################################################
	# --------------- Optimization ------------- #
#######################################################################

# set_max_area 0.0

current_design mips_16


# both values are determined from .lib file so that it's an intermediate value to force the tool to do optimization and minimize the propagation delay
set_max_transition 0.5 [current_design]
set_max_capacitance 50 [current_design]

# enhance in fanout
set_max_fanout 5 [current_design]

#######################################################################
	# --------------- Interface ------------- #
#######################################################################

set_driving_cell  -lib_cell IBUFFX2_HVT -pin ZN [remove_from_collection [all_inputs] [get_ports fun_clk]]

set_load 5 [all_outputs]

#####################################################################
	# --------------- Don't use ------------- #
#######################################################################
set_dont_use [get_lib_cells */*AND3*]

