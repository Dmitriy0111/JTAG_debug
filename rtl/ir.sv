module ir 
#(
    parameter                       width = 8
)(
    input   logic   [width-1 : 0]   p_data_in,
    output  logic   [width-1 : 0]   p_data_out,
    input   logic   [0       : 0]   s_data_in,
    output  logic   [0       : 0]   s_data_out,

    input   logic   [0       : 0]   shift_ir,
    input   logic   [0       : 0]   clk_ir,
    input   logic   [0       : 0]   update_ir,

    input   logic   [0       : 0]   iclk,
    input   logic   [0       : 0]   reset
);

    logic   [width : 0]     internal_connect;

    assign s_data_out           = internal_connect[width] ;
    assign internal_connect[0]  = s_data_in ;

    genvar number_of_irc;

    generate
        for( number_of_irc = 0 ; number_of_irc < width ; number_of_irc = number_of_irc + 1 )
        begin:generate_irc
            one_irc
            one_irc_ (
                .p_data_in          ( p_data_in[number_of_irc]                  ),
                .p_data_out         ( p_data_out[number_of_irc]                 ),
                .s_data_in          ( internal_connect[width-number_of_irc-1]   ),
                .s_data_out         ( internal_connect[width-number_of_irc]     ),

                .shift_ir           ( shift_ir                                  ),
                .clk_ir             ( clk_ir                                    ),
                .update_ir          ( update_ir                                 ),

                .iclk               ( iclk                                      ),
                .reset              ( reset                                     )
            );
        end
    endgenerate

endmodule : ir
