/*
*  File            :   dp_br.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.01
*  Language        :   SystemVerilog
*  Description     :   This is debug bypass register
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

module dp_br
( 
    input   logic   [0 : 0]     s_data_in,
    input   logic   [0 : 0]     clock_dr,

    input   logic   [0 : 0]     iclk,

    output  logic   [0 : 0]     s_data_out
);

    always_ff @( posedge iclk )
        if( clock_dr == 1'b1 )
            s_data_out <= s_data_in;
            
endmodule : dp_br
