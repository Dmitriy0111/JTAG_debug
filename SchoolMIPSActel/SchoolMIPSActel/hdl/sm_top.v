
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
	 input			  s_data_in,
	 output			  s_data_out,
	 input			  mode,
	 input			  shift_dr,
	 input			  clk_dr,
	 input			  update_dr,
	 input			  clk_cpu
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
	 
	 BSR #(.width(32)) BSR_regData
	 (
			.p_data_in(regData_in),
			.p_data_out(regData_out),
			.s_data_in(internal_connect),
			.s_data_out(s_data_out),
			.mode(mode),
			.shift_dr(shift_dr),
			.clk_dr(clk_dr),
			.update_dr(update_dr)

	 );
	
	 BSR #(.width(8)) BSR_regAddr
	 (
			.p_data_in(regAddr_in),
			.p_data_out(regAddr_out),
			.s_data_in(s_data_in),
			.s_data_out(internal_connect),
			.mode(mode),
			.shift_dr(shift_dr),
			.clk_dr(clk_dr),
			.update_dr(update_dr)
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
