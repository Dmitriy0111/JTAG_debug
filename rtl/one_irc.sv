module one_irc
(
    input   logic   [0 : 0]     p_data_in,
    output  logic   [0 : 0]     p_data_out,
    input   logic   [0 : 0]     s_data_in,
    output  logic   [0 : 0]     s_data_out,

    input   logic   [0 : 0]     iclk,
    input   logic   [0 : 0]     reset,
    
    input   logic   [0 : 0]     shift_ir,
    input   logic   [0 : 0]     clk_ir,
    input   logic   [0 : 0]     update_ir
);
    logic   [0 : 0]     shift_ir_mux;
    logic   [0 : 0]     CAP;
    logic   [0 : 0]     UPD;

    assign shift_ir_mux = shift_ir ? s_data_in : p_data_in;
    assign s_data_out   = CAP;
    assign p_data_out   = UPD;
    
    always_ff @(posedge iclk, negedge resetn)
        if( !resetn )
            CAP <= '0;
        else
        begin
            if( clk_ir == 1'b1 )
                CAP <= shift_ir_mux;
            else
                CAP <= CAP;
        end
    
    always_ff @(posedge iclk, negedge resetn)
        if( !resetn )
            UPD <= p_data_in;
        else if( update_ir == 1'b1 )
                UPD <= CAP;
    
endmodule : one_irc
    