create_clock -name clock -period 10.000 [get_ports {clock}]

# ADDR is a 32-bit bus: constrain every bit.
set_input_delay -clock clock -max 0.000 [get_ports {ADDR[*]}]
set_input_delay -clock clock -min 0.000 [get_ports {ADDR[*]}]

# INSTR is a 32-bit bus: constrain every bit.
set_output_delay -clock clock -max 0.000 [get_ports {INSTR[*]}]
set_output_delay -clock clock -min 0.000 [get_ports {INSTR[*]}]

# Let TimeQuest derive clock uncertainty for this clock.
derive_clock_uncertainty
