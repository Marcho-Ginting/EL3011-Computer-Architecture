# 100 MHz clock applied to the clock input
create_clock -name clock -period 10.000 [get_ports {clock}]

# Inputs are assumed valid at the active clock edge
set_input_delay -clock clock -max 0.000 [get_ports {cu_rdwrite rs1_addr rs2_addr rd_addr rd_in}]
set_input_delay -clock clock -min 0.000 [get_ports {cu_rdwrite rs1_addr rs2_addr rd_addr rd_in}]

# Output timing requirement relative to the clock
set_output_delay -clock clock -max 0.000 [get_ports {rs1 rs2}]
set_output_delay -clock clock -min 0.000 [get_ports {rs1 rs2}]
