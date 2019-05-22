/*
*  File            :   dp_dtm.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.16
*  Language        :   SystemVerilog
*  Description     :   This is debug transport module
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

`include "../inc/dp_constants.svh"

module dp_dtm 
( 
    // jtag side
    input   logic   [0  : 0]    tdi,            // test data input
    input   logic   [0  : 0]    tms,            // test mode select
    input   logic   [0  : 0]    tck,            // test clock
    input   logic   [0  : 0]    trst,           // test reset
    output  logic   [0  : 0]    tdo,            // test data output
    // dmi
    output  logic   [6  : 0]    dmi_address,    // dmi address
    output  logic   [31 : 0]    dmi_wdata,      // dmi write data
    input   logic   [31 : 0]    dmi_rdata,      // dmi read data
    output  logic   [1  : 0]    dmi_op          // dmi operation
);

    localparam          IDCODE_V =  
                                    {
                                        4'b0001,                    // Version      [31 : 28]
                                        16'b0000_0000_0000_0111,    // PartNumber   [27 : 12]
                                        11'b000_0000_0111,          // ManufId      [11 :  1]
                                        1'b1                        // 1            [0  :  0]  
                                    };
    localparam          DTMCS   = 
                                    {
                                        14'b00_0000_0000_0000,      // NU           [31 : 18]
                                        1'b0,                       // dmihardreset [17 : 17]
                                        1'b0,                       // dmireset     [16 : 16]
                                        1'b0,                       // NU           [15 : 15]
                                        3'b001,                     // idle         [14 : 12]
                                        2'b00,                      // dmistat      [11 : 10]
                                        6'b00_0110,                 // abits        [9  :  4]
                                        4'b0001                     // version      [3  :  0]
                                    };
    localparam          DMI     = 
                                    {
                                        7'b000_0000,                // address      [40 : 34]
                                        32'h00_00_00_00,            // data         [33 :  2]
                                        2'b00                       // op           [1  :  0]
                                    };

    // clock and reset
    logic   [0  : 0]        iclk;           // internal clock
    logic   [0  : 0]        iresetn;        // internal reset
    // tap data registers
    logic   [0  : 0]        mode_tap;       // mode
    logic   [0  : 0]        shift_tap;      // shift data register
    logic   [0  : 0]        clk_tap;        // clock data register
    logic   [0  : 0]        update_tap;     // update data register
    // tdo selecting (ir or one of bsrs)
    logic   [0  : 0]        sel_tdo;        // select tdo
    logic   [3  : 0]        bsr_sel;        // bsr sel for tdo output
    // 
    logic   [0  : 0]        sdo_ir;         // serial data output of instruction register
    logic   [4  : 0]        pdo_ir;         // parallel data output of instruction register
    logic   [0  : 0]        sdo_dr;         // serial data output from mux 
    logic   [3  : 0][0 : 0] sdo_bsr;        // serial data output of bsrs
    // bsr registers
    logic   [0  : 0]        mode_bsr;       // mode
    logic   [3  : 0][0 : 0] shift_bsr;      // shift data register
    logic   [3  : 0][0 : 0] clk_bsr;        // clock data register
    logic   [3  : 0][0 : 0] update_bsr;     // update data register
    // instruction register
    logic   [0  : 0]        shift_ir;       // shift instruction register
    logic   [0  : 0]        clk_ir;         // clock instruction register
    logic   [0  : 0]        update_ir;      // update instruction register
    // dmi register
    logic   [40 : 0]        pdo_dmi;        // parallel data output dmi 
    logic   [40 : 0]        pdi_dmi;
    // dtmcs register

    assign mode_bsr = mode_tap;
    assign tdo  = sel_tdo ? sdo_ir : sdo_dr;

    assign  dmi_address = pdo_dmi[40 : 34],
            dmi_wdata   = pdo_dmi[33 :  2],
            dmi_op      = pdo_dmi[1  :  0];

    assign  pdi_dmi     = { 7'b000_0000 , dmi_rdata , 2'b00 };
    
    // creating one tap controller
    dp_tap_controller
    dp_tap_controller_0
    (
        // jtag side
        .tms            ( tms                           ),  // test mode select
        .tck            ( tck                           ),  // test clock
        .trst           ( trst                          ),  // test reset
        .iclk           ( iclk                          ),  // internal clock
        .iresetn        ( iresetn                       ),  // internal reset
        .sel_tdo        ( sel_tdo                       ),  // select tdo
        // data register side
        .mode           ( mode_tap                      ),  // mode
        .shift_dr       ( shift_tap                     ),  // shift data register
        .clk_dr         ( clk_tap                       ),  // clock data register
        .update_dr      ( update_tap                    ),  // update data register
        // instruction register side
        .shift_ir       ( shift_ir                      ),  // shift instruction register
        .clk_ir         ( clk_ir                        ),  // clock instruction register
        .update_ir      ( update_ir                     )   // update instruction register
    );
    // creating one data register multiplexor
    dp_mux_dr  
    dp_mux_dr_0
    ( 
        .sdi            ( sdo_bsr                       ),
        .shift_dr       ( shift_tap                     ),
        .clk_dr         ( clk_tap                       ),
        .update_dr      ( update_tap                    ),
        .sdo            ( sdo_dr                        ),
        .shift_dr_out   ( shift_bsr                     ),
        .clk_dr_out     ( clk_bsr                       ),
        .update_dr_out  ( update_bsr                    ),
        .bsr_sel        ( bsr_sel                       )
    );
    // creating one instruction decoder
    dp_ir_dec 
    dp_ir_dec_0 
    ( 
        .pdi            ( pdo_ir                        ),  // parallel data input
        .bsr_sel        ( bsr_sel                       )   // boundary scan register select
    );
    // creating one dtmcs bsr
    dp_bsr 
    #(
        .width          ( 32                            ),
        .UPD_r          ( DTMCS                         ),
        .CAP_r          ( DTMCS                         )
    ) 
    dp_bsr_dtmcs
    (
        // clock and reset
        .iclk           ( iclk                          ),  // internal clock
        .iresetn        ( iresetn                       ),  // internal reset
        // parallel data
        .pdi            ( DTMCS                         ),  // parallel data input
        .pdo            (                               ),  // parallel data output
        // serial data
        .sdi            ( tdi                           ),  // serial data input
        .sdo            ( sdo_bsr       [SEL_DTMCS]     ),  // serial data output
        // from tap controller
        .mode           ( mode_bsr                      ),  // mode
        .shift_dr       ( shift_bsr     [SEL_DTMCS]     ),  // shift data register
        .clk_dr         ( clk_bsr       [SEL_DTMCS]     ),  // clock data register
        .update_dr      ( update_bsr    [SEL_DTMCS]     )   // update data register
    );
    // creating one dmi bsr
    dp_bsr 
    #(
        .width          ( 41                            ),
        .UPD_r          ( DMI                           ),
        .CAP_r          ( DMI                           )
    ) 
    dp_bsr_dmi
    (
        // clock and reset
        .iclk           ( iclk                          ),  // internal clock
        .iresetn        ( iresetn                       ),  // internal reset
        // parallel data
        .pdi            ( pdi_dmi                       ),  // parallel data input
        .pdo            ( pdo_dmi                       ),  // parallel data output
        // serial data
        .sdi            ( tdi                           ),  // serial data input
        .sdo            ( sdo_bsr       [SEL_DMI]       ),  // serial data output
        // from tap controller
        .mode           ( mode_bsr                      ),  // mode
        .shift_dr       ( shift_bsr     [SEL_DMI]       ),  // shift data register
        .clk_dr         ( clk_bsr       [SEL_DMI]       ),  // clock data register
        .update_dr      ( update_bsr    [SEL_DMI]       )   // update data register
    );
    // creating one IDCODE bsr
    dp_bsr 
    #(
        .width          ( 32                            ),
        .UPD_r          ( IDCODE_V                      ),
        .CAP_r          ( IDCODE_V                      )
    ) 
    dp_bsr_idcode
    (
        // clock and reset
        .iclk           ( iclk                          ),  // internal clock
        .iresetn        ( iresetn                       ),  // internal reset
        // parallel data
        .pdi            ( IDCODE_V                      ),  // parallel data input
        .pdo            (                               ),  // parallel data output
        // serial data
        .sdi            ( tdi                           ),  // serial data input
        .sdo            ( sdo_bsr       [SEL_IDCODE]    ),  // serial data output
        // from tap controller
        .mode           ( mode_bsr                      ),  // mode
        .shift_dr       ( shift_bsr     [SEL_IDCODE]    ),  // shift data register
        .clk_dr         ( clk_bsr       [SEL_IDCODE]    ),  // clock data register
        .update_dr      ( update_bsr    [SEL_IDCODE]    )   // update data register
    );
    // creating one bypass register
    dp_br
    dp_br_0 
    ( 
        // clock and reset
        .iclk           ( iclk                          ),  // internal clock
        .iresetn        ( iresetn                       ),  // internal reset
        // serial data
        .sdi            ( tdi                           ),  // serial data input
        .sdo            ( sdo_bsr       [SEL_BYPASS]    ),  // serial data output
        // from tap controller
        .clock_dr       ( clk_bsr       [SEL_BYPASS]    )   // clock data register
    );
    // creating one instruction register
    dp_ir 
    #(
        .width          ( `INSTR_REG_LEN                ),
        .UPD_r          ( `INSTR_REG_RST_V              )
    ) 
    dp_ir_reg 
    (
        // clock and reset
        .iclk           ( iclk                          ),  // internal clock
        .iresetn        ( iresetn                       ),  // internal reset
        // parallel data
        .pdi            ( '0                            ),  // parallel data input
        .pdo            ( pdo_ir                        ),  // parallel data output
        // serial data
        .sdi            ( tdi                           ),  // serial data input
        .sdo            ( sdo_ir                        ),  // serial data output
        // from tap controller
        .shift_ir       ( shift_ir                      ),  // shift instruction register
        .clk_ir         ( clk_ir                        ),  // clock instruction register
        .update_ir      ( update_ir                     )   // update instruction register
    );

endmodule : dp_dtm
