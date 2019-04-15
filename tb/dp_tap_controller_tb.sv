/*
*  File            :   dp_tap_controller.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.01
*  Language        :   SystemVerilog
*  Description     :   This is debug test access port testbench
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

module dp_tap_controller_tb();

    timeprecision   1ns;
    timeunit        1ns;
    
    localparam      T = 10,
                    rst_delay = 7;

    // jtag side
    bit     [0 : 0]     tms;        // test mode select
    bit     [0 : 0]     tck;        // test clock
    bit     [0 : 0]     trst;       // test reset
    logic   [0 : 0]     iclk;       // internal clock
    logic   [0 : 0]     iresetn;    // internal reset
    logic   [0 : 0]     sel_tdo;    // select tdo
    // data register side
    logic   [0 : 0]     mode;       // mode
    logic   [0 : 0]     shift_dr;   // shift data register
    logic   [0 : 0]     clk_dr;     // clock data register
    logic   [0 : 0]     update_dr;  // update data register
    // instruction register side
    logic   [0 : 0]     shift_ir;   // shift instruction register
    logic   [0 : 0]     clk_ir;     // clock instruction register
    logic   [0 : 0]     update_ir;  // update instruction register

    dp_tap_controller
    dp_tap_controller_0
    (
        // jtag side
        .tms            ( tms           ),  // test mode select
        .tck            ( tck           ),  // test clock
        .trst           ( trst          ),  // test reset
        .iclk           ( iclk          ),  // internal clock
        .iresetn        ( iresetn       ),  // internal reset
        .sel_tdo        ( sel_tdo       ),  // select tdo
        // data register side
        .mode           ( mode_dr       ),  // mode
        .shift_dr       ( shift_tap     ),  // shift data register
        .clk_dr         ( clk_tap       ),  // clock data register
        .update_dr      ( update_tap    ),  // update data register
        // instruction register side
        .shift_ir       ( shift_ir      ),  // shift instruction register
        .clk_ir         ( clk_ir        ),  // clock instruction register
        .update_ir      ( update_ir     )   // update instruction register
    );

    initial
    begin
        repeat(rst_delay) @(posedge tck);
        trst ='1;
    end

    initial
    begin
        forever #(T/2) tck = !tck;
    end

    initial
    begin
        tms = '1;
    end

    initial
    begin
        @(posedge trst);
        @(posedge tck);
        tms = '0;
        @(posedge tck);
        tms = '1;
        @(posedge tck);
        tms = '1;
    end

endmodule : dp_tap_controller_tb
