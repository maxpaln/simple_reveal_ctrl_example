//   ==================================================================
//   >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
//   ------------------------------------------------------------------
//   Copyright (c) 2018 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED 
//   ------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement. 
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
//   --------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02 
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
//   --------------------------------------------------------------------
//
//   Name:  tb_simple_rvl_ex.v
//
//   Description: 
//     Simple Testbench for Simple Reveal Controller Example
//
//     Testbench confirms basic functionality and mimics some of the behaviour of
//     the Reveal Controller
//
//-------------------------------------------------------------------------
// Code Revision History :
//-------------------------------------------------------------------------
// Ver: | Author  | Mod. Date  | Changes Made:
// V1.0 | MH      | 09/08/21   | Initial Release
//      |         |            |
//      |         |            |
//      |         |            |
//      |         |            |
//-------------------------------------------------------------------------
`timescale 1ns / 10ps

module tb_simple_rvl_ex (
);

  localparam                           RVL_REG_ADDR_WIDTH  = 8;
  localparam                           RVL_REG_DATA_WIDTH  = 8;
  localparam                           RVL_LED_WIDTH       = 4;
  localparam                           RVL_SWITCH_WIDTH    = 4;
  localparam                           DIP_SW_WIDTH        = 4;
  localparam                           PB_SW_WIDTH         = 3;
  localparam                           LED_OUT_WIDTH       = 8;
  localparam                           COUNT_SIZE          = 10;
  localparam                           PULSE_EXT_CNT       = 5;

  // Clock Freq (in Hz)
  localparam                           CLK_FREQ1           = 25000000;
  localparam                           CLK_FREQ2           = 100000000;
  localparam                           CLK_FREQ3           = 125000000;

  // Period (in seconds) given by: 1/Freq
  // Period (in ns)      given by: (1/Freq)/10^-9 == 10^9 / Freq
  localparam                           CLK_PERIOD1         = 1000000000/CLK_FREQ1;
  localparam                           CLK_PERIOD2         = 1000000000/CLK_FREQ2;
  localparam                           CLK_PERIOD3         = 1000000000/CLK_FREQ3;

  // DUT Signals
  wire [DIP_SW_WIDTH-1:0]              dut_dip_sw;
  wire [PB_SW_WIDTH-1:0]               dut_pb_sw;
  reg                                  clk1 = 0;           // 25 MHz (Appears non-functional on Certus-NX Versa Board)
  reg                                  clk2 = 0;           // 100 MHz
  reg                                  clk3 = 0;           // 125 MHz
  reg  [7:0]                           dut_seven_seg;
  wire [LED_OUT_WIDTH-1:0]             dut_leds;

  // Testbench Signals
  reg                                  rstn;
  reg                                  clk1_en;
  reg                                  clk2_en;
  reg                                  clk3_en;
  reg                                  stim_done;

  // Reveal LEDs and Switches
  wire [RVL_LED_WIDTH-1:0]             rvl_leds;
  reg  [RVL_SWITCH_WIDTH-1:0]          rvl_switches;

  // Clock Generatation
  always clk1                          = #(CLK_PERIOD1/2) (~clk1 & clk1_en);
  always clk2                          = #(CLK_PERIOD2/2) (~clk2 & clk2_en);
  always clk3                          = #(CLK_PERIOD3/2) (~clk3 & clk3_en);

  // Clock Enables and Resets
  initial
  begin
    $timeformat(-9, 2, " ns", 12);    
    #100;
    clk1_en                            <= 1'b0;
    clk2_en                            <= 1'b0;
    clk3_en                            <= 1'b0;
    rstn                               <= 1'b1;
    #1000;
    clk1_en                            <= 1'b1;
    clk2_en                            <= 1'b1;
    clk3_en                            <= 1'b1;
    #1000;
    rstn                               <= 1'b0;
    #5000;
    rstn                               <= 1'b1;
    @(posedge stim_done)
    clk1_en                            <= 1'b0;
    clk2_en                            <= 1'b0;
    clk3_en                            <= 1'b0;
    $display("%T: TB:        DONE - All tests complete!", $time);
    $stop;
  end

  // Assign Reset signal to Push Button
  assign dut_pb_sw                     = {rstn,2'b00};
  assign dut_dip_sw                    = {4'h0};

  // Assign Reveal Signals to DUT signals
  assign rvl_leds                      = i_top_rvl_ctrl_ex.i_rvl_ctrl_led_mod.reveal_ctrl_leds;
  assign i_top_rvl_ctrl_ex.i_rvl_ctrl_switch_mod.reveal_ctrl_sw = rvl_switches;

  // Instantiate DUT
  top_rvl_ctrl_ex # (
    .COUNT_SIZE                        (COUNT_SIZE),
    .PULSE_EXT_CNT                     (PULSE_EXT_CNT),
    .RVL_LED_WIDTH                     (RVL_LED_WIDTH),
    .RVL_SWITCH_WIDTH                  (RVL_SWITCH_WIDTH),
    .RVL_REG_ADDR_WIDTH                (RVL_REG_ADDR_WIDTH),
    .RVL_REG_DATA_WIDTH                (RVL_REG_DATA_WIDTH),
    .DIP_SW_WIDTH                      (DIP_SW_WIDTH),
    .PB_SW_WIDTH                       (PB_SW_WIDTH),
    .LED_OUT_WIDTH                     (LED_OUT_WIDTH)
  ) i_top_rvl_ctrl_ex (
    .rstn                              (rstn),
    .system_25_clk                     (clk1),
    .clk_customer1                     (clk2),
    .clk_customer2                     (clk3),
    .dip_sw                            (dut_dip_sw),
    .pb_sw                             (dut_pb_sw),
    .seven_seg                         (dut_seven_seg),
    .leds                              (dut_leds)
  );

  //FOLD_START_STIM
  initial
  begin
    rvl_switches                       <= 0;
    stim_done                          <= 0;
    #20000;
    rvl_switches[0]                    <= 1'b1; 
    $display("%t: TB:        Asserting bit 0 of Reveal Switches. Current Value: 0x%h",$time, rvl_switches);
    #25000;
    rvl_switches[1]                    <= 1'b1; 
    $display("%t: TB:        Asserting bit 1 of Reveal Switches. Current Value: 0x%h",$time, rvl_switches);
    #20000;
    rvl_switches[0]                    <= 1'b0; 
    $display("%t: TB:        Deasserting bit 0 of Reveal Switches. Current Value: 0x%h",$time, rvl_switches);
    #20000;
    rvl_switches[1]                    <= 1'b0; 
    $display("%t: TB:        Deasserting bit 0 of Reveal Switches. Current Value: 0x%h",$time, rvl_switches);
    #20000;
    stim_done                          <= 1'b1;
  end
  //FOLD_END_STIM

  //FOLD_START_MISC
  // Define GSR clock and set it running
  reg                                  gsr_clk = 0;
  always gsr_clk                       = #(20) ~gsr_clk;

  // GSR - CLK can be static (Async) or active (Sync)
  GSR GSR_INST (
    .CLK                               (gsr_clk),
    .GSR_N                             (1'b1)
  );

  // PUR
  PUR PUR_INST (
    .PUR                               (1'b1)
  );
  //FOLD_END_MISC

endmodule
