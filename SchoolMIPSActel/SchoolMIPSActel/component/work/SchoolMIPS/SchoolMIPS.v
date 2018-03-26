//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Sat Mar 24 23:28:15 2018
// Version: v11.8 SP2 11.8.2.4
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// SchoolMIPS
module SchoolMIPS(
    // Inputs
    MMUART_0_RXD_F2M,
    rst_n_0,
    // Outputs
    MMUART_0_TXD_M2F
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  MMUART_0_RXD_F2M;
input  rst_n_0;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output MMUART_0_TXD_M2F;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          MMUART_0_RXD_F2M;
wire          MMUART_0_TXD_M2F_net_0;
wire          MSS1_MSS_0_GPIO_8_M2F;
wire          MSS1_MSS_0_GPIO_9_M2F;
wire          MSS1_MSS_0_GPIO_10_M2F;
wire          MSS1_MSS_0_GPIO_11_M2F;
wire          MSS1_MSS_0_GPIO_12_M2F;
wire          MSS1_MSS_0_GPIO_13_M2F;
wire          MSS1_MSS_0_GPIO_14_M2F;
wire          MSS1_MSS_0_SPI_0_CLK_M2F;
wire          MSS1_MSS_0_SPI_0_DO_M2F;
wire   [0:0]  MUX_0_dataout0to0;
wire   [1:1]  MUX_0_dataout1to1;
wire   [2:2]  MUX_0_dataout2to2;
wire   [3:3]  MUX_0_dataout3to3;
wire   [4:4]  MUX_0_dataout4to4;
wire   [5:5]  MUX_0_dataout5to5;
wire   [6:6]  MUX_0_dataout6to6;
wire   [7:7]  MUX_0_dataout7to7;
wire          OSC_0_RCOSC_25_50MHZ_O2F;
wire          rst_n_0;
wire   [31:0] sm_top_0_regData;
wire          sm_top_0_s_data_out;
wire          MMUART_0_TXD_M2F_net_1;
wire   [1:0]  sel_net_0;
wire   [7:0]  dataout_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire          VCC_net;
wire   [3:0]  clkDevide_const_net_0;
wire   [4:0]  regAddr_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net               = 1'b0;
assign VCC_net               = 1'b1;
assign clkDevide_const_net_0 = 4'h0;
assign regAddr_const_net_0   = 5'h00;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign MMUART_0_TXD_M2F_net_1 = MMUART_0_TXD_M2F_net_0;
assign MMUART_0_TXD_M2F       = MMUART_0_TXD_M2F_net_1;
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign MUX_0_dataout0to0[0] = dataout_net_0[0:0];
assign MUX_0_dataout1to1[1] = dataout_net_0[1:1];
assign MUX_0_dataout2to2[2] = dataout_net_0[2:2];
assign MUX_0_dataout3to3[3] = dataout_net_0[3:3];
assign MUX_0_dataout4to4[4] = dataout_net_0[4:4];
assign MUX_0_dataout5to5[5] = dataout_net_0[5:5];
assign MUX_0_dataout6to6[6] = dataout_net_0[6:6];
assign MUX_0_dataout7to7[7] = dataout_net_0[7:7];
//--------------------------------------------------------------------
// Concatenation assignments
//--------------------------------------------------------------------
assign sel_net_0 = { MSS1_MSS_0_GPIO_9_M2F , MSS1_MSS_0_GPIO_8_M2F };
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------MSS1_MSS
MSS1_MSS MSS1_MSS_0(
        // Inputs
        .MCCC_CLK_BASE    ( OSC_0_RCOSC_25_50MHZ_O2F ),
        .MMUART_0_RXD_F2M ( MMUART_0_RXD_F2M ),
        .GPIO_0_F2M       ( MUX_0_dataout0to0 ),
        .GPIO_1_F2M       ( MUX_0_dataout1to1 ),
        .GPIO_2_F2M       ( MUX_0_dataout2to2 ),
        .GPIO_3_F2M       ( MUX_0_dataout3to3 ),
        .GPIO_4_F2M       ( MUX_0_dataout4to4 ),
        .GPIO_5_F2M       ( MUX_0_dataout5to5 ),
        .GPIO_6_F2M       ( MUX_0_dataout6to6 ),
        .GPIO_7_F2M       ( MUX_0_dataout7to7 ),
        .MSS_RESET_N_F2M  ( rst_n_0 ),
        .M3_RESET_N       ( rst_n_0 ),
        .SPI_0_DI_F2M     ( sm_top_0_s_data_out ),
        .SPI_0_CLK_F2M    ( GND_net ),
        .SPI_0_SS0_F2M    ( VCC_net ),
        // Outputs
        .MMUART_0_TXD_M2F ( MMUART_0_TXD_M2F_net_0 ),
        .GPIO_8_M2F       ( MSS1_MSS_0_GPIO_8_M2F ),
        .GPIO_9_M2F       ( MSS1_MSS_0_GPIO_9_M2F ),
        .GPIO_11_M2F      ( MSS1_MSS_0_GPIO_11_M2F ),
        .GPIO_12_M2F      ( MSS1_MSS_0_GPIO_12_M2F ),
        .GPIO_13_M2F      ( MSS1_MSS_0_GPIO_13_M2F ),
        .GPIO_14_M2F      ( MSS1_MSS_0_GPIO_14_M2F ),
        .SPI_0_DO_M2F     ( MSS1_MSS_0_SPI_0_DO_M2F ),
        .SPI_0_CLK_M2F    ( MSS1_MSS_0_SPI_0_CLK_M2F ),
        .SPI_0_SS0_M2F    (  ),
        .SPI_0_SS0_M2F_OE (  ),
        .GPIO_10_M2F      ( MSS1_MSS_0_GPIO_10_M2F ) 
        );

//--------MUX
MUX MUX_0(
        // Inputs
        .sel     ( sel_net_0 ),
        .datain  ( sm_top_0_regData ),
        // Outputs
        .dataout ( dataout_net_0 ) 
        );

//--------SchoolMIPS_OSC_0_OSC   -   Actel:SgCore:OSC:2.0.101
SchoolMIPS_OSC_0_OSC OSC_0(
        // Inputs
        .XTL                ( GND_net ), // tied to 1'b0 from definition
        // Outputs
        .RCOSC_25_50MHZ_CCC (  ),
        .RCOSC_25_50MHZ_O2F ( OSC_0_RCOSC_25_50MHZ_O2F ),
        .RCOSC_1MHZ_CCC     (  ),
        .RCOSC_1MHZ_O2F     (  ),
        .XTLOSC_CCC         (  ),
        .XTLOSC_O2F         (  ) 
        );

//--------sm_top
sm_top sm_top_0(
        // Inputs
        .clkIn      ( OSC_0_RCOSC_25_50MHZ_O2F ),
        .rst_n      ( MSS1_MSS_0_GPIO_10_M2F ),
        .clkDevide  ( clkDevide_const_net_0 ),
        .clkEnable  ( GND_net ),
        .regAddr    ( regAddr_const_net_0 ),
        .s_data_in  ( MSS1_MSS_0_SPI_0_DO_M2F ),
        .mode       ( MSS1_MSS_0_GPIO_11_M2F ),
        .shift_dr   ( MSS1_MSS_0_GPIO_12_M2F ),
        .clk_dr     ( MSS1_MSS_0_SPI_0_CLK_M2F ),
        .update_dr  ( MSS1_MSS_0_GPIO_13_M2F ),
        .clk_cpu    ( MSS1_MSS_0_GPIO_14_M2F ),
        // Outputs
        .clk        (  ),
        .regData    ( sm_top_0_regData ),
        .s_data_out ( sm_top_0_s_data_out ) 
        );


endmodule
