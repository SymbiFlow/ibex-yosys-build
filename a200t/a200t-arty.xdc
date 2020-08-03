## Clock signal
set_property IOSTANDARD LVCMOS33 [get_ports IO_CLK]

## LEDs
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]

## Reset signal
set_property IOSTANDARD LVCMOS33 [get_ports IO_RST_N]
