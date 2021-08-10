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
//   Name:  pulse_extender.v
//
//   Description: 
//     Extends short pulses to a configurable fixed length. Allows short
//     duration signals to be viewed on LEDs or in Reveal Controller.
//     
//     NOTE: 
//
//     Parameters:
//       - POL               : "POS" = detect active high pulse, "NEG" = detect active low pulse
//       - PULSE_CNT         : ext_out will assert for PULSE_CNT 'clk' clock cycles
//
//     Ports:
//       - rstn              : Active Low reset input
//       - clk               : Clock input for pulse_in. pulse_in should be clocked by
//                             the signal attached to 'clk'
//       - pulse_in          : Signal to extend.
//       - ext_out           : Extended duration copy of pulse_in
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
module pulse_extender # (
  parameter                            POL             = "POS",
  parameter                            PULSE_CNT       = 100
) (
  input  wire                          rstn,
  input  wire                          clk,
  input  wire                          pulse_in,
  output reg                           ext_out
);

  integer                              counter;

  always@(posedge clk or negedge rstn)
    if (~rstn) begin
      ext_out                          <= 0;
      counter                          <= 0;
    end else begin
      if (((POL == "POS") && pulse_in) || ((POL == "NEG") && ~pulse_in)) begin
        // Assertion detected
        ext_out                        <= 1'b1;
        counter                        <= PULSE_CNT;
      end else begin
        // Input not asserted
        if (counter == 0) begin
          // Counter has expired - return signals to zero
          ext_out                      <= 1'b0;
        end else begin
          // Keep output asserted until counter expires
          counter                     <= counter - 1'b1;
          ext_out                     <= 1'b1;
        end
      end
    end

endmodule

