module bypass_register
( 
    input           s_data_in,
    input           clock_dr,

    input           ICLK,

    output  reg     s_data_out
);
    always @( posedge ICLK )
        if( clock_dr == 1'b1 )
            s_data_out <= s_data_in ;
            
endmodule
