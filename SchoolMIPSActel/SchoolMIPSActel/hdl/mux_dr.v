module mux_dr
( 
	input       [7:0]		s_data_in,
	input 	    			shift_dr,
	input 	    			clk_dr,
	input 	    			update_dr,
    output 	reg				s_data_out,
	output 	reg	[7:0]		shift_dr_out,
	output 	reg	[7:0]		clk_dr_out,
	output 	reg	[7:0]		update_dr_out,
    input       [3:0]       sel
);

localparam  SEL_ETAP_IDCODE     =4'b0000,
            SEL_ETAP_IMPCODE    =4'b0001,
            SEL_ETAP_ADDRESS    =4'b0010,
            SEL_ETAP_DATA       =4'b0011,
            SEL_ETAP_CONTROL    =4'b0100,
            SEL_ETAP_EJTAGBOOT  =4'b0101,
            SEL_SAMPLE_PRELOAD  =4'b0110,
            SEL_BYPASS          =4'b0111,
            SEL_ANY             =4'b1000;

always @(*)
begin
    s_data_out      =   1'b0;
    shift_dr_out    =   8'h00;
    clk_dr_out      =   8'h00;
    update_dr_out   =   8'h00;
    casex (sel)
        SEL_ETAP_IDCODE:     
            begin 
                s_data_out=s_data_in[0];
                update_dr_out[0]=update_dr; 
                clk_dr_out[0]=clk_dr; 
                shift_dr_out[0]=shift_dr;
            end
        SEL_ETAP_IMPCODE:
            begin 
                s_data_out=s_data_in[1];
                update_dr_out[1]=update_dr; 
                clk_dr_out[1]=clk_dr; 
                shift_dr_out[1]=shift_dr;
            end
        SEL_ETAP_ADDRESS:
            begin 
                s_data_out=s_data_in[2];
                update_dr_out[2]=update_dr; 
                clk_dr_out[2]=clk_dr; 
                shift_dr_out[2]=shift_dr;
            end
        SEL_ETAP_DATA:       
            begin 
                s_data_out=s_data_in[3];
                update_dr_out[3]=update_dr; 
                clk_dr_out[3]=clk_dr; 
                shift_dr_out[3]=shift_dr;
            end
        SEL_ETAP_CONTROL:    
            begin 
                s_data_out=s_data_in[4];
                update_dr_out[4]=update_dr; 
                clk_dr_out[4]=clk_dr; 
                shift_dr_out[4]=shift_dr;
            end
        SEL_ETAP_EJTAGBOOT:  
            begin 
                s_data_out=s_data_in[5];
                update_dr_out[5]=update_dr; 
                clk_dr_out[5]=clk_dr; 
                shift_dr_out[5]=shift_dr;
            end
        SEL_SAMPLE_PRELOAD:  
            begin 
                s_data_out=s_data_in[6];
                update_dr_out[6]=update_dr; 
                clk_dr_out[6]=clk_dr; 
                shift_dr_out[6]=shift_dr;
            end
        SEL_BYPASS:          
            begin 
                s_data_out=s_data_in[7];
                update_dr_out[7]=update_dr; 
                clk_dr_out[7]=clk_dr; 
                shift_dr_out[7]=shift_dr;
            end
        SEL_ANY:             
            begin 
                s_data_out=s_data_in[0];
                update_dr_out[0]=update_dr; 
                clk_dr_out[0]=clk_dr; 
                shift_dr_out[0]=shift_dr;
            end
    endcase
end

endmodule
