create_clock -name vclk -period 10.000

set_input_delay  -clock vclk -max 0.000 [get_ports {trimmed_instr[*] cu_immtype[*]}]
set_input_delay  -clock vclk -min 0.000 [get_ports {trimmed_instr[*] cu_immtype[*]}]

set_output_delay -clock vclk -max 0.000 [get_ports {imm[*]}]
set_output_delay -clock vclk -min 0.000 [get_ports {imm[*]}]
