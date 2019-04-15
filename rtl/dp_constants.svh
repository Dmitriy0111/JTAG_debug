/*
*  File            :   etap_constants.svh
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.27
*  Language        :   SystemVerilog
*  Description     :   This constants
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

// instruction register lenght
`define     INSTR_REG_LEN   5
`define     INSTR_REG_RST_V 5'h01
// instruction decoder selections
`define     SEL_IDCODE      4'h0
`define     SEL_DTMCS       4'h1
`define     SEL_DMI         4'h2
`define     SEL_BYPASS      4'h3
`define     SEL_ANY         4'b????
// risv-v JTAG DTM registers
`define     BYPASS_0        5'h00
`define     IDCODE          5'h01
`define     DTMCS           5'h10   // debug control and status
`define     DMI             5'h11   // debug module interface access
`define     RSV_BYPASS_0    5'h12
`define     RSV_BYPASS_1    5'h13
`define     RSV_BYPASS_2    5'h14
`define     RSV_BYPASS_3    5'h15
`define     RSV_BYPASS_4    5'h16
`define     RSV_BYPASS_5    5'h17
`define     BYPASS_1        5'h1f
`define     ANY             5'b?????
