module one_irc(
	input 	p_data_in,
	output 	p_data_out,
	input 	s_data_in,
	output 	s_data_out,
	input	ICLK,
	input 	shift_ir,
	input 	clk_ir,
	input 	update_ir
);
	wire shift_ir_mux;
	assign shift_ir_mux=shift_ir?s_data_in:p_data_in;	//	MUX witch enable DR
	reg CAP;
	reg UPD;
	assign s_data_out=CAP;
	assign p_data_out=UPD;
	
	always @(posedge ICLK)
	begin
		if (clk_ir==1'b1)
			CAP<=shift_ir_mux;
		else
			CAP<=CAP;
	end
	
	always @(posedge ICLK)
	begin
		if (update_ir==1'b1)
			UPD<=CAP;
	end
    
    initial
    begin
        CAP=1'b1;
        UPD=1'b1;
    end
endmodule
	