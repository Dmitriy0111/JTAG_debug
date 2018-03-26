module BSR #(parameter width=32)
(
	input 	[width-1:0] p_data_in,
	output 	[width-1:0]	p_data_out,
	input 					s_data_in,
	output 					s_data_out,
	input 					mode,
	input 					shift_dr,
	input 					clk_dr,
	input 					update_dr
);
wire	[width:0] internal_connect;
assign s_data_out=internal_connect[width];
assign internal_connect[0]=s_data_in;
genvar 				number_of_bsc;

generate
	for(number_of_bsc=0; number_of_bsc<width; number_of_bsc=number_of_bsc+1)
	begin:MUX
		one_bsc
		one_bsc_ (
		.p_data_in(p_data_in[number_of_bsc]),
		.p_data_out(p_data_out[number_of_bsc]),
		.s_data_in(internal_connect[number_of_bsc]),
		.s_data_out(internal_connect[number_of_bsc+1]),
		.mode(mode),
		.shift_dr(shift_dr),
		.clk_dr(clk_dr),
		.update_dr(update_dr)
		);
	end
endgenerate


endmodule
