module DAP #(parameter  BSR_NUMBER=1)
( 
    input   TDI,
    input   TMS,
    input   TCK,
    input   TRST,
    output  ICLK,
    output  TDO,
    input   [BSR_NUMBER-1:0]    s_data_out_dr,
    output  [BSR_NUMBER-1:0]    shift_dr,
    output  [BSR_NUMBER-1:0]    clock_dr,
    output  [BSR_NUMBER-1:0]    update_dr,
    output  [BSR_NUMBER-1:0]    mode_dr
);
    wire                    shift_tap;
    wire 					shift_id;
    wire 					shift_br;
    wire                    clk_tap;
    wire 					clk_br;
    wire 					clk_id;
    wire                    update_tap;
    wire 					update_br;
    wire 					update_id;
	wire					shift_ir;
	wire					clk_ir;
	wire					update_ir;
	wire					sel_tdo;
    wire 					s_data_out_ir;
    wire 					s_data_out_id;
    wire    [7:0]           p_data_out_ir;
    wire                    s_data_out_bypass;
    wire                    s_data_out;
    wire    [1:0]           sel_dr;

    assign TDO=sel_tdo?s_data_out_ir:s_data_out;

    tap_controller tap_controller_0
    (
        .TMS(TMS),
        .TCK(TCK),
        .TRST(TRST),
        .ICLK(ICLK),
        .mode(mode_dr),
        .shift_dr(shift_tap),
        .clk_dr(clk_tap),
        .update_dr(update_tap),
        .shift_ir(shift_ir),
        .clk_ir(clk_ir),
        .update_ir(update_ir),
        .state_out(state_out),
        .sel_tdo(sel_tdo)
    );
  
    mux_dr  mux_dr_0
    ( 
        .s_data_in({s_data_out_dr,s_data_out_id,s_data_out_bypass}),
        .shift_dr(shift_tap),
        .clk_dr(clk_tap),
        .update_dr(update_tap),
        .s_data_out(s_data_out),
        .shift_dr_out({shift_dr[0],shift_id,shift_br}),
        .clk_dr_out({clock_dr[0],clk_id,clk_br}),
        .update_dr_out({update_dr[0],update_id,update_br}),
        .sel(sel_dr)
    );

    ir_decoder #(.width(8)) ir_decoder_0
    ( 
        .p_data_in(p_data_out_ir),
        .sel(sel_dr)
    );

    bsr #(.width(32)) id_code
    (
        .p_data_in(32'h12345678),
        //.p_data_out(regData_out),
        .s_data_in(TDI),
        .s_data_out(s_data_out_id),
        .mode(mode),
        .shift_dr(shift_id),
        .clk_dr(clk_id),
        .update_dr(update_id),
        .ICLK(ICLK)
    );

    bypass_register    bypass_register_0
    ( 
        .s_data_in(TDI),
        .clock_dr(clk_br),
        .ICLK(ICLK),
        .s_data_out(s_data_out_bypass)
    );

    ir #(.width(8)) ir_reg
    (
        .p_data_in(8'hFF),
        .p_data_out(p_data_out_ir),
        .s_data_in(TDI),
        .s_data_out(s_data_out_ir),
        .shift_ir(shift_ir),
        .clk_ir(clk_ir),
        .update_ir(update_ir),
        .ICLK(ICLK)
    );

endmodule
