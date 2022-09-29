onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB /tb_simple_rvl_ex/rstn
add wave -noupdate -expand -group TB /tb_simple_rvl_ex/clk_jtag
add wave -noupdate -expand -group TB /tb_simple_rvl_ex/clk_jtag_en
add wave -noupdate -expand -group TB /tb_simple_rvl_ex/rvl_leds
add wave -noupdate -expand -group TB /tb_simple_rvl_ex/rvl_switches
add wave -noupdate -expand -group TB -radix unsigned /tb_simple_rvl_ex/tb_reg_state
add wave -noupdate -expand -group TB /tb_simple_rvl_ex/tb_reg_cnt
add wave -noupdate -expand -group TB /tb_simple_rvl_ex/tb_reg_wait_cnt
add wave -noupdate -expand -group TB /tb_simple_rvl_ex/rvl_reg_we
add wave -noupdate -expand -group TB -radix hexadecimal /tb_simple_rvl_ex/rvl_reg_addr
add wave -noupdate -expand -group TB -radix hexadecimal /tb_simple_rvl_ex/rvl_reg_wdata
add wave -noupdate -expand -group TB -radix hexadecimal /tb_simple_rvl_ex/rvl_reg_rdata
add wave -noupdate -expand -group TB /tb_simple_rvl_ex/stim_reg_if_done
add wave -noupdate -expand -group TB /tb_simple_rvl_ex/stim_sw_led_done
add wave -noupdate -expand -group TB /tb_simple_rvl_ex/stim_done
add wave -noupdate -expand -group DUT /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/sys_clk
add wave -noupdate -expand -group DUT -radix unsigned /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/reg_state
add wave -noupdate -expand -group DUT -radix hexadecimal /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/reg_rx_data
add wave -noupdate -expand -group DUT -radix hexadecimal /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_we
add wave -noupdate -expand -group DUT -radix hexadecimal /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_addr
add wave -noupdate -expand -group DUT -radix hexadecimal -childformat {{{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[15]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[14]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[13]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[12]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[11]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[10]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[9]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[8]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[7]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[6]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[5]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[4]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[3]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[2]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[1]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[0]} -radix hexadecimal}} -subitemconfig {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[15]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[14]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[13]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[12]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[11]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[10]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[9]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[8]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[7]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[6]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[5]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[4]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[3]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[2]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[1]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata[0]} {-height 15 -radix hexadecimal}} /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_wdata
add wave -noupdate -expand -group DUT -radix hexadecimal /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/usr_rdata
add wave -noupdate -expand -group DUT -expand -group {Reveal Reg Intf} /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_clk
add wave -noupdate -expand -group DUT -expand -group {Reveal Reg Intf} /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_ce
add wave -noupdate -expand -group DUT -expand -group {Reveal Reg Intf} /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_we
add wave -noupdate -expand -group DUT -expand -group {Reveal Reg Intf} -radix hexadecimal /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_addr
add wave -noupdate -expand -group DUT -expand -group {Reveal Reg Intf} -radix hexadecimal -childformat {{{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[15]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[14]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[13]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[12]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[11]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[10]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[9]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[8]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[7]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[6]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[5]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[4]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[3]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[2]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[1]} -radix hexadecimal} {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[0]} -radix hexadecimal}} -subitemconfig {{/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[15]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[14]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[13]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[12]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[11]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[10]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[9]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[8]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[7]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[6]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[5]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[4]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[3]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[2]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[1]} {-height 15 -radix hexadecimal} {/tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata[0]} {-height 15 -radix hexadecimal}} /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_rdata
add wave -noupdate -expand -group DUT -expand -group {Reveal Reg Intf} -radix hexadecimal /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/rvl_wdata
add wave -noupdate -expand -group DUT /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/seven_seg_update
add wave -noupdate -expand -group DUT /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/seven_seg_int
add wave -noupdate -expand -group DUT /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/seven_seg
add wave -noupdate -expand -group DUT /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/virtual_sw
add wave -noupdate -expand -group DUT /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/virtual_leds
add wave -noupdate /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/ResetA
add wave -noupdate /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/ClockA
add wave -noupdate /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/ClockEnA
add wave -noupdate /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/WrA
add wave -noupdate -radix hexadecimal /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/AddressA
add wave -noupdate -radix hexadecimal /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/DataInA
add wave -noupdate -radix hexadecimal /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/QA
add wave -noupdate /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/ResetB
add wave -noupdate /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/ClockB
add wave -noupdate /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/ClockEnB
add wave -noupdate /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/WrB
add wave -noupdate -radix hexadecimal /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/AddressB
add wave -noupdate -radix hexadecimal /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/DataInB
add wave -noupdate -radix hexadecimal /tb_simple_rvl_ex/i_top_rvl_ctrl_ex/i_rvl_ctrl_reg_intf_mod/pmi_mem_inst/QB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10300000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 704
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {9623725 ps} {11499830 ps}
