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
    // clock and reset
    input   logic   [0 : 0]     iclk,       // internal clock
    input   logic   [0 : 0]     iresetn,    // internal reset
    // serial data
    input   logic   [0 : 0]     sdi,        // serial data input
    output  logic   [0 : 0]     sdo,        // serial data output
    // from tap controller
    input   logic   [0 : 0]     clock_dr    // clock data register
);

    always_ff @(posedge iclk, negedge iresetn)
        if( !iresetn )
            sdo <= '0;
        else
            sdo <= clock_dr ? sdi : sdo;
            
endmodule : dp_br
