/*
*  File            :   etap_constants.svh
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.27
*  Language        :   SystemVerilog
*  Description     :   This constants
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

//  etap instruction codes
`define     ETAP_IDCODE         5'd1
`define     ETAP_IMPCODE        5'd3
`define     ETAP_ADDRESS        5'd8
`define     ETAP_DATA           5'd9
`define     ETAP_CONTROL        5'd10
`define     ETAP_EJTAGBOOT      5'd12
`define     SAMPLE_PRELOAD      5'd0
`define     BYPASS              5'd2
`define     ANY                 5'b?????

//  ir_decoder constants
`define     SEL_ETAP_IDCODE     4'b0000
`define     SEL_ETAP_IMPCODE    4'b0001
`define     SEL_ETAP_ADDRESS    4'b0010
`define     SEL_ETAP_DATA       4'b0011
`define     SEL_ETAP_CONTROL    4'b0100
`define     SEL_ETAP_EJTAGBOOT  4'b0101
`define     SEL_SAMPLE_PRELOAD  4'b0110
`define     SEL_BYPASS          4'b0111
`define     SEL_ANY             4'b1000
