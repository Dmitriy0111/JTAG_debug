/*
*  File            :   dp_mux_dr.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.01
*  Language        :   SystemVerilog
*  Description     :   This is debug mux for data register
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

`include "dp_constants.svh"

module dp_mux_dr
( 
    input   logic   [7 : 0]     s_data_in,
    input   logic   [0 : 0]     shift_dr,
    input   logic   [0 : 0]     clk_dr,
    input   logic   [0 : 0]     update_dr,
    output  logic   [0 : 0]     s_data_out,
    output  logic   [7 : 0]     shift_dr_out,
    output  logic   [7 : 0]     clk_dr_out,
    output  logic   [7 : 0]     update_dr_out,
    input   logic   [3 : 0]     sel
);

    always_comb
    begin
        s_data_out      = 1'b0;
        shift_dr_out    = 8'h00;
        clk_dr_out      = 8'h00;
        update_dr_out   = 8'h00;
        casex( sel )
            `SEL_ETAP_IDCODE:     
                begin 
                    s_data_out                          = s_data_in[`SEL_ETAP_IDCODE];
                    update_dr_out[`SEL_ETAP_IDCODE]     = update_dr; 
                    clk_dr_out[`SEL_ETAP_IDCODE]        = clk_dr; 
                    shift_dr_out[`SEL_ETAP_IDCODE]      = shift_dr;
                end
            `SEL_ETAP_IMPCODE:
                begin 
                    s_data_out                          = s_data_in[`SEL_ETAP_IMPCODE];
                    update_dr_out[`SEL_ETAP_IMPCODE]    = update_dr; 
                    clk_dr_out[`SEL_ETAP_IMPCODE]       = clk_dr; 
                    shift_dr_out[`SEL_ETAP_IMPCODE]     = shift_dr;
                end
            `SEL_ETAP_ADDRESS:
                begin 
                    s_data_out                          = s_data_in[`SEL_ETAP_ADDRESS];
                    update_dr_out[`SEL_ETAP_ADDRESS]    = update_dr; 
                    clk_dr_out[`SEL_ETAP_ADDRESS]       = clk_dr; 
                    shift_dr_out[`SEL_ETAP_ADDRESS]     = shift_dr;
                end
            `SEL_ETAP_DATA:       
                begin 
                    s_data_out                          = s_data_in[`SEL_ETAP_DATA];
                    update_dr_out[`SEL_ETAP_DATA]       = update_dr; 
                    clk_dr_out[`SEL_ETAP_DATA]          = clk_dr; 
                    shift_dr_out[`SEL_ETAP_DATA]        = shift_dr;
                end
            `SEL_ETAP_CONTROL:    
                begin 
                    s_data_out                          = s_data_in[`SEL_ETAP_CONTROL];
                    update_dr_out[`SEL_ETAP_CONTROL]    = update_dr; 
                    clk_dr_out[`SEL_ETAP_CONTROL]       = clk_dr; 
                    shift_dr_out[`SEL_ETAP_CONTROL]     = shift_dr;
                end
            `SEL_ETAP_EJTAGBOOT:  
                begin 
                    s_data_out                          = s_data_in[`SEL_ETAP_EJTAGBOOT];
                    update_dr_out[`SEL_ETAP_EJTAGBOOT]  = update_dr; 
                    clk_dr_out[`SEL_ETAP_EJTAGBOOT]     = clk_dr; 
                    shift_dr_out[`SEL_ETAP_EJTAGBOOT]   = shift_dr;
                end
            `SEL_SAMPLE_PRELOAD:  
                begin 
                    s_data_out                          = s_data_in[`SEL_SAMPLE_PRELOAD];
                    update_dr_out[`SEL_SAMPLE_PRELOAD]  = update_dr; 
                    clk_dr_out[`SEL_SAMPLE_PRELOAD]     = clk_dr; 
                    shift_dr_out[`SEL_SAMPLE_PRELOAD]   = shift_dr;
                end
            `SEL_BYPASS:          
                begin 
                    s_data_out                          = s_data_in[`SEL_BYPASS];
                    update_dr_out[`SEL_BYPASS]          = update_dr; 
                    clk_dr_out[`SEL_BYPASS]             = clk_dr; 
                    shift_dr_out[`SEL_BYPASS]           = shift_dr;
                end
            `SEL_ANY:             
                begin 
                    s_data_out                          = s_data_in[`SEL_ETAP_IDCODE];
                    update_dr_out[`SEL_ETAP_IDCODE]     = update_dr; 
                    clk_dr_out[`SEL_ETAP_IDCODE]        = clk_dr; 
                    shift_dr_out[`SEL_ETAP_IDCODE]      = shift_dr;
                end
        endcase
    end

endmodule : dp_mux_dr
