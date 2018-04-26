module tap_controller(
	input 					TMS,
    input 					TCK,
    input                   TRST,
	output					ICLK,
	output 	reg				mode,
	output 	reg				shift_dr,
	output 	reg				clk_dr,
	output 	reg				update_dr,
	output 	reg				shift_ir,
	output 	reg				clk_ir,
	output 	reg				update_ir,
	output	[3:0]			state_out,
	output	reg				sel_tdo
);
assign ICLK=TCK;
reg [3:0] state;
assign state_out=state;
localparam 	TEST_LOGIC_RESET		=4'h0,
			RUN_TEST_IDLE			=4'h1,
			SELECT_DR_SCAN			=4'h2,
			CAPTURE_DR				=4'h3,
			SHIFT_DR				=4'h4,
			EXIT1_DR				=4'h5,
			PAUSE_DR				=4'h6,
			EXIT2_DR				=4'h7,
			UPDATE_DR				=4'h8,
			SELECT_IR_SCAN			=4'h9,
			CAPTURE_IR				=4'hA,
			SHIFT_IR				=4'hB,
			EXIT1_IR				=4'hC,
			PAUSE_IR				=4'hD,
			EXIT2_IR				=4'hE,
			UPDATE_IR				=4'hF;
			
	always @(posedge TCK or negedge TRST)
	begin
        if(TRST==1'b0)
        begin
                state<=TEST_LOGIC_RESET;
                mode<=1'b0;
                update_dr<=1'b0;
                shift_dr<=1'b0;
                clk_dr<=1'b0;
                update_ir<=1'b0;
                shift_ir<=1'b0;
                clk_ir<=1'b0;
                sel_tdo<=1'b0;
        end 
        else
		case (state)
			TEST_LOGIC_RESET:
				begin
					mode<=1'b0;
					if(~TMS)
					begin	
						state<=RUN_TEST_IDLE;
						mode<=1'b1;
					end	
				end
			RUN_TEST_IDLE:
				if(TMS)
				begin
					state<=SELECT_DR_SCAN;
				end
			SELECT_DR_SCAN:
				if(TMS)
				begin
					state<=SELECT_IR_SCAN;
				end
				else
				begin
					sel_tdo<=1'b0;
					clk_dr<=1'b1;
					state<=CAPTURE_DR;
				end
			CAPTURE_DR:
				begin
					clk_dr<=1'b0;
					if(TMS)
					begin
						state<=EXIT1_DR;
					end
					else
					begin
						state<=SHIFT_DR;
						clk_dr<=1'b1;
						shift_dr<=1'b1;
					end
				end
			SHIFT_DR:
				begin
					clk_dr<=1'b1;
					shift_dr<=1'b1;
					if(TMS)
					begin
						shift_dr<=1'b0;
						clk_dr<=1'b0;
						state<=EXIT1_DR;
					end
				end
			EXIT1_DR:
				if(TMS)
				begin
					update_dr<=1'b1;
					state<=UPDATE_DR;
				end
				else
				begin
					state<=PAUSE_DR;
				end
			PAUSE_DR:
				if(TMS)
				begin
					state<=EXIT2_DR;
				end
			EXIT2_DR:
				if(TMS)
				begin
					update_dr<=1'b1;
					state<=UPDATE_DR;
				end
				else
				begin
					state<=SHIFT_DR;
				end
			UPDATE_DR:
				begin
					update_dr<=1'b0;
					if(TMS)
					begin
						state<=SELECT_DR_SCAN;
					end
					else
					begin
						state<=RUN_TEST_IDLE;
					end
				end
			SELECT_IR_SCAN:
				if(TMS)
				begin
					state<=TEST_LOGIC_RESET;
				end
				else
				begin
					sel_tdo<=1'b1;
					clk_ir<=1'b1;
					state<=CAPTURE_IR;
				end	
			CAPTURE_IR:
				begin
					clk_ir<=1'b0;
					if(TMS)
					begin
						state<=EXIT1_IR;
					end
					else
					begin
						state<=SHIFT_IR;
                        clk_dr<=1'b1;
						shift_ir<=1'b1;
					end
				end
			SHIFT_IR:
                begin
					clk_ir<=1'b1;
					shift_ir<=1'b1;
					if(TMS)
					begin
						shift_ir<=1'b0;
						clk_ir<=1'b0;
						state<=EXIT1_IR;
					end
				end
			EXIT1_IR:
				if(TMS)
				begin
					update_ir<=1'b1;
					state<=UPDATE_IR;
				end
				else
				begin
					state<=PAUSE_IR;
				end
			PAUSE_IR:
				if(TMS)
				begin
					state<=EXIT2_IR;
				end
			EXIT2_IR:
				if(TMS)
				begin
					update_ir<=1'b1;
					state<=UPDATE_IR;
				end
				else
				begin
					state<=SHIFT_IR;
				end
			UPDATE_IR:
			begin
				update_ir<=1'b0;
				if(TMS)
				begin
					state<=SELECT_DR_SCAN;
				end
				else
				begin
					state<=RUN_TEST_IDLE;
				end
			end
		endcase         
	end
initial begin
	state=TEST_LOGIC_RESET;
	mode=1'b0;
	update_dr=1'b0;
	shift_dr=1'b0;
	clk_dr=1'b0;
	update_ir=1'b0;
	shift_ir=1'b0;
	clk_ir=1'b0;
	sel_tdo=1'b0;
end
endmodule
