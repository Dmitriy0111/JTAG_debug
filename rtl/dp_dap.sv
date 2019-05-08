/*
*  File            :   dp_dap.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.16
*  Language        :   SystemVerilog
*  Description     :   This is debug access port
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

`include "../inc/dp_constants.svh"

module dp_dap 
( 
    // jtag side
    input   logic   [0  : 0]    tdi,    // test data input
    input   logic   [0  : 0]    tms,    // test mode select
    input   logic   [0  : 0]    tck,    // test clock
    input   logic   [0  : 0]    trst,   // test reset
    output  logic   [0  : 0]    tdo     // test data output
);

    localparam          IDCODE_V =  {
                                        4'b0001,                    // Version      [28 : 31]
                                        16'b0000_0000_0000_0111,    // PartNumber   [12 : 27]
                                        11'b000_0000_0111,          // ManufId      [1  : 11]
                                        1'b1                        // 1            [0  :  0]  
                                    };
    localparam          DTMCS = 32'h01234567;
    localparam          DMI   = 32'h89abcdef;

    // clock and reset
    logic   [0 : 0]         iclk;           // internal clock
    logic   [0 : 0]         iresetn;        // internal reset
    // tap data registers
    logic   [0 : 0]         mode_tap;       // mode
    logic   [0 : 0]         shift_tap;      // shift data register
    logic   [0 : 0]         clk_tap;        // clock data register
    logic   [0 : 0]         update_tap;     // update data register
    // tdo selecting (ir or one of bsrs)
    logic   [0 : 0]         sel_tdo;        // select tdo
    logic   [3 : 0]         bsr_sel;        // bsr sel for tdo output
    // 
    logic   [0 : 0]         sdo_ir;         // serial data output of instruction register
    logic   [4 : 0]         pdo_ir;         // parallel data output of instruction register
    logic   [0 : 0]         sdo_dr;         // serial data output from mux 
    logic   [3 : 0][0 : 0]  sdo_bsr;        // serial data output of bsrs
    // bsr registers
    logic   [0 : 0]         mode_bsr;       // mode
    logic   [3 : 0][0 : 0]  shift_bsr;      // shift data register
    logic   [3 : 0][0 : 0]  clk_bsr;        // clock data register
    logic   [3 : 0][0 : 0]  update_bsr;     // update data register
    // instruction register
    logic   [0 : 0]         shift_ir;       // shift instruction register
    logic   [0 : 0]         clk_ir;         // clock instruction register
    logic   [0 : 0]         update_ir;      // update instruction register
    // dmi register
    logic   [33 : 0]        pdo_dmi;        // parallel data output dmi 
    logic   [31 : 0]        dmi_data;       // dmi data
    logic   [1  : 0]        dmi_op;         // dmi opcode
    // dtmcs register

    assign { dmi_data , dmi_op } = pdo_dmi;
    assign mode_bsr = mode_tap;
    assign tdo  = sel_tdo ? sdo_ir : sdo_dr;
    
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
        .width          ( 32                            )
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
        .sdo            ( sdo_bsr       [`SEL_DTMCS]    ),  // serial data output
        // from tap controller
        .mode           ( mode_bsr                      ),  // mode
        .shift_dr       ( shift_bsr     [`SEL_DTMCS]    ),  // shift data register
        .clk_dr         ( clk_bsr       [`SEL_DTMCS]    ),  // clock data register
        .update_dr      ( update_bsr    [`SEL_DTMCS]    )   // update data register
    );
    // creating one dmi bsr
    dp_bsr 
    #(
        .width          ( 32                            )
    ) 
    dp_bsr_dmi
    (
        // clock and reset
        .iclk           ( iclk                          ),  // internal clock
        .iresetn        ( iresetn                       ),  // internal reset
        // parallel data
        .pdi            ( DMI                           ),  // parallel data input
        .pdo            ( pdo_dmi                       ),  // parallel data output
        // serial data
        .sdi            ( tdi                           ),  // serial data input
        .sdo            ( sdo_bsr       [`SEL_DMI]      ),  // serial data output
        // from tap controller
        .mode           ( mode_bsr                      ),  // mode
        .shift_dr       ( shift_bsr     [`SEL_DMI]      ),  // shift data register
        .clk_dr         ( clk_bsr       [`SEL_DMI]      ),  // clock data register
        .update_dr      ( update_bsr    [`SEL_DMI]      )   // update data register
    );
    // creating one IDCODE bsr
    dp_bsr 
    #(
        .width          ( 32                            )
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
        .sdo            ( sdo_bsr       [`SEL_IDCODE]   ),  // serial data output
        // from tap controller
        .mode           ( mode_bsr                      ),  // mode
        .shift_dr       ( shift_bsr     [`SEL_IDCODE]   ),  // shift data register
        .clk_dr         ( clk_bsr       [`SEL_IDCODE]   ),  // clock data register
        .update_dr      ( update_bsr    [`SEL_IDCODE]   )   // update data register
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
        .sdo            ( sdo_bsr       [`SEL_BYPASS]   ),  // serial data output
        // from tap controller
        .clock_dr       ( clk_bsr       [`SEL_BYPASS]   )   // clock data register
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

endmodule : dp_dap
