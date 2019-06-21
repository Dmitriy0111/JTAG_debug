/*
*  File            :   dp_one_irc.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.01
*  Language        :   SystemVerilog
*  Description     :   This is debug instruction register cell
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

module dp_one_irc
#(
    parameter                   UPD_r = '0,
                                CAP_r = '0
)(
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
    input   logic   [0 : 0]     shift_ir,   // shift instruction register
    input   logic   [0 : 0]     clk_ir,     // clock instruction register
    input   logic   [0 : 0]     update_ir   // update instruction register
);

    logic   [0 : 0]     shift_ir_mux;   // for selecting data 
    logic   [0 : 0]     CAP;            // capture register
    logic   [0 : 0]     UPD;            // update register

    assign shift_ir_mux = shift_ir ? sdi : pdi;
    assign sdo   = CAP;
    assign pdo   = UPD;
    
    always_ff @(posedge iclk, negedge iresetn)
        if( !iresetn )
            CAP <= CAP_r;
        else
            CAP <= clk_ir ? shift_ir_mux : CAP;

    always_ff @(posedge iclk, negedge iresetn)
        if( !iresetn )
            UPD <= UPD_r;
        else
            UPD <= update_ir ? CAP : UPD;
    
endmodule : dp_one_irc
    