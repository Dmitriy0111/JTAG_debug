module bypass_register
( 
    input   logic   [0 : 0]     s_data_in,
    input   logic   [0 : 0]     clock_dr,

    input   logic   [0 : 0]     iclk,

    output  logic   [0 : 0]     s_data_out
);

    always_ff @( posedge iclk )
        if( clock_dr == 1'b1 )
            s_data_out <= s_data_in;
            
endmodule : bypass_register
