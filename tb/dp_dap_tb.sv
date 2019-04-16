/*
*  File            :   dp_dap_tb.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.01
*  Language        :   SystemVerilog
*  Description     :   This is testbench for debug access port unit
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

module dp_dap_tb();

    timeprecision   1ns;
    timeunit        1ns;
    
    localparam      T = 10,
                    rst_delay = 7;

    bit     [0 : 0]     clk;
    // jtag side
    bit     [0  : 0]    tdi;    // test data input
    bit     [0  : 0]    tms;    // test mode select
    bit     [0  : 0]    tck;    // test clock
    bit     [0  : 0]    trst;   // test reset
    logic   [0  : 0]    tdo;    // test data output
    // creating one debug access port
    dp_dap 
    dp_dap_0 
    ( 
        // jtag side
        .tdi    ( tdi       ),  // test data input
        .tms    ( tms       ),  // test mode select
        .tck    ( tck       ),  // test clock
        .trst   ( trst      ),  // test reset
        .tdo    ( tdo       )   // test data output
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

    task cd2sd();           // capture dr 2 shift dr
        tms = '0;
        make_tck();
    endtask : cd2sd

    task sd2e1d();          // shift dr 2 exit 1 dr
        tms = '1;
        make_tck();
    endtask : sd2e1d

    task e1d2ud();          // exit 1 dr 2 update dr     
        tms = '1;
        make_tck();
    endtask : e1d2ud

    task ud2rti();          // update dr 2 run test idle
        tms = '0;
        make_tck();
    endtask : ud2rti

    task make_tck_more(integer n);
        repeat(n) make_tck();
    endtask : make_tck_more

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
        repeat(2)
        begin
            rti2sds();
            sds2cd();
            cd2sd();
            make_tck_more(31);      // register width - 1
            sd2e1d();
            e1d2ud();
            ud2rti();
        end
        repeat(10) @(posedge clk);
        $stop;
    end

endmodule : dp_dap_tb
