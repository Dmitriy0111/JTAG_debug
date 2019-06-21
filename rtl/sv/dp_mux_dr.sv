/*
*  File            :   dp_mux_dr.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.01
*  Language        :   SystemVerilog
*  Description     :   This is debug mux for data register
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

`include "../../inc/sv/dp_constants.svh"

module dp_mux_dr
( 
    input   logic   [3 : 0][0 : 0]  sdi,            // serial data input
    input   logic   [0 : 0]         shift_dr,       // shift data register
    input   logic   [0 : 0]         clk_dr,         // clock data register
    input   logic   [0 : 0]         update_dr,      // update data register

    output  logic   [0 : 0]         sdo,            // serial data output
    output  logic   [3 : 0][0 : 0]  shift_dr_out,   // shift data register output
    output  logic   [3 : 0][0 : 0]  clk_dr_out,     // clock data register output
    output  logic   [3 : 0][0 : 0]  update_dr_out,  // update data register output

    input   logic   [3 : 0]         bsr_sel         // selecting data output
);

    always_comb
    begin
        sdo             = 1'b0;
        clk_dr_out      = 4'h0;
        shift_dr_out    = 4'h0;
        update_dr_out   = 4'h0;
        casex( bsr_sel )
            SEL_IDCODE:
                begin 
                    sdo                             = sdi[SEL_IDCODE];
                    update_dr_out   [SEL_IDCODE]    = update_dr; 
                    clk_dr_out      [SEL_IDCODE]    = clk_dr; 
                    shift_dr_out    [SEL_IDCODE]    = shift_dr;
                end
            SEL_DTMCS:
                begin 
                    sdo                             = sdi[SEL_DTMCS];
                    update_dr_out   [SEL_DTMCS]     = update_dr; 
                    clk_dr_out      [SEL_DTMCS]     = clk_dr; 
                    shift_dr_out    [SEL_DTMCS]     = shift_dr;
                end
            SEL_DMI:
                begin 
                    sdo                             = sdi[SEL_DMI];
                    update_dr_out   [SEL_DMI]       = update_dr; 
                    clk_dr_out      [SEL_DMI]       = clk_dr; 
                    shift_dr_out    [SEL_DMI]       = shift_dr;
                end
            SEL_BYPASS:
                begin 
                    sdo                             = sdi[SEL_BYPASS];
                    update_dr_out   [SEL_BYPASS]    = update_dr; 
                    clk_dr_out      [SEL_BYPASS]    = clk_dr; 
                    shift_dr_out    [SEL_BYPASS]    = shift_dr;
                end
            SEL_ANY:
                begin 
                    sdo                             = sdi[SEL_IDCODE];
                    update_dr_out   [SEL_IDCODE]    = update_dr; 
                    clk_dr_out      [SEL_IDCODE]    = clk_dr; 
                    shift_dr_out    [SEL_IDCODE]    = shift_dr;
                end
            default:;
        endcase
    end

endmodule : dp_mux_dr
