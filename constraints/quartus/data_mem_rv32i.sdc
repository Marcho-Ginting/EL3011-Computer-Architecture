# 100 MHz clock applied to the clock input
create_clock -name clock -period 10.000 [get_ports {clock}]

# Inputs are assumed valid at the active clock edge
set_input_delay -clock clock -max 0.000 [get_ports {cu_store cu_storetype dmem_addr rs2}]
set_input_delay -clock clock -min 0.000 [get_ports {cu_store cu_storetype dmem_addr rs2}]

# Output timing requirement relative to the clock
set_output_delay -clock clock -max 0.000 [get_ports {dmem_out}]
set_output_delay -clock clock -min 0.000 [get_ports {dmem_out}]
