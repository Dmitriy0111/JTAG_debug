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
    output  [BSR_NUMBER-1:0]    mode_dr,
    output  [3:0]               state_out
);
    wire                    shift_tap;
    wire                    clk_tap;
    wire                    update_tap;
	wire					shift_ir;
	wire					clk_ir;
	wire					update_ir;
	wire					sel_tdo;
    wire 					s_data_out_ir;
    wire    [4:0]           p_data_out_ir;
    wire                    s_data_out;
    wire    [3:0]           sel_dr;
    wire    [7:0]           s_data_out_reg;
    wire    [7:0]           shift_reg;
    wire    [7:0]           clk_reg;
    wire    [7:0]           update_reg;

    localparam  SEL_ETAP_IDCODE     =4'b0000,
                SEL_ETAP_IMPCODE    =4'b0001,
                SEL_ETAP_ADDRESS    =4'b0010,
                SEL_ETAP_DATA       =4'b0011,
                SEL_ETAP_CONTROL    =4'b0100,
                SEL_ETAP_EJTAGBOOT  =4'b0101,
                SEL_SAMPLE_PRELOAD  =4'b0110,
                SEL_BYPASS          =4'b0111,
                SEL_ANY             =4'b1000;

    assign s_data_out_reg[SEL_SAMPLE_PRELOAD]=s_data_out_dr;
    assign shift_dr=shift_reg[SEL_SAMPLE_PRELOAD];
    assign clock_dr=clk_reg[SEL_SAMPLE_PRELOAD];
    assign update_dr=update_reg[SEL_SAMPLE_PRELOAD];
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
        .s_data_in(s_data_out_reg),
        .shift_dr(shift_tap),
        .clk_dr(clk_tap),
        .update_dr(update_tap),
        .s_data_out(s_data_out),
        .shift_dr_out(shift_reg),
        .clk_dr_out(clk_reg),
        .update_dr_out(update_reg),
        .sel(sel_dr)
    );

    ir_decoder #(.width(5)) ir_decoder_0
    ( 
        .p_data_in(p_data_out_ir),
        .sel(sel_dr)
    );

    bsr #(.width(32)) reg_etap_idcode
    (
        .p_data_in({{4'h1},{17'h1},{10'h1},{1'h0}}),
        //.p_data_out(regData_out),
        .s_data_in(TDI),
        .s_data_out(s_data_out_reg[SEL_ETAP_IDCODE]),
        .mode(mode),
        .shift_dr(shift_reg[SEL_ETAP_IDCODE]),
        .clk_dr(clk_reg[SEL_ETAP_IDCODE]),
        .update_dr(update_reg[SEL_ETAP_IDCODE]),
        .ICLK(ICLK)
    );
    bsr #(.width(32)) reg_etap_impcode
    (
        .p_data_in({{3'h1},{4'h0},{1'h0},{3'h0},{4'h0},{1'h0},{1'h0},{1'h1},{14'h0}}),
        //.p_data_out(regData_out),
        .s_data_in(TDI),
        .s_data_out(s_data_out_reg[SEL_ETAP_IMPCODE]),
        .mode(mode),
        .shift_dr(shift_reg[SEL_ETAP_IMPCODE]),
        .clk_dr(clk_reg[SEL_ETAP_IMPCODE]),
        .update_dr(update_reg[SEL_ETAP_IMPCODE]),
        .ICLK(ICLK)
    );
    bsr #(.width(32)) reg_etap_data
    (
        .p_data_in(32'h55aa55aa),
        //.p_data_out(regData_out),
        .s_data_in(TDI),
        .s_data_out(s_data_out_reg[SEL_ETAP_DATA]),
        .mode(mode),
        .shift_dr(shift_reg[SEL_ETAP_DATA]),
        .clk_dr(clk_reg[SEL_ETAP_DATA]),
        .update_dr(update_reg[SEL_ETAP_DATA]),
        .ICLK(ICLK)
    );
    bsr #(.width(32)) reg_etap_addr
    (
        .p_data_in(32'h0FF200200),
        //.p_data_out(regData_out),
        .s_data_in(TDI),
        .s_data_out(s_data_out_reg[SEL_ETAP_ADDRESS]),
        .mode(mode),
        .shift_dr(shift_reg[SEL_ETAP_ADDRESS]),
        .clk_dr(clk_reg[SEL_ETAP_ADDRESS]),
        .update_dr(update_reg[SEL_ETAP_ADDRESS]),
        .ICLK(ICLK)
    );
    bsr #(.width(32)) reg_etap_control
    (
        .p_data_in(32'h12345678),
        //.p_data_out(regData_out),
        .s_data_in(TDI),
        .s_data_out(s_data_out_reg[SEL_ETAP_CONTROL]),
        .mode(mode),
        .shift_dr(shift_reg[SEL_ETAP_CONTROL]),
        .clk_dr(clk_reg[SEL_ETAP_CONTROL]),
        .update_dr(update_reg[SEL_ETAP_CONTROL]),
        .ICLK(ICLK)
    );
    bsr #(.width(32)) reg_etap_ejtagboot
    (
        .p_data_in(32'haa55aa55),
        //.p_data_out(regData_out),
        .s_data_in(TDI),
        .s_data_out(s_data_out_reg[SEL_ETAP_EJTAGBOOT]),
        .mode(mode),
        .shift_dr(shift_reg[SEL_ETAP_EJTAGBOOT]),
        .clk_dr(clk_reg[SEL_ETAP_EJTAGBOOT]),
        .update_dr(update_reg[SEL_ETAP_EJTAGBOOT]),
        .ICLK(ICLK)
    );
    bypass_register    bypass_register_0
    ( 
        .s_data_in(TDI),
        .clock_dr(clk_reg[SEL_BYPASS]),
        .ICLK(ICLK),
        .s_data_out(s_data_out_reg[SEL_BYPASS])
    );

    ir #(.width(5)) ir_reg
    (
        .p_data_in(5'h1),
        .p_data_out(p_data_out_ir),
        .s_data_in(TDI),
        .s_data_out(s_data_out_ir),
        .shift_ir(shift_ir),
        .clk_ir(clk_ir),
        .update_ir(update_ir),
        .ICLK(ICLK),
        .reset(TRST)
    );

endmodule
