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
//   Name:  top_rvl_ctrl_ex.v
//
//   Description: 
//     Simple Reveal Controller Example
//
//     Demonstrates Reveal Controller a simple design that can be used as
//     a template for user designs.
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
module top_rvl_ctrl_ex # (
  parameter                            COUNT_SIZE          = 32,
  parameter                            PULSE_EXT_CNT       = 1000,
  parameter                            DIP_SW_WIDTH        = 4,
  parameter                            PB_SW_WIDTH         = 3,
  parameter                            LED_OUT_WIDTH       = 8,
  parameter                            RVL_REG_ADDR_WIDTH  = 16,
  parameter                            RVL_REG_DATA_WIDTH  = 16,
  parameter                            RVL_LED_WIDTH       = 4,
  parameter                            RVL_SWITCH_WIDTH    = 2
) (
  input  wire                          rstn,
  input  wire                          system_25_clk,      // 25 MHz (Appears non-functional on Certus-NX Versa Board)
  input  wire                          clk_customer1,      // 100 MHz
  input  wire                          clk_customer2,      // 125 MHz
  input  wire [DIP_SW_WIDTH-1:0]       dip_sw,
  input  wire [PB_SW_WIDTH-1:0]        pb_sw,
  output wire [7:0]                    seven_seg,
  output wire [LED_OUT_WIDTH-1:0]      leds
);

  localparam                           COUNT_WR_SIZE       = COUNT_SIZE - 6;
  localparam                           COUNT_RD_SIZE       = COUNT_SIZE - 4;

  // Signals
  wire                                 sys_clk;
  reg  [COUNT_SIZE-1:0]                counter;
  wire                                 reg_intf_write;
  wire                                 reg_intf_read;
  wire                                 reg_intf_write_ext;
  wire                                 reg_intf_read_ext;
  reg  [7:0]                           seven_seg_int;

  // User Register Interface Signals
  reg                                  usr_we;
  reg  [RVL_REG_ADDR_WIDTH-1:0]        usr_addr;
  reg  [RVL_REG_DATA_WIDTH-1:0]        usr_wdata;
  wire [RVL_REG_DATA_WIDTH-1:0]        usr_rdata;

  // Reveal Switch and LED Signals
  wire [RVL_LED_WIDTH-1:0]             virtual_leds_signals;
  wire [RVL_LED_WIDTH-1:0]             virtual_leds;
  wire [RVL_SWITCH_WIDTH-1:0]          virtual_sw;

  ////////////////////////////////////////////////////////
  //
  // Reveal Controller Instantiations
  //
  ////////////////////////////////////////////////////////

  // Reveal Controller Register Interface Module
  rvl_ctrl_reg_intf_mod # (
    .ADDR_WIDTH                        (RVL_REG_ADDR_WIDTH),
    .DATA_WIDTH                        (RVL_REG_DATA_WIDTH)
  ) i_rvl_ctrl_reg_intf_mod (
    .usr_rst                           (~rstn),
    .usr_clk                           (sys_clk),
    .usr_ce                            (1'b1),
    .usr_we                            (usr_we),
    .usr_addr                          (usr_addr),
    .usr_wdata                         (usr_wdata),
    .usr_rdata                         (usr_rdata)
  );

  // Reveal Controller Switch Module
  rvl_ctrl_switch_mod # (
    .WIDTH                             (RVL_SWITCH_WIDTH)
  ) i_rvl_ctrl_switch_mod (
    .rstn                              (rstn),
    .clk                               (sys_clk),
    .virtual_sw                        (virtual_sw)
  );

  // Reveal Controller LED Module
  rvl_ctrl_led_mod # (
    .WIDTH                             (RVL_LED_WIDTH)
  ) i_rvl_ctrl_led_mod (
    .rstn                              (rstn),
    .clk                               (sys_clk),
    .dut_sigs                          (virtual_leds_signals),
    .reveal_ctrl_leds                  (virtual_leds)
  );

  // Select Signals to connect to Virtual LEDs
  assign virtual_leds_signals          = {counter[COUNT_RD_SIZE-1],pb_sw[1],virtual_sw[1],virtual_sw[0]};

  ////////////////////////////////////////////////////////
  //
  // Sample Design Logic
  //
  ////////////////////////////////////////////////////////

  // Assignments to get the design to do something interesting...
  assign sys_clk                       = clk_customer1;
  assign leds                          = {counter[COUNT_RD_SIZE-1:COUNT_RD_SIZE-4],~virtual_leds[3:0]};
  assign reg_intf_write                = (&counter[COUNT_WR_SIZE-1:0] == 1) ? 1'b1 : 1'b0;
  assign reg_intf_read                 = (&counter[COUNT_RD_SIZE-1:0] == 1) ? 1'b1 : 1'b0;

  // Clocked Logic
  always @(posedge sys_clk or negedge rstn)
    if (~rstn) begin
      counter                          <= 0;
    end else begin
      if (virtual_sw[0]) begin
        counter                        <= counter - 1'b1;
      end else begin
        counter                        <= counter + 1'b1;
      end
    end

  // Simple Logic to write to Register Interface from user port
  always @(posedge sys_clk or negedge rstn)
    if (~rstn) begin
      usr_we                           <= 1'b0;
      usr_addr                         <= 'b0;
      usr_wdata                        <= 'b0;
    end else begin
      if (reg_intf_write) begin
        usr_we                         <= 1'b1;
        usr_wdata                      <= counter[COUNT_SIZE-1:COUNT_SIZE-RVL_REG_DATA_WIDTH];
        if (usr_addr < 'hF) begin
          usr_addr                     <= usr_addr + 1;
        end else begin
          usr_addr                     <= 0;
        end
      end else begin
        usr_we                         <= 1'b0;
        usr_wdata                      <= 'h0;
      end
    end

  // 7 Segment Driver from Reg Interface
  always @(posedge sys_clk or negedge rstn)
    if (~rstn) begin
      seven_seg_int                    <= 8'h5A;
    end else begin
      if (reg_intf_read) begin
        seven_seg_int                  <= usr_rdata[RVL_REG_DATA_WIDTH-1:RVL_REG_DATA_WIDTH-8];
      end
    end

  assign seven_seg                     = (virtual_sw[1]) ? seven_seg_int : ~seven_seg_int;

  // Instantiate Pulse Extenders

  // Reg Interface Write Strobe
  pulse_extender # (
    .PULSE_CNT                         (PULSE_EXT_CNT)
  ) i_pulse_extender_reg_w (
    .rstn                              (rstn),
    .clk                               (sys_clk),
    .pulse_in                          (reg_intf_write),
    .ext_out                           (reg_intf_write_ext)
  );

  // Reg Interface Read Strobe
  pulse_extender # (
    .PULSE_CNT                         (PULSE_EXT_CNT)
  ) i_pulse_extender_reg_r (
    .rstn                              (rstn),
    .clk                               (sys_clk),
    .pulse_in                          (reg_intf_read),
    .ext_out                           (reg_intf_read_ext)
  );
  
endmodule
