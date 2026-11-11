create_clock -name vclk -period 10.000

set_input_delay  -clock vclk -max 0.000 [get_ports {in[*] shamt[*] shiftype[*]}]
set_input_delay  -clock vclk -min 0.000 [get_ports {in[*] shamt[*] shiftype[*]}]

set_output_delay -clock vclk -max 0.000 [get_ports {out[*]}]
set_output_delay -clock vclk -min 0.000 [get_ports {out[*]}]
