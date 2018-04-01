module mux_dr
( 
	input       [2:0]		s_data_in,
	input 	    			shift_dr,
	input 	    			clk_dr,
	input 	    			update_dr,
    output 	reg				s_data_out,
	output 		[2:0]		shift_dr_out,
	output 		[2:0]		clk_dr_out,
	output 		[2:0]		update_dr_out,
    input       [1:0]       sel
);

localparam  BYPASS=2'b00,
            SAMPLE_PRELOAD=2'b10,
            IDCODE=2'b01,
            ANY=2'b??;

assign shift_dr_out[0]=(sel==BYPASS)?shift_dr:1'b0;
assign shift_dr_out[1]=(sel==IDCODE)?shift_dr:1'b0;
assign shift_dr_out[2]=(sel==SAMPLE_PRELOAD)?shift_dr:1'b0;

assign clk_dr_out[0]=(sel==BYPASS)?clk_dr:1'b0;
assign clk_dr_out[1]=(sel==IDCODE)?clk_dr:1'b0;
assign clk_dr_out[2]=(sel==SAMPLE_PRELOAD)?clk_dr:1'b0;

assign update_dr_out[0]=(sel==BYPASS)?update_dr:1'b0;
assign update_dr_out[1]=(sel==IDCODE)?update_dr:1'b0;
assign update_dr_out[2]=(sel==SAMPLE_PRELOAD)?update_dr:1'b0;

always @(*)
begin
    casex (sel)
        BYPASS:         s_data_out=s_data_in[0];
        IDCODE:         s_data_out=s_data_in[1];
        SAMPLE_PRELOAD: s_data_out=s_data_in[2];
        ANY:            s_data_out=s_data_in[0];
    endcase
end

endmodule
