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
    parameter                       width = 32
)(
    input   logic   [width-1 : 0]   p_data_in,
    output  logic   [width-1 : 0]   p_data_out,

    input   logic   [0       : 0]   s_data_in,
    output  logic   [0       : 0]   s_data_out,

    input   logic   [0       : 0]   mode,
    input   logic   [0       : 0]   shift_dr,
    input   logic   [0       : 0]   clk_dr,
    input   logic   [0       : 0]   update_dr,

    input   logic   [0       : 0]   iclk
);

    logic   [width : 0]     internal_connect;

    assign s_data_out           = internal_connect[width];
    assign internal_connect[0]  = s_data_in;

    genvar number_of_bsc;

    generate
        for( number_of_bsc = 0 ; number_of_bsc < width ; number_of_bsc = number_of_bsc + 1 )
        begin: generate_bsr
            dp_one_bsc
            dp_one_bsc_ (
                .p_data_in      ( p_data_in[number_of_bsc]                  ),
                .p_data_out     ( p_data_out[number_of_bsc]                 ),
                .s_data_in      ( internal_connect[width-number_of_bsc-1]   ),
                .s_data_out     ( internal_connect[width-number_of_bsc]     ),

                .mode           ( mode                                      ),
                .shift_dr       ( shift_dr                                  ),
                .clk_dr         ( clk_dr                                    ),
                .update_dr      ( update_dr                                 ),
                
                .iclk           ( iclk                                      )
            );
        end
    endgenerate

endmodule : dp_bsr
