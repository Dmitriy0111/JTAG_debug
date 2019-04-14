/*
*  File            :   dp_tap_controller.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.01
*  Language        :   SystemVerilog
*  Description     :   This is debug test access port testbench
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

module dp_tap_controller_tb();

    // jtag side
    bit     [0 : 0]     tms;        // test mode select
    bit     [0 : 0]     tck;        // test clock
    bit     [0 : 0]     trst;       // test reset
    logic   [0 : 0]     iclk;       // i clock
    // 
    logic   [0 : 0]     mode;       // mode
    logic   [0 : 0]     shift_dr;   // shift data register
    logic   [0 : 0]     clk_dr;     // clock data register
    logic   [0 : 0]     update_dr;  // update data register
    logic   [0 : 0]     shift_ir;   // shift instruction register
    logic   [0 : 0]     clk_ir;     // clock instruction register
    logic   [0 : 0]     update_ir;  // update instruction register
    logic   [3 : 0]     state_out;  // current state out
    logic   [0 : 0]     sel_tdo;    // select tdo

    dp_tap_controller
    dp_tap_controller_0
    (
        // jtag side
        .tms        ( tms       ),  // test mode select
        .tck        ( tck       ),  // test clock
        .trst       ( trst      ),  // test reset
        .iclk       ( iclk      ),  // i clock
        // 
        .mode       ( mode      ),  // mode
        .shift_dr   ( shift_dr  ),  // shift data register
        .clk_dr     ( clk_dr    ),  // clock data register
        .update_dr  ( update_dr ),  // update data register
        .shift_ir   ( shift_ir  ),  // shift instruction register
        .clk_ir     ( clk_ir    ),  // clock instruction register
        .update_ir  ( update_ir ),  // update instruction register
        .state_out  ( state_out ),  // current state out
        .sel_tdo    ( sel_tdo   )   // select tdo
    );

endmodule : dp_tap_controller_tb
