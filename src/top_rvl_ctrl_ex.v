module top_rvl_ctrl_ex # (
  RVL_REG_ADDR_WIDTH                   = 16,
  RVL_REG_DATA_WIDTH                   = 16 
) (
  input  wire [3:0]                    dip_sw,
  input  wire [2:0]                    pb,
  input  wire                          system_25_clk,      // 25 MHz (Appears non-functional on Certus-NX Versa Board)
  input  wire                          clk_customer1,      // 100 MHz
  input  wire                          clk_customer2,      // 125 MHz
  output reg  [7:0]                    seven_seg,
  output wire [7:0]                    leds
);

  localparam                           COUNT_SIZE          = 32;
  localparam                           COUNT_WR_SIZE       = 26;
  localparam                           COUNT_RD_SIZE       = 28;
  //localparam                           COUNTER_MAX         = 'h8000000;
  // Signals
  wire                                 sys_clk;
  wire                                 rstn;
  reg  [COUNT_SIZE-1:0]                counter;
  wire                                 reg_intf_write;
  wire                                 reg_intf_read;

  // User Register Interface Signals
  //reg                                  usr_ce;
  reg                                  usr_we;
  reg  [RVL_REG_ADDR_WIDTH-1:0]        usr_addr;
  reg  [RVL_REG_DATA_WIDTH-1:0]        usr_wdata;
  wire [RVL_REG_DATA_WIDTH-1:0]        usr_rdata;

  // Assignments
  assign sys_clk                       = clk_customer1;
  assign rstn                          = pb[2];
  assign leds                          = {reg_intf_read,reg_intf_write,counter[26:21]};
  assign reg_intf_write                = (&counter[COUNT_WR_SIZE-1:0] == 1) ? 1'b1 : 1'b0;
  assign reg_intf_read                 = (&counter[COUNT_RD_SIZE-1:0] == 1) ? 1'b1 : 1'b0;

  // Clocked Logic
  always @(posedge sys_clk or negedge rstn)
    if (~rstn) begin
      counter                          <= 'hA5A5A;
    end else begin
      counter                          <= counter + 1'b1;
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
        usr_wdata                      <= counter[COUNT_SIZE-1:COUNT_SIZE-RVL_REG_DATA_WIDTH-1];
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
      seven_seg                        <= 8'h5A;
    end else begin
      if (reg_intf_read) begin
        seven_seg                      <= usr_rdata[RVL_REG_DATA_WIDTH-1:RVL_REG_DATA_WIDTH-8-1];
      end
    end

  // Reveal Controller Module
  rvl_ctrl_mod # (
    .ADDR_WIDTH                        (RVL_REG_ADDR_WIDTH),
    .DATA_WIDTH                        (RVL_REG_DATA_WIDTH)
  ) i_rvl_ctrl_mod (
    .usr_rst                           (~rstn),
    .usr_clk                           (sys_clk),
    .usr_ce                            (1'b1),
    .usr_we                            (usr_we),
    .usr_addr                          (usr_addr),
    .usr_wdata                         (usr_wdata),
    .usr_rdata                         (usr_rdata)
  );

endmodule
