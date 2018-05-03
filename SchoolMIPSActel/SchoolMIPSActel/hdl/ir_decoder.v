`include "etap_constants.vh"

module ir_decoder #(
    parameter width = 8
)( 
    input 	   [width-1:0] p_data_in,
    output reg [3:0]       sel
);

    always @(*)
        begin
            casex( p_data_in )
                `ETAP_IDCODE:        sel = `SEL_ETAP_IDCODE ;
                `ETAP_IMPCODE:       sel = `SEL_ETAP_IMPCODE ;
                `ETAP_ADDRESS:       sel = `SEL_ETAP_ADDRESS ;
                `ETAP_DATA:          sel = `SEL_ETAP_DATA ;
                `ETAP_CONTROL:       sel = `SEL_ETAP_CONTROL ;
                `ETAP_EJTAGBOOT:     sel = `SEL_ETAP_EJTAGBOOT ;
                `BYPASS:             sel = `SEL_BYPASS ;
                `SAMPLE_PRELOAD:     sel = `SEL_SAMPLE_PRELOAD ;
                `ANY:                sel = `SEL_ANY ;
            endcase
        end

endmodule
