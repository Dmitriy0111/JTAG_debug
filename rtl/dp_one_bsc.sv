/*
*  File            :   dp_one_bsc.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.03.26
*  Language        :   SystemVerilog
*  Description     :   This is debug boundary scan cell
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

module dp_one_bsc
(
    // clock and reset
    input   logic   [0 : 0]     iclk,       // internal clock
    input   logic   [0 : 0]     iresetn,    // internal reset
    // parallel data
    input   logic   [0 : 0]     pdi,        // parallel data input
    output  logic   [0 : 0]     pdo,        // parallel data output
    // serial data
    input   logic   [0 : 0]     sdi,        // serial data input
    output  logic   [0 : 0]     sdo,        // serial data output
    // from tap controller
    input   logic   [0 : 0]     mode,       // mode
    input   logic   [0 : 0]     shift_dr,   // shift data register
    input   logic   [0 : 0]     clk_dr,     // clock data register
    input   logic   [0 : 0]     update_dr   // update data register
);

    logic   [0 : 0]     shift_dr_mux;   // for selecting data 
    logic   [0 : 0]     CAP;            // capture register
    logic   [0 : 0]     UPD;            // update register
    
    assign shift_dr_mux = shift_dr ? sdi : pdi;
    assign sdo   = CAP;
    assign pdo   = mode ? UPD :pdi;
    
    always_ff @(posedge iclk, negedge iresetn)
        if( !iresetn )
            CAP <= '0;
        else
            CAP <= clk_dr ? shift_dr_mux : CAP;

    always_ff @(posedge iclk, negedge iresetn)
        if( !iresetn )
            UPD <= '0;
        else
            UPD <= update_dr ? CAP : UPD;
    
endmodule : dp_one_bsc
    