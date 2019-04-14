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
    input   logic   [0 : 0]     p_data_in,
    output  logic   [0 : 0]     p_data_out,
    input   logic   [0 : 0]     s_data_in,
    output  logic   [0 : 0]     s_data_out,

    input   logic   [0 : 0]     iclk,

    input   logic   [0 : 0]     mode,
    input   logic   [0 : 0]     shift_dr,
    input   logic   [0 : 0]     clk_dr,
    input   logic   [0 : 0]     update_dr
);
    logic   [0 : 0]     shift_dr_mux;
    logic   [0 : 0]     CAP;
    logic   [0 : 0]     UPD;
    
    assign shift_dr_mux = shift_dr ? s_data_in : p_data_in;
    assign s_data_out   = CAP;
    assign p_data_out   = mode ? UPD :p_data_in;
    
    always_ff @(posedge iclk)
        begin
            if( clk_dr == 1'b1 )
                CAP <= shift_dr_mux;
            else
                CAP <= CAP;
                
            if( update_dr == 1'b1 )
                UPD <= CAP;
        end
    
endmodule : dp_one_bsc
    