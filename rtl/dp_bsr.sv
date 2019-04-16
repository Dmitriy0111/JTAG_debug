/*
*  File            :   dp_bsr.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.03.26
*  Language        :   SystemVerilog
*  Description     :   This is debug boundary scan register
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

module dp_bsr 
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
    input   logic   [0       : 0]   mode,       // mode
    input   logic   [0       : 0]   shift_dr,   // shift data register
    input   logic   [0       : 0]   clk_dr,     // clock data register
    input   logic   [0       : 0]   update_dr   // update data register
);

    logic   [width : 0]     i_con;  // internal connect

    assign sdo      = i_con[width];
    assign i_con[0] = sdi;

    genvar bsc_n;   // number of boundary scan cells 

    generate
        for( bsc_n = 0 ; bsc_n < width ; bsc_n = bsc_n + 1 )
        begin: generate_bsr
            dp_one_bsc
            #(
                .UPD_r      ( UPD_r [bsc_n]         ),
                .CAP_r      ( CAP_r [bsc_n]         )
            )
            dp_one_bsc_ 
            (
                // clock and reset
                .iclk       ( iclk                  ),  // internal clock
                .iresetn    ( iresetn               ),  // internal reset
                // parallel data
                .pdi        ( pdi   [bsc_n        ] ),  // parallel data input
                .pdo        ( pdo   [bsc_n        ] ),  // parallel data output
                // serial data
                .sdi        ( i_con [width-bsc_n-1] ),  // serial data input
                .sdo        ( i_con [width-bsc_n-0] ),  // serial data output
                // from tap controller
                .mode       ( mode                  ),  // mode
                .shift_dr   ( shift_dr              ),  // shift data register
                .clk_dr     ( clk_dr                ),  // clock data register
                .update_dr  ( update_dr             )   // update data register
                
            );
        end
    endgenerate

endmodule : dp_bsr
