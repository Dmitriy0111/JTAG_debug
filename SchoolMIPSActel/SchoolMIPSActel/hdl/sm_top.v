
//hardware top level module
module sm_top
(
    input           clkIn,
    input           rst_n,
    input   [ 3:0 ] clkDevide,
    input           clkEnable,
    output          clk,
    input   [ 4:0 ] regAddr,
    output  [31:0 ] regData,
    input           TMS,
    input           TCK,
    input           TDI,
    output          TDO,
    input           TRST,
//	 input			  s_data_in,
//	 output			  s_data_out,
//	 input			  mode,
//	 input			  shift_dr,
//	 input			  clk_dr,
//	 input			  update_dr,
	 input			  clk_cpu,
	 output   [3:0]	  state_out
);
    //metastability input filters
    wire    [ 3:0 ] devide;
    wire            enable;
    wire    [ 4:0 ] addr;

    sm_debouncer #(.SIZE(4)) f0(clkIn, clkDevide, devide);
    sm_debouncer #(.SIZE(1)) f1(clkIn, clkEnable, enable);
    sm_debouncer #(.SIZE(5)) f2(clkIn, regAddr,   addr  );

    //cores
    //clock devider
    sm_clk_divider sm_clk_divider
    (
        .clkIn      ( clkIn     ),
        .rst_n      ( rst_n     ),
        .devide     ( devide    ),
        .enable     ( enable&(~mode)    ),
        .clkOut     ( clk       )
    );

    //instruction memory
    wire    [31:0]  imAddr;
    wire    [31:0]  imData;
    sm_rom reset_rom(imAddr, imData);
	 
	 wire [31:0] regData_in;
	 wire [31:0] regData_out;
	 wire [7:0] regAddr_in;
	 wire [7:0] regAddr_out;
	 assign regData=regData_out;
	 assign regAddr_in={3'b0,addr};
	 wire internal_conneckt;


	wire					ICLK;
	wire 					mode;
    wire                    shift_tap;
	wire 					shift_dr;
    wire 					shift_id;
    wire 					shift_br;
    wire                    clk_tap;
	wire 					clk_dr;
    wire 					clk_br;
    wire 					clk_id;
    wire                    update_tap;
	wire 					update_dr;
    wire 					update_br;
    wire 					update_id;
	wire					shift_ir;
	wire					clk_ir;
	wire					update_ir;

	wire					sel_tdo;
	wire 					s_data_out_dr;
    wire 					s_data_out_ir;
    wire 					s_data_out_id;
    wire    [7:0]           p_data_out_ir;
    wire                    s_data_out_bypass;

    wire                    s_data_out;
    wire    [1:0]           sel_dr;

	//assign s_data_out=(sel_dr==2'b00)?s_data_out_id:(sel_dr==2'b10)?s_data_out_dr:1'b0;
	assign TDO=sel_tdo?s_data_out_ir:s_data_out;

    tap_controller tap_controller_
    (
    TMS,TCK,TRST,ICLK,mode,shift_tap,clk_tap,update_tap,shift_ir,clk_ir,update_ir,state_out,sel_tdo
    );

    mux_dr  mux_dr_
    ( 
        .s_data_in({s_data_out_dr,s_data_out_id,s_data_out_bypass}),
        .shift_dr(shift_tap),
        .clk_dr(clk_tap),
        .update_dr(update_tap),
        .s_data_out(s_data_out),
        .shift_dr_out({shift_dr,shift_id,shift_br}),
        .clk_dr_out({clk_dr,clk_id,clk_br}),
        .update_dr_out({update_dr,update_id,update_br}),
        .sel(sel_dr)
    );

    ir_decoder #(.width(8)) ir_decoder
    ( 
        .p_data_in(p_data_out_ir),
        .sel(sel_dr)
    );
	 
	 bsr #(.width(32)) bsr_regData
	 (
			.p_data_in(regData_in),
			.p_data_out(regData_out),
			.s_data_in(internal_connect),
			.s_data_out(s_data_out_dr),
			.mode(mode),
			.shift_dr(shift_dr),
			.clk_dr(clk_dr),
			.update_dr(update_dr),
            .ICLK(ICLK)
	 );

     
	
	 bsr #(.width(8)) bsr_regAddr
	 (
			.p_data_in(regAddr_in),
			.p_data_out(regAddr_out),
			.s_data_in(TDI),
			.s_data_out(internal_connect),
			.mode(mode),
			.shift_dr(shift_dr),
			.clk_dr(clk_dr),
			.update_dr(update_dr),
            .ICLK(ICLK)
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

     bypass_register    bypass_register_
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

    sm_cpu sm_cpu
    (
        .clk        ( clk_cpu       ),
        .rst_n      ( rst_n     ),
        .regAddr    ( regAddr_out[4:0]      ),
        .regData    ( regData_in   ),
        .imAddr     ( imAddr    ),
        .imData     ( imData    )
    );

endmodule

//metastability input debouncer module
module sm_debouncer
#(
    parameter SIZE = 1
)
(
    input                      clk,
    input      [ SIZE - 1 : 0] d,
    output reg [ SIZE - 1 : 0] q
);
    reg        [ SIZE - 1 : 0] data;

    always @ (posedge clk) begin
        data <= d;
        q    <= data;
    end

endmodule

//tunable clock devider
module sm_clk_divider
#(
    parameter shift  = 16,
              bypass = 0
)
(
    input           clkIn,
    input           rst_n,
    input   [ 3:0 ] devide,
    input           enable,
    output          clkOut
);
    wire [31:0] cntr;
    wire [31:0] cntrNext = cntr + 1;
    sm_register_we r_cntr(clkIn, rst_n, enable, cntrNext, cntr);

    assign clkOut = bypass ? clkIn 
                           : cntr[shift + devide];
endmodule
