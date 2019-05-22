/*
*  File            :   dp_ir_dec.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.01
*  Language        :   SystemVerilog
*  Description     :   This is debug instruction decoder
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

`include "../inc/dp_constants.svh"

module dp_ir_dec
( 
    input   logic   [4 : 0]     pdi,  // parallel data input
    output  logic   [3 : 0]     bsr_sel     // boundary scan register select
);

    always_comb
    begin
        bsr_sel = SEL_IDCODE;
        casex( pdi )
            IDCODE          :   bsr_sel = SEL_IDCODE;
            DTMCS           :   bsr_sel = SEL_DTMCS;
            DMI             :   bsr_sel = SEL_DMI;
            BYPASS_0        :   bsr_sel = SEL_BYPASS;
            BYPASS_1        :   bsr_sel = SEL_BYPASS;
            RSV_BYPASS_0    :   bsr_sel = SEL_BYPASS;
            RSV_BYPASS_1    :   bsr_sel = SEL_BYPASS;
            RSV_BYPASS_2    :   bsr_sel = SEL_BYPASS;
            RSV_BYPASS_3    :   bsr_sel = SEL_BYPASS;
            RSV_BYPASS_4    :   bsr_sel = SEL_BYPASS;
            RSV_BYPASS_5    :   bsr_sel = SEL_BYPASS;
            ANY             :   bsr_sel = SEL_IDCODE;
        endcase
    end

endmodule : dp_ir_dec
