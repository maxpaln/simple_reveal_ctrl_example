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
  localparam                           RVL_REG_DATA_WIDTH  = 16;
  localparam                           RVL_LED_WIDTH       = 4;
  localparam                           RVL_SWITCH_WIDTH    = 4;
  localparam                           DIP_SW_WIDTH        = 4;
  localparam                           PB_SW_WIDTH         = 3;
  localparam                           LED_OUT_WIDTH       = 8;
  localparam                           COUNT_SIZE          = 10;
  localparam                           PULSE_EXT_CNT       = 5;
  localparam                           REG_TXRX_CNT        = 30;
  localparam                           REG_WR_CYCLES       = 5;

  // Clock Freq (in Hz)
  localparam                           CLK_FREQ1           = 25000000;
  localparam                           CLK_FREQ2           = 100000000;
  localparam                           CLK_FREQ3           = 125000000;
  localparam                           CLK_FREQ_JTAG       = 5000000;

  // Period (in seconds) given by: 1/Freq
  // Period (in ns)      given by: (1/Freq)/10^-9 == 10^9 / Freq
  localparam                           CLK_PERIOD1         = 1000000000/CLK_FREQ1;
  localparam                           CLK_PERIOD2         = 1000000000/CLK_FREQ2;
  localparam                           CLK_PERIOD3         = 1000000000/CLK_FREQ3;
  localparam                           CLK_PERIOD_JTAG     = 1000000000/CLK_FREQ_JTAG;

  // DUT Signals
  wire [DIP_SW_WIDTH-1:0]              dut_dip_sw;
  wire [PB_SW_WIDTH-1:0]               dut_pb_sw;
  reg                                  clk1 = 0;           // 25 MHz (Appears non-functional on Certus-NX Versa Board)
  reg                                  clk2 = 0;           // 100 MHz
  reg                                  clk3 = 0;           // 125 MHz
  reg                                  clk_jtag = 0;       // 5 MHz
  reg  [7:0]                           dut_seven_seg;
  wire [LED_OUT_WIDTH-1:0]             dut_leds;

  // Testbench Signals
  reg                                  rstn;
  reg                                  clk1_en;
  reg                                  clk2_en;
  reg                                  clk3_en;
  reg                                  clk_jtag_en;
  reg                                  stim_sw_led_done;
  reg                                  stim_reg_if_done;
  wire                                 stim_done;

  // Reveal LEDs and Switches
  wire [RVL_LED_WIDTH-1:0]             rvl_leds;
  reg  [RVL_SWITCH_WIDTH-1:0]          rvl_switches;

  // Reveal Register Interface
  reg                                  rvl_reg_we;
  reg  [RVL_REG_ADDR_WIDTH-1:0]        rvl_reg_addr;
  reg  [RVL_REG_DATA_WIDTH-1:0]        rvl_reg_wdata;
  wire [RVL_REG_DATA_WIDTH-1:0]        rvl_reg_rdata;

  // Clock Generatation
  always clk1                          = #(CLK_PERIOD1/2) (~clk1 & clk1_en);
  always clk2                          = #(CLK_PERIOD2/2) (~clk2 & clk2_en);
  always clk3                          = #(CLK_PERIOD3/2) (~clk3 & clk3_en);
  always clk_jtag                      = #(CLK_PERIOD_JTAG/2) (~clk_jtag & clk_jtag_en);

  // Clock Enables and Resets
  initial
  begin
    $timeformat(-9, 2, " ns", 12);    
    #100;
    clk1_en                            <= 1'b0;
    clk2_en                            <= 1'b0;
    clk3_en                            <= 1'b0;
    clk_jtag_en                        <= 1'b0;
    rstn                               <= 1'b1;
    #1000;
    clk1_en                            <= 1'b1;
    clk2_en                            <= 1'b1;
    clk3_en                            <= 1'b1;
    clk_jtag_en                        <= 1'b1;
    #1000;
    rstn                               <= 1'b0;
    #5000;
    rstn                               <= 1'b1;
    @(posedge stim_done)
    clk1_en                            <= 1'b0;
    clk2_en                            <= 1'b0;
    clk3_en                            <= 1'b0;
    clk_jtag_en                        <= 1'b0;
    $display("%T: TB:        DONE - All tests complete!", $time);
    $stop;
  end

  // Assign Reset signal to Push Button
  assign dut_pb_sw                     = {rstn,2'b00};
  assign dut_dip_sw                    = {4'h0};

  // Assign Reveal Signals to DUT signals
  assign rvl_leds                      = i_top_rvl_ctrl_ex.i_rvl_ctrl_led_mod.reveal_ctrl_leds;
  assign i_top_rvl_ctrl_ex.i_rvl_ctrl_switch_mod.reveal_ctrl_sw = rvl_switches;

  // Assign Reveal Reg Interface Signals
  assign i_top_rvl_ctrl_ex.i_rvl_ctrl_reg_intf_mod.rvl_clk   = clk_jtag;
  assign i_top_rvl_ctrl_ex.i_rvl_ctrl_reg_intf_mod.rvl_ce    = 1'b1;
  assign i_top_rvl_ctrl_ex.i_rvl_ctrl_reg_intf_mod.rvl_we    = rvl_reg_we;
  assign i_top_rvl_ctrl_ex.i_rvl_ctrl_reg_intf_mod.rvl_addr  = rvl_reg_addr;
  assign i_top_rvl_ctrl_ex.i_rvl_ctrl_reg_intf_mod.rvl_wdata = rvl_reg_wdata;
  assign rvl_reg_rdata = i_top_rvl_ctrl_ex.i_rvl_ctrl_reg_intf_mod.rvl_rdata;

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

  //FOLD_START_STIM_VIRTUAL_SWTICHES
  initial
  begin
    rvl_switches                       <= 0;
    stim_sw_led_done                   <= 0;
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
    stim_sw_led_done                   <= 1'b1;
  end
  //FOLD_END_STIM_VIRTUAL_SWTICHES

  reg  [2:0]                           tb_reg_state;
  integer                              tb_reg_cnt;
  integer                              tb_reg_wait_cnt;

  localparam                           TB_REG_IDLE         = 'd0,
                                       TB_REG_WR_DATA      = 'd1,
                                       TB_REG_WR_WAIT      = 'd2,
                                       TB_REG_CLR_DATA     = 'd3,
                                       TB_REG_CLR_WAIT     = 'd4,
                                       TB_REG_CHK_RES      = 'd5,
                                       TB_REG_DONE         = 'd6;
  //FOLD_START_STIM_REG_INTF
  always@ (posedge clk_jtag or negedge rstn)
    if (~rstn) begin
      rvl_reg_we                       <= 1'b0;
      rvl_reg_addr                     <= {RVL_REG_ADDR_WIDTH{1'b0}};
      rvl_reg_wdata                    <= {RVL_REG_DATA_WIDTH{1'b0}};
      tb_reg_wait_cnt                  <= 0;
      tb_reg_cnt                       <= 0;
      stim_reg_if_done                 <= 1'b0;
      tb_reg_state                     <= TB_REG_IDLE;
    end else begin
      case (tb_reg_state)
        TB_REG_IDLE : begin
          tb_reg_wait_cnt              <= 0;
          rvl_reg_we                   <= 1'b0;
          rvl_reg_addr                 <= {RVL_REG_ADDR_WIDTH{1'b0}};
          rvl_reg_wdata                <= {RVL_REG_DATA_WIDTH{1'b0}};
          tb_reg_state                 <= TB_REG_WR_DATA;
          $display("%t: TB:        Starting Register Interface Transaction %0d.",$time, tb_reg_cnt);
        end
        TB_REG_WR_DATA : begin
          // Assert Write Enable, Set bit 0 and load upper bits of Write Data
          // with new value
          rvl_reg_we                   <= 1'b1;
          rvl_reg_addr                 <= {RVL_REG_ADDR_WIDTH{1'b0}};
          rvl_reg_wdata[0]             <= 1'b1;
          rvl_reg_wdata[RVL_REG_DATA_WIDTH-1:RVL_REG_DATA_WIDTH-4] <= tb_reg_cnt[3:0];
          tb_reg_state                 <= TB_REG_WR_WAIT;
        end
        TB_REG_WR_WAIT : begin
          tb_reg_wait_cnt              <= tb_reg_wait_cnt + 1;
          if (tb_reg_wait_cnt == REG_WR_CYCLES) begin
            tb_reg_state               <= TB_REG_CLR_DATA;
          end else begin
            tb_reg_state               <= TB_REG_WR_WAIT;
          end
        end
        TB_REG_CLR_DATA : begin
          tb_reg_wait_cnt              <= 0;
          rvl_reg_wdata                <= {RVL_REG_DATA_WIDTH{1'b0}};
          tb_reg_state                 <= TB_REG_CLR_WAIT;
        end
        TB_REG_CLR_WAIT : begin
          tb_reg_wait_cnt              <= tb_reg_wait_cnt + 1;
          if (tb_reg_wait_cnt == REG_WR_CYCLES) begin
            // Read from Upper Address
            rvl_reg_we                 <= 1'b0;
            rvl_reg_addr               <= {RVL_REG_ADDR_WIDTH{1'b1}};
            tb_reg_state               <= TB_REG_CHK_RES;
          end else begin
            tb_reg_state               <= TB_REG_CLR_WAIT;
          end
        end
        TB_REG_CHK_RES : begin
          // Wait for bit 0 to be set by User Application
          if (rvl_reg_rdata[0]) begin
            // Lower Bits of Register Read Data should match Data written to reg (tb_reg_cnt[3:0])
            if (rvl_reg_rdata[RVL_REG_DATA_WIDTH-1:RVL_REG_DATA_WIDTH-4] == tb_reg_cnt[3:0]) begin
              $display("%t: TB:        SUCCESS: Register Interface Read Data (%4h) matches Write Data (%4h).",$time, rvl_reg_rdata[RVL_REG_DATA_WIDTH-1:RVL_REG_DATA_WIDTH-4], tb_reg_cnt[3:0]);
            end else begin
              $display("%t: TB:        ERROR: Register Interface Read Data (%4h) does not match Write Data (%4h).",$time, rvl_reg_rdata[3:0], tb_reg_cnt[3:0]);
              $stop;
            end
            tb_reg_state                 <= TB_REG_DONE;
          end else begin
            tb_reg_state                 <= TB_REG_CHK_RES;
          end
        end
        TB_REG_DONE : begin
          if (tb_reg_cnt == REG_TXRX_CNT) begin
            $display("%t: TB:        DONE: Successfully completed %0d Register Interface Transactions.",$time, tb_reg_cnt);
            stim_reg_if_done           <= 1'b1;
          end else begin
            stim_reg_if_done           <= 1'b0;
            tb_reg_cnt                 <= tb_reg_cnt + 1;
            tb_reg_state               <= TB_REG_IDLE;
          end
        end
      endcase
    end
  //FOLD_END_STIM_REG_INTF

  assign stim_done                     = stim_reg_if_done && stim_sw_led_done;

  //FOLD_START_MIS
  // Define GSR clock and set it running
  //reg                                  gsr_clk = 0;
  //always gsr_clk                       = #(20) ~gsr_clk;

  // GSR Instance for Simulation
  GSR GSR_INST (
    .CLK                               (1'b0),
    .GSR_N                             (1'b1)
  );

  // PUR
  PUR PUR_INST (
    .PUR                               (1'b1)
  );
  //FOLD_END_MISC

endmodule
