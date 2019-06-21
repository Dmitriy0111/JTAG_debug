/*
*  File            :   dp_constants.svh
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.27
*  Language        :   SystemVerilog
*  Description     :   This constants
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/


`ifndef JTAG_CONSTANTS
`define JTAG_CONSTANTS

// instruction register lenght
`define     INSTR_REG_LEN   5
`define     INSTR_REG_RST_V 5'h01

// instruction decoder selections
typedef enum logic [3 : 0]
{
    SEL_IDCODE  =   4'h0,
    SEL_DTMCS   =   4'h1,
    SEL_DMI     =   4'h2,
    SEL_BYPASS  =   4'h3,
    SEL_ANY     =   4'b????
} sel_dr_types;

// risv-v JTAG DTM registers
typedef enum logic [4 : 0]
{
    BYPASS_0        =   5'h00,
    IDCODE          =   5'h01,
    DTMCS           =   5'h10,
    DMI             =   5'h11,
    RSV_BYPASS_0    =   5'h12,
    RSV_BYPASS_1    =   5'h13,
    RSV_BYPASS_2    =   5'h14,
    RSV_BYPASS_3    =   5'h15,
    RSV_BYPASS_4    =   5'h16,
    RSV_BYPASS_5    =   5'h17,
    BYPASS_1        =   5'h1f,
    ANY             =   5'b?????
} ir_types;

`endif
