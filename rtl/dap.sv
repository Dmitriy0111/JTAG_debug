`include "etap_constants.vh"

module dap 
#(
    parameter                       BSR_C = 1
)( 
    input   logic   [0       : 0]   tdi,
    input   logic   [0       : 0]   tms,
    input   logic   [0       : 0]   tck,
    input   logic   [0       : 0]   trst,
    output  logic   [0       : 0]   tdo,

    output  logic   [0       : 0]   iclk,
    input   logic   [BSR_C-1 : 0]   s_data_out_dr,
    output  logic   [BSR_C-1 : 0]   shift_dr,
    output  logic   [BSR_C-1 : 0]   clock_dr,
    output  logic   [BSR_C-1 : 0]   update_dr,
    output  logic   [BSR_C-1 : 0]   mode_dr,
    output  logic   [3       : 0]   state_out
);
    logic   [0 : 0]     shift_tap;
    logic   [0 : 0]     clk_tap;
    logic   [0 : 0]     update_tap;
    logic   [0 : 0]     shift_ir;
    logic   [0 : 0]     clk_ir;
    logic   [0 : 0]     update_ir;
    logic   [0 : 0]     sel_tdo;
    logic   [0 : 0]     s_data_out_ir;
    logic   [4 : 0]     p_data_out_ir;
    logic   [0 : 0]     s_data_out;
    logic   [3 : 0]     sel_dr;
    logic   [7 : 0]     s_data_out_reg;
    logic   [7 : 0]     shift_reg;
    logic   [7 : 0]     clk_reg;
    logic   [7 : 0]     update_reg;

    assign s_data_out_reg[`SEL_SAMPLE_PRELOAD]  = s_data_out_dr ;
    assign shift_dr                             = shift_reg[`SEL_SAMPLE_PRELOAD] ;
    assign clock_dr                             = clk_reg[`SEL_SAMPLE_PRELOAD] ;
    assign update_dr                            = update_reg[`SEL_SAMPLE_PRELOAD] ;
    assign TDO                                  = sel_tdo ? s_data_out_ir : s_data_out ;
    
    tap_controller
    tap_controller_0
    (
        .tms            ( tms                                   ),
        .tck            ( tck                                   ),
        .trst           ( trst                                  ),

        .iclk           ( iclk                                  ),
        .mode           ( mode_dr                               ),
        .shift_dr       ( shift_tap                             ),
        .clk_dr         ( clk_tap                               ),
        .update_dr      ( update_tap                            ),
        .shift_ir       ( shift_ir                              ),
        .clk_ir         ( clk_ir                                ),
        .update_ir      ( update_ir                             ),
        .state_out      ( state_out                             ),
        .sel_tdo        ( sel_tdo                               )
    );
  
    mux_dr  
    mux_dr_0
    ( 
        .s_data_in      ( s_data_out_reg                        ),
        .shift_dr       ( shift_tap                             ),
        .clk_dr         ( clk_tap                               ),
        .update_dr      ( update_tap                            ),
        .s_data_out     ( s_data_out                            ),
        .shift_dr_out   ( shift_reg                             ),
        .clk_dr_out     ( clk_reg                               ),
        .update_dr_out  ( update_reg                            ),
        .sel            ( sel_dr                                )
    );

    ir_decoder 
    #(
        .width          ( 5                                     )
    ) 
    ir_decoder_0 
    ( 
        .p_data_in      ( p_data_out_ir                         ),
        .sel            ( sel_dr                                )
    );

    bsr 
    #(
        .width          ( 32                                    )
    ) 
    reg_etap_idcode
    (
        .p_data_in      ( {{4'h1},{17'h1},{10'h1},{1'h0}}       ),
        //.p_data_out   ( regData_out                           ),
        .s_data_in      ( tdi                                   ),
        .s_data_out     ( s_data_out_reg[`SEL_ETAP_IDCODE]      ),

        .mode           ( mode                                  ),
        .shift_dr       ( shift_reg[`SEL_ETAP_IDCODE]           ),
        .clk_dr         ( clk_reg[`SEL_ETAP_IDCODE]             ),
        .update_dr      ( update_reg[`SEL_ETAP_IDCODE]          ),

        .iclk           ( iclk                                  )
    );
    bsr 
    #(
        .width          ( 32                                                                    )
    ) 
    reg_etap_impcode 
    (
        .p_data_in      ( {{3'h1},{4'h0},{1'h0},{3'h0},{4'h0},{1'h0},{1'h0},{1'h1},{14'h0}}     ),
        //.p_data_out   ( regData_out                                                           ),
        .s_data_in      ( tdi                                                                   ),
        .s_data_out     ( s_data_out_reg[`SEL_ETAP_IMPCODE]                                     ),

        .mode           ( mode                                                                  ),
        .shift_dr       ( shift_reg[`SEL_ETAP_IMPCODE]                                          ),
        .clk_dr         ( clk_reg[`SEL_ETAP_IMPCODE]                                            ),
        .update_dr      ( update_reg[`SEL_ETAP_IMPCODE]                                         ),

        .ICLK           ( iclk                                                                  )
    );
    bsr
    #(
        .width          ( 32                                    )
    ) 
    reg_etap_data 
    (
        .p_data_in      ( 32'h55aa55aa                          ),
        //.p_data_out   ( regData_out                           ),
        .s_data_in      ( tdi                                   ),
        .s_data_out     ( s_data_out_reg[`SEL_ETAP_DATA]        ),

        .mode           ( mode                                  ),
        .shift_dr       ( shift_reg[`SEL_ETAP_DATA]             ),
        .clk_dr         ( clk_reg[`SEL_ETAP_DATA]               ),
        .update_dr      ( update_reg[`SEL_ETAP_DATA]            ),

        .iclk           ( iclk                                  )
    );
    bsr 
    #(
        .width          ( 32                                    )
    ) 
    reg_etap_addr 
    (
        .p_data_in      ( 32'h0FF200200                         ),
        //.p_data_out   ( regData_out                           ),
        .s_data_in      ( tdi                                   ),
        .s_data_out     ( s_data_out_reg[`SEL_ETAP_ADDRESS]     ),

        .mode           ( mode                                  ),
        .shift_dr       ( shift_reg[`SEL_ETAP_ADDRESS]          ),
        .clk_dr         ( clk_reg[`SEL_ETAP_ADDRESS]            ),
        .update_dr      ( update_reg[`SEL_ETAP_ADDRESS]         ),

        .iclk           ( iclk                                  )
    );
    bsr 
    #(
        .width          ( 32                                    )
    ) 
    reg_etap_control 
    (
        .p_data_in      ( 32'h12345678                          ),
        //.p_data_out   ( regData_out                           ),
        .s_data_in      ( tdi                                   ),
        .s_data_out     ( s_data_out_reg[`SEL_ETAP_CONTROL]     ),

        .mode           ( mode                                  ),
        .shift_dr       ( shift_reg[`SEL_ETAP_CONTROL]          ),
        .clk_dr         ( clk_reg[`SEL_ETAP_CONTROL]            ),
        .update_dr      ( update_reg[`SEL_ETAP_CONTROL]         ),
    
        .iclk           ( iclk                                  )
    );
    bsr 
    #(
        .width          ( 32                                    )
    ) 
    reg_etap_ejtagboot 
    (
        .p_data_in      ( 32'haa55aa55                          ),
        //.p_data_out   ( regData_out                           ),
        .s_data_in      ( tdi                                   ),
        .s_data_out     ( s_data_out_reg[`SEL_ETAP_EJTAGBOOT]   ),

        .mode           ( mode                                  ),
        .shift_dr       ( shift_reg[`SEL_ETAP_EJTAGBOOT]        ),
        .clk_dr         ( clk_reg[`SEL_ETAP_EJTAGBOOT]          ),
        .update_dr      ( update_reg[`SEL_ETAP_EJTAGBOOT]       ),

        .iclk           ( iclk                                  )
    );
    bypass_register
    bypass_register_0 
    ( 
        .s_data_in      ( tdi                                   ),
        .clock_dr       ( clk_reg[`SEL_BYPASS]                  ),
        .iclk           ( iclk                                  ),
        .s_data_out     ( s_data_out_reg[`SEL_BYPASS]           )
    );

    ir 
    #(
        .width          ( 5                                     )
    ) 
    ir_reg 
    (
        .p_data_in      ( 5'h1                                  ),
        .p_data_out     ( p_data_out_ir                         ),
        .s_data_in      ( tdi                                   ),
        .s_data_out     ( s_data_out_ir                         ),

        .shift_ir       ( shift_ir                              ),
        .clk_ir         ( clk_ir                                ),
        .update_ir      ( update_ir                             ),

        .iclk           ( iclk                                  ),
        .reset          ( trst                                  )
    );

endmodule : dap
