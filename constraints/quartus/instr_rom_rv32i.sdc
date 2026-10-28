# Virtual reference clock: 100 MHz
create_clock -name virtual_clk -period 10.000

# Inputs arrive at the reference clock edge
set_input_delay -clock virtual_clk -max 0.000 [all_inputs]
set_input_delay -clock virtual_clk -min 0.000 [all_inputs]

# Outputs have no external delay budget
set_output_delay -clock virtual_clk -max 0.000 [all_outputs]
set_output_delay -clock virtual_clk -min 0.000 [all_outputs]
