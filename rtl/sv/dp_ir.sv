/*
*  File            :   dp_ir.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.01
*  Language        :   SystemVerilog
*  Description     :   This is debug instruction register
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

module dp_ir 
#(
    parameter                       width = 8,
                                    UPD_r = 8'h55,
                                    CAP_r = 8'haa
)(
    // clock and reset
    input   logic   [0       : 0]   iclk,       // internal clock
    input   logic   [0       : 0]   iresetn,    // internal reset
    // parallel data
    input   logic   [width-1 : 0]   pdi,        // parallel data input
    output  logic   [width-1 : 0]   pdo,        // parallel data output
    // serial data
    input   logic   [0       : 0]   sdi,        // serial data input
    output  logic   [0       : 0]   sdo,        // serial data output
    // from tap controller
    input   logic   [0       : 0]   shift_ir,   // shift instruction register
    input   logic   [0       : 0]   clk_ir,     // clock instruction register
    input   logic   [0       : 0]   update_ir   // update instruction register
);

    logic   [width : 0]     i_con;      // internal connect

    assign sdo      = i_con[width];
    assign i_con[0] = sdi;

    genvar irc_n;   // number of instruction register cells

    generate
        for( irc_n = 0 ; irc_n < width ; irc_n = irc_n + 1 )
        begin : generate_irc
            dp_one_irc
            #(
                .UPD_r      ( UPD_r [irc_n]         ),
                .CAP_r      ( CAP_r [irc_n]         )
            )
            dp_one_irc_ 
            (
                // clock and reset
                .iclk       ( iclk                  ),  // internal clock
                .iresetn    ( iresetn               ),  // internal reset
                // parallel data
                .pdi        ( pdi   [irc_n        ] ),  // parallel data input
                .pdo        ( pdo   [irc_n        ] ),  // parallel data output
                // serial data
                .sdi        ( i_con [width-irc_n-1] ),  // serial data input
                .sdo        ( i_con [width-irc_n-0] ),  // serial data output
                // from tap controller
                .shift_ir   ( shift_ir              ),  // shift instruction register
                .clk_ir     ( clk_ir                ),  // clock instruction register
                .update_ir  ( update_ir             )   // update instruction register

            );
        end
    endgenerate

endmodule : dp_ir
