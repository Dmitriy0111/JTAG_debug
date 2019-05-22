/*
*  File            :   dp_dm.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.05.22
*  Language        :   SystemVerilog
*  Description     :   This is debug module
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

`include "../inc/dp_dmr_types.svh"

module dp_dm
( 
    // dmi
    input   logic   [6  : 0]    dmi_address,    // dmi address
    input   logic   [31 : 0]    dmi_wdata,      // dmi write data
    output  logic   [31 : 0]    dmi_rdata,      // dmi read data
    input   logic   [1  : 0]    dmi_op          // dmi operation

);

    dmcontrol       dmcontrol_in;
    dmstatus        dmstatus_in;
    hartinfo        hartinfo_in;
    data0           data0_in;
    data1           data1_in;
    abstractcs      abstractcs_in;
    command         command_in;
    abstractauto    abstractauto_in;
    progbuf0        progbuf0_in;
    haltsum0        haltsum0_in;

    dmcontrol       dmcontrol_out;
    dmstatus        dmstatus_out;
    hartinfo        hartinfo_out;
    data0           data0_out;
    data1           data1_out;
    abstractcs      abstractcs_out;
    command         command_out;
    abstractauto    abstractauto_out;
    progbuf0        progbuf0_out;
    haltsum0        haltsum0_out;

    always_comb
    begin
        dmi_rdata = '0;
        casex( dmi_address )
            DATA0_A         :   dmi_rdata = data0_out;
            DATA1_A         :   dmi_rdata = data1_out;
            DMCONTROL_A     :   dmi_rdata = dmcontrol_out;
            DMSTATUS_A      :   dmi_rdata = dmstatus_out;
            HARTINFO_A      :   dmi_rdata = hartinfo_out;
            ABSTRACTCS_A    :   dmi_rdata = abstractcs_out;
            COMMAND_A       :   dmi_rdata = command_out;
            ABSTRACTAUTO_A  :   dmi_rdata = abstractauto_out;
            PROGBUF0_A      :   dmi_rdata = progbuf0_out;
            HALTSUM0_A      :   dmi_rdata = haltsum0_out;
            default     :   ;
        endcase
    end

endmodule : dp_dm
