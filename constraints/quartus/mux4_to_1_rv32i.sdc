create_clock -name vclk -period 10.000

set_input_delay  -clock vclk -max 0.000 [get_ports {W[*] X[*] Y[*] Z[*] sel[*]}]
set_input_delay  -clock vclk -min 0.000 [get_ports {W[*] X[*] Y[*] Z[*] sel[*]}]

set_output_delay -clock vclk -max 0.000 [get_ports {D[*]}]
set_output_delay -clock vclk -min 0.000 [get_ports {D[*]}]
