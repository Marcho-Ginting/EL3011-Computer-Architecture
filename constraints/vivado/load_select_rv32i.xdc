create_clock -name vclk -period 10.000

set_input_delay  -clock vclk -max 0.000 [get_ports {cu_loadtype[*] dmem_out[*]}]
set_input_delay  -clock vclk -min 0.000 [get_ports {cu_loadtype[*] dmem_out[*]}]

set_output_delay -clock vclk -max 0.000 [get_ports {load_out[*]}]
set_output_delay -clock vclk -min 0.000 [get_ports {load_out[*]}]
