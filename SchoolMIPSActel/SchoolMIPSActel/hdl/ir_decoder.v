module ir_decoder #(parameter width=8)
( 
    input 	   [width-1:0] p_data_in,
    output reg [1:0]       sel
);
localparam  BYPASS={width{1'b1}},
            SAMPLE_PRELOAD={{(width-1){1'b0}},1'b1},
            IDCODE={width{1'b0}},
            ANY={width{1'b?}};
always @(*)
begin
    casex (p_data_in)
        BYPASS:         sel=2'b00;
        IDCODE:         sel=2'b01;
        SAMPLE_PRELOAD: sel=2'b10;
        ANY:            sel=2'b00;
    endcase
end

endmodule

