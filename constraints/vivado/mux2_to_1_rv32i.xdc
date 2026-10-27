# Virtual reference clock: 100 MHz
create_clock -name virtual_clk -period 10.000

# Input timing constraints
set_input_delay -clock virtual_clk -max 0.000 [all_inputs]
set_input_delay -clock virtual_clk -min 0.000 [all_inputs]

# Output timing constraints
set_output_delay -clock virtual_clk -max 0.000 [all_outputs]
set_output_delay -clock virtual_clk -min 0.000 [all_outputs]