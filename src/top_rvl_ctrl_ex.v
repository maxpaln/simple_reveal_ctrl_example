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
  parameter                            COUNT_SIZE          = 28,
  parameter                            PULSE_EXT_CNT       = 1000,
  parameter                            DIP_SW_WIDTH        = 4,
  parameter                            PB_SW_WIDTH         = 3,
  parameter                            LED_OUT_WIDTH       = 8,
  parameter                            RVL_REG_ADDR_WIDTH  = 8,
  parameter                            RVL_REG_DATA_WIDTH  = 16,
  parameter                            RVL_LED_WIDTH       = 4,
  parameter                            RVL_SWITCH_WIDTH    = 4
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

  localparam                           REG_IDLE            = 'd0,
                                       REG_DET_CLR         = 'd1,
                                       REG_EXEC            = 'd2, 
                                       REG_DONE            = 'd3;

  // Signals
  wire                                 sys_clk;
  reg  [COUNT_SIZE-1:0]                counter;
  reg  [7:0]                           seven_seg_int;

  // User Register Interface Signals
  reg                                  usr_we;
  reg  [RVL_REG_ADDR_WIDTH-1:0]        usr_addr;
  reg  [RVL_REG_DATA_WIDTH-1:0]        usr_wdata;
  wire [RVL_REG_DATA_WIDTH-1:0]        usr_rdata;
  reg  [3:0]                           reg_state;
  reg  [RVL_REG_DATA_WIDTH-1:0]        reg_rx_data;

  // Reveal Switch and LED Signals
  wire [RVL_LED_WIDTH-1:0]             virtual_leds_signals;
  wire [RVL_LED_WIDTH-1:0]             virtual_leds;
  wire [RVL_SWITCH_WIDTH-1:0]          virtual_sw;

  // Assign active clock signal
  assign sys_clk                       = clk_customer1;

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

  // Select Signals to connect to Virtual LEDs:
  //   - Virtual Switch and a Push Button
  assign virtual_leds_signals          = {pb_sw[1],virtual_sw[3:0]};

  ////////////////////////////////////////////////////////
  //
  // Reg Interface Reference Design Logic
  //
  ////////////////////////////////////////////////////////

  // Simple Logic to write to Register Interface from user port
  always @(posedge sys_clk or negedge rstn)
    if (~rstn) begin
      usr_we                           <= 1'b0;
      usr_addr                         <= {RVL_REG_ADDR_WIDTH{1'b0}};
      usr_wdata                        <= {RVL_REG_DATA_WIDTH{1'b0}};
      reg_rx_data                      <= {RVL_REG_DATA_WIDTH{1'b0}};
      reg_state                        <= REG_IDLE;
    end else begin
      case (reg_state)
        REG_IDLE : begin
          usr_we                       <= 1'b0;
          usr_addr                     <= {RVL_REG_ADDR_WIDTH{1'b0}};

          if (usr_rdata[0]) begin
            // Store RAM Read Data when bit [0] is detected as 1'b1 (from JTAG Side by host machine)
            reg_rx_data                <= usr_rdata;
            reg_state                  <= REG_DET_CLR;
          end else begin
            reg_state                  <= REG_IDLE;
          end
        end
        REG_DET_CLR : begin
          // Wait for bit [0] to be cleared (from JTAG Side by host machine) before continuing
          if (~usr_rdata[0]) begin
            reg_state                  <= REG_EXEC;
          end else begin
            reg_state                  <= REG_DET_CLR;
          end
        end
        REG_EXEC : begin
          // Insert User Actions here:
          // - Example writes upper 4 bits of read data back to to highest address in register interface 
          usr_we                       <= 1'b1;
          usr_addr                     <= {RVL_REG_ADDR_WIDTH{1'b1}};
          usr_wdata                    <= {reg_rx_data[RVL_REG_DATA_WIDTH-1:RVL_REG_DATA_WIDTH-4],{(RVL_REG_DATA_WIDTH-5){1'b0}},1'b1};
          reg_state                    <= REG_DONE;
        end
        REG_DONE : begin
          // Return User side Register Interface signals to read from address 0x0
          usr_we                       <= 1'b0;
          usr_addr                     <= {RVL_REG_ADDR_WIDTH{1'b0}};
          reg_state                    <= REG_IDLE;
        end
      endcase
    end

  // ///////////////////////////////////////////////////////
  //
  // Simple Logic to Do something interesting on the board
  //
  // ///////////////////////////////////////////////////////

  // Counter Logic Pseudo Code
  // if (Virtual Switch Bit 0 is set)
  //   The counter is running (Virtual Switch Bit 1 defines the direction)
  // else
  //   if (Virtual Switch Bit 2 is set)
  //     Clear the counter (set to all 0s)
  //   else if (Virtual Switch Bit 3 is set)
  //     Set the counter to all 1s
  always @(posedge sys_clk or negedge rstn)
    if (~rstn) begin
      counter                          <= 0;
    end else begin
      if (virtual_sw[0]) begin
        if (virtual_sw[1]) begin
          counter                      <= counter - 1'b1;
        end else begin
          counter                      <= counter + 1'b1;
        end
      end else begin
        if (virtual_sw[2]) begin
          counter                      <= 'b0;
        end else if (virtual_sw[3]) begin
          counter                      <= {COUNT_SIZE{1'b1}};
        end
      end
    end


  // 7 Segment Driver from Reg Interface
  //
  //       A
  //     ____
  //    |    |
  //  F | G  | B
  //     ____
  //    |    |
  //  E |    | C
  //     ____    . DP
  //
  //      D
  //      ABCDEFG
  // 0 == 1000000
  // 1 == 1111001
  // 2 == 0100100
  // 3 == 0110000
  // 4 == 0011001
  // 5 == 0010010
  // 6 == 0000010
  // 7 == 1111000
  // 8 == 0000000
  // 9 == 0011000
  // A == 0001000
  // B == 0000011
  // C == 1000110
  // D == 0100001
  // E == 0000110
  // F == 0001110
  //
  // TODO - Map data values to correct 7-seg output
  always @(posedge sys_clk or negedge rstn)
    if (~rstn) begin
      seven_seg_int                    <= {1'b1,7'b1000000};
    end else begin
      if (reg_state == REG_DET_CLR) begin
        // Set DP once Data latched
        seven_seg_int                 <= {1'b0,seven_seg_int[6:0]};
      end else if (reg_state == REG_EXEC) begin
        case (reg_rx_data[RVL_REG_DATA_WIDTH-1:RVL_REG_DATA_WIDTH-4])
          'h0 : seven_seg_int          <= {1'b1,7'b1000000};
          'h1 : seven_seg_int          <= {1'b1,7'b1111001};
          'h2 : seven_seg_int          <= {1'b1,7'b0100100};
          'h3 : seven_seg_int          <= {1'b1,7'b0110000};
          'h4 : seven_seg_int          <= {1'b1,7'b0011001};
          'h5 : seven_seg_int          <= {1'b1,7'b0010010};
          'h6 : seven_seg_int          <= {1'b1,7'b0000010};
          'h7 : seven_seg_int          <= {1'b1,7'b1111000};
          'h8 : seven_seg_int          <= {1'b1,7'b0000000};
          'h9 : seven_seg_int          <= {1'b1,7'b0011000};
          'hA : seven_seg_int          <= {1'b1,7'b0001000};
          'hB : seven_seg_int          <= {1'b1,7'b0000011};
          'hC : seven_seg_int          <= {1'b1,7'b1000110};
          'hD : seven_seg_int          <= {1'b1,7'b0100001};
          'hE : seven_seg_int          <= {1'b1,7'b0000110};
          'hF : seven_seg_int          <= {1'b1,7'b0001110};
        endcase
      end
    end

  assign seven_seg                     = seven_seg_int;
  assign leds                          = {counter[COUNT_SIZE-1:COUNT_SIZE-4],~virtual_leds[3:0]};

endmodule
