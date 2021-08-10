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
//   Name:  rvl_ctrl_swtich_mod.v
//
//   Description: 
//     LED / Switch Module for Reveal Controller
//
//     Provides configurable width interface Reveal Switches. virtual_sw port
//     is controllable from the Reveal Controller. 
//
//     Parameters:
//       - WIDTH             : Number of bits to control with Reveal Controller Switches
//
//     Ports:
//       - rstn              : active low reset signal
//       - clk               : clock used to sync the reveal switches
//       - virtual_sw        : signal that will be controlled by Reveal Controller Switches.
//                             User design signals should be attached to this output
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
module rvl_ctrl_switch_mod # (
  parameter                            WIDTH    = 8
) (
  input  wire                          rstn,
  input  wire                          clk,
  output reg  [WIDTH-1:0]              virtual_sw
);

  // Declare switch signals:
  //   - 'reveal_ctrl_sw' should be connected to Reveal Controller Switches
  wire [WIDTH-1:0]                     reveal_ctrl_sw;
  reg  [WIDTH-1:0]                     reveal_ctrl_sw_meta;

  always @(posedge clk or negedge rstn)
    if (~rstn) begin
      reveal_ctrl_sw_meta              <= 0;
      virtual_sw                       <= 0;
    end else begin
      reveal_ctrl_sw_meta              <= reveal_ctrl_sw;
      virtual_sw                       <= reveal_ctrl_sw_meta;
    end

endmodule
