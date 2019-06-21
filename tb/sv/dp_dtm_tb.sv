/*
*  File            :   dp_dtm_tb.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.01
*  Language        :   SystemVerilog
*  Description     :   This is testbench for debug transport module
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

`include "../../inc/sv/dp_constants.svh"

module dp_dtm_tb();

    timeprecision   1ns;
    timeunit        1ns;
    
    localparam      T = 10,
                    rst_delay = 7;

    bit     [0 : 0]     clk;
    // jtag side
    bit     [0  : 0]    tdi;            // test data input
    bit     [0  : 0]    tms;            // test mode select
    bit     [0  : 0]    tck;            // test clock
    bit     [0  : 0]    trst;           // test reset
    logic   [0  : 0]    tdo;            // test data output
    // dmi
    logic   [6  : 0]    dmi_address;    // dmi address
    logic   [31 : 0]    dmi_rdata;      // dmi read data
    logic   [31 : 0]    dmi_wdata;      // dmi write data
    logic   [1  : 0]    dmi_op;         // dmi operation

    assign dmi_rdata = dmi_wdata;

    // creating one debug access port
    dp_dtm 
    dp_dtm_0 
    ( 
        // jtag side
        .tdi            ( tdi           ),  // test data input
        .tms            ( tms           ),  // test mode select
        .tck            ( tck           ),  // test clock
        .trst           ( trst          ),  // test reset
        .tdo            ( tdo           ),  // test data output
        // dmi
        .dmi_address    ( dmi_address   ),  // dmi address
        .dmi_rdata      ( dmi_rdata     ),  // dmi read data
        .dmi_wdata      ( dmi_wdata     ),  // dmi write data
        .dmi_op         ( dmi_op        )   // dmi operation
    );

    task make_tck();        // make test clock
        @(posedge clk)
        tck = '1;
        @(negedge clk)
        tck = '0;
    endtask : make_tck

    task tlr2rti();         // test logic reset 2 run test idle
        tms = '0;
        make_tck();
    endtask : tlr2rti
    
    task rti2sds();         // run test idle 2 select dr scan
        tms = '1;
        make_tck();
    endtask : rti2sds

    task sds2cd();          // select dr scan 2 capture dr
        tms = '0;
        make_tck();
    endtask : sds2cd

    task sis2ci();          // select ir scan 2 capture ir
        tms = '0;
        make_tck();
    endtask : sis2ci

    task sds2sis();         // select dr scan 2 select ir scan
        tms = '1;
        make_tck();
    endtask : sds2sis

    task cd2sd();           // capture dr 2 shift dr
        tms = '0;
        make_tck();
    endtask : cd2sd

    task ci2si();           // capture ir 2 shift ir
        tms = '0;
        make_tck();
    endtask : ci2si

    task sd2e1d();          // shift dr 2 exit 1 dr
        tms = '1;
        make_tck();
    endtask : sd2e1d

    task si2e1i();          // shift ir 2 exit 1 ir
        tms = '1;
        make_tck();
    endtask : si2e1i

    task e1d2ud();          // exit 1 dr 2 update dr     
        tms = '1;
        make_tck();
    endtask : e1d2ud

    task e1i2ui();          // exit 1 ir 2 update ir     
        tms = '1;
        make_tck();
    endtask : e1i2ui

    task ud2rti();          // update dr 2 run test idle
        tms = '0;
        make_tck();
    endtask : ud2rti

    task ui2rti();          // update ir 2 run test idle
        tms = '0;
        make_tck();
    endtask : ui2rti

    task make_tck_more(integer n);
        repeat(n) make_tck();
    endtask : make_tck_more

    task write_data(logic [127 : 0] value, integer n);
        repeat(n) 
        begin
            make_tck();
            tdi = value[0];
            value = value >> 1;
        end
    endtask : write_data

    task read_data(integer n);
        logic [127 : 0] ret_v;
        ret_v = 0;
        repeat(n) 
        begin
            ret_v[n-1] = tdo;
            ret_v = ret_v >> 1;
            make_tck();
        end
        $display("read data = %h", ret_v);
    endtask : read_data

    task sel_ir(logic [127 : 0] ir_n);      // from run test idle
        rti2sds();
        sds2sis();
        sis2ci();
        //ci2si();
        write_data(ir_n,5);
        si2e1i();
        e1i2ui();
        ui2rti();
    endtask : sel_ir

    task write_dr(logic [127 : 0] dr_n, integer count);      // from run test idle
        rti2sds();
        sds2cd();
        //ci2si();
        write_data(dr_n,count);
        sd2e1d();
        e1d2ud();
        ud2rti();
    endtask : write_dr

    task read_dr(integer dr_n);
        
        tdi = '0;
        rti2sds();
        sds2cd();
        //cd2sd();
        read_data(dr_n);
        sd2e1d();
        e1d2ud();
        ud2rti();
    endtask : read_dr

    initial
    begin
        repeat(rst_delay) @(posedge clk);
        trst ='1;
    end

    initial
    begin
        forever #(T/2) clk = !clk;
    end

    initial
    begin
        tms = '1;
    end

    initial
    begin
        @(posedge trst);
        @(posedge clk);
        tlr2rti();
        sel_ir( BYPASS_0 );
        read_dr(32);
        sel_ir( IDCODE   );
        read_dr(32);
        sel_ir( DTMCS    );
        read_dr(32);
        sel_ir( DMI      );
        write_dr(41'hAB_E1_23_45_67_89,41);
        read_dr(41);
        //repeat(2) 
        //begin
        //    rti2sds();
        //    sds2cd();
        //    cd2sd();
        //    make_tck_more(31);      // register width - 1
        //    sd2e1d();
        //    e1d2ud();
        //    ud2rti();
        //end
        repeat(10) @(posedge clk);
        $stop;
    end

endmodule : dp_dtm_tb
