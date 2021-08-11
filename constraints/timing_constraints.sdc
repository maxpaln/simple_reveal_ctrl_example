#create_clock -name {sys_clk} -period 40 [get_ports system_25_clk]
create_clock -name {sys_clk} -period 10 [get_ports clk_customer1]
#create_clock -name {sys_clk} -period 8 [get_ports clk_customer2]
