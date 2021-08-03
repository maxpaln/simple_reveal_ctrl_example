module rvl_ctrl_mod # (
  parameter                            ADDR_WIDTH          = 16,
  parameter                            DATA_WIDTH          = 32
) (
  input  wire                          usr_rst,
  input  wire                          usr_clk,
  input  wire                          usr_ce,
  input  wire                          usr_we,
  input  wire [ADDR_WIDTH-1:0]         usr_addr,
  input  wire [DATA_WIDTH-1:0]         usr_wdata,
  output wire [DATA_WIDTH-1:0]         usr_rdata
);

  wire                                 rvl_clk;
  wire                                 rvl_ce;
  wire                                 rvl_we;
  wire [ADDR_WIDTH-1:0]                rvl_addr;
  wire [DATA_WIDTH-1:0]                rvl_wdata;
  wire [DATA_WIDTH-1:0]                rvl_rdata;

  localparam                           ADDR_WIDTH_A        = ADDR_WIDTH;
  localparam                           ADDR_DEPTH_A        = 2**ADDR_WIDTH;
  localparam                           DATA_WIDTH_A        = DATA_WIDTH;
  localparam                           ADDR_DEPTH_B        = ADDR_WIDTH;
  localparam                           ADDR_WIDTH_B        = ADDR_WIDTH;
  localparam                           DATA_WIDTH_B        = DATA_WIDTH;


  pmi_ram_dp_true #(
    .pmi_addr_width_a                  (ADDR_WIDTH_A),     // integer       
    .pmi_data_width_a                  (DATA_WIDTH_A),     // integer       
    .pmi_addr_width_b                  (ADDR_WIDTH_B),     // integer       
    .pmi_data_width_b                  (DATA_WIDTH_B),     // integer       
    .pmi_addr_depth_b                  (ADDR_DEPTH_B),     // integer       
    .pmi_addr_depth_a                  (ADDR_DEPTH_A),     // integer       
    .pmi_regmode_a                     ("noreg"),          // "reg"|"noreg"     
    .pmi_regmode_b                     ("noreg"),          // "reg"|"noreg"     
    .pmi_resetmode                     ("async"),          // "async" | "sync"	
    //.pmi_init_file                     (),                 // string		
    //.pmi_init_file_format              ( ),                // "binary"|"hex"    
    .pmi_family                        ("LFD2NX")          // "LIFCL"|"LFD2NX"|"LFCPNX"|"common"
  ) pmi_mem_32_inst (          	
    .ResetA                            (usr_rst),          // I:
    .ClockA                            (rvl_clk),          // I:
    .ClockEnA                          (rvl_ce),           // I:
    .WrA                               (rvl_we),           // I:
    .AddressA                          (rvl_addr),         // I:
    .DataInA                           (rvl_wdata),        // I:
    .QA                                (rvl_rdata),        // O:
    .ResetB                            (usr_rst),          // I:
    .ClockB                            (usr_clk),          // I:
    .ClockEnB                          (usr_ce),           // I:
    .WrB                               (usr_we),           // I:
    .AddressB                          (usr_addr),         // I:
    .DataInB                           (usr_wdata),        // I:
    .QB                                (usr_rdata)         // O:
  );

endmodule
