module one_bsc
(
	input 	p_data_in,
	output 	p_data_out,
	input 	s_data_in,
	output 	s_data_out,

	input	ICLK,

	input 	mode,
	input 	shift_dr,
	input 	clk_dr,
	input 	update_dr
);
	wire shift_dr_mux;
	reg CAP;
	reg UPD;
	
	assign shift_dr_mux	= shift_dr ? s_data_in : p_data_in ;
	assign s_data_out	= CAP ;
	assign p_data_out	= mode ? UPD :p_data_in ;
	
	always @( posedge ICLK )
		begin
			if( clk_dr == 1'b1 )
				CAP <= shift_dr_mux ;
			else
				CAP <= CAP ;
				
			if( update_dr == 1'b1 )
				UPD <= CAP ;
		end
	
endmodule
	