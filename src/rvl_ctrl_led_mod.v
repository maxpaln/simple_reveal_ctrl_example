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
//   Name:  rvl_ctrl_led_swtich_mod.v
//
//   Description: 
//     LED Module for Reveal Controller
//
//     Provides configurable width interface for Reveal Controller LEDs. Signals
//     connected to 'dut_sigs' are available to view in Reveal Controller (via LEDs).
//
//     Parameters:
//       - LED_WIDTH         : Number of bits to monitor with Reveal Controller LEDs
//
//     Ports:
//       - rstn              : active low reset signal
//       - clk               : clock used to sync the reveal switches
//       - dut_sigs          : Signals user wants to connect to Reveal Controller LEDs
//       - reveal_ctrl_leds  : Repeat of signals that Reveal Controller LEDs will monitor.
//                             State of this output should match Reveal Controller LEDs
//
//------------------------------------------------------------------------
// Code Revision History :
//-------------------------------------------------------------------------
// Ver: | Author  | Mod. Date  | Changes Made:
// V1.0 | MH      | 09/08/21   | Initial Release
//      |         |            |
//      |         |            |
//      |         |            |
//      |         |            |
//-------------------------------------------------------------------------
module rvl_ctrl_led_mod # (
  parameter                            WIDTH           = 8
) (
  input  wire                          rstn,
  input  wire                          clk,
  input  wire [WIDTH-1:0]              dut_sigs,
  output reg  [WIDTH-1:0]              reveal_ctrl_leds
);

  // Reveal Controll LEDs should be connected to 'reveal_ctrl_leds'

  always @(posedge clk or negedge rstn)
    if (~rstn) begin
      reveal_ctrl_leds                  <= 0;
    end else begin
      reveal_ctrl_leds                  <= dut_sigs;
    end

endmodule
