module ir_decoder #(parameter width=8)
( 
    input 	   [width-1:0] p_data_in,
    output reg [3:0]       sel
);
localparam  ETAP_IDCODE=5'd1,
            ETAP_IMPCODE=5'd3,
            ETAP_ADDRESS=5'd8,
            ETAP_DATA=5'd9,
            ETAP_CONTROL=5'd10,
            ETAP_EJTAGBOOT=5'd12,
            SAMPLE_PRELOAD=5'd0,
            BYPASS=5'd2,
            ANY={width{1'b?}};

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
    casex (p_data_in)
        ETAP_IDCODE:        sel=SEL_ETAP_IDCODE;
        ETAP_IMPCODE:       sel=SEL_ETAP_IMPCODE;
        ETAP_ADDRESS:       sel=SEL_ETAP_ADDRESS;
        ETAP_DATA:          sel=SEL_ETAP_DATA;
        ETAP_CONTROL:       sel=SEL_ETAP_CONTROL;
        ETAP_EJTAGBOOT:     sel=SEL_ETAP_EJTAGBOOT;
        BYPASS:             sel=SEL_BYPASS;
        SAMPLE_PRELOAD:     sel=SEL_SAMPLE_PRELOAD;
        ANY:                sel=SEL_ANY;
    endcase
end

endmodule

