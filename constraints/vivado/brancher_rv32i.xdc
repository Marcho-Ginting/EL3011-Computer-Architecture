create_clock -name vclk -period 10.000

set_input_delay  -clock vclk -max 0.000 [get_ports {PC_new[*] PC_branch[*] in1[*] in2[*] cu_branch cu_branchtype[*]}]
set_input_delay  -clock vclk -min 0.000 [get_ports {PC_new[*] PC_branch[*] in1[*] in2[*] cu_branch cu_branchtype[*]}]

set_output_delay -clock vclk -max 0.000 [get_ports {PC_in[*]}]
set_output_delay -clock vclk -min 0.000 [get_ports {PC_in[*]}]
