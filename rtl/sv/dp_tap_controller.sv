/*
*  File            :   dp_tap_controller.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.04.01
*  Language        :   SystemVerilog
*  Description     :   This is debug test access port
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

module dp_tap_controller
(
    // jtag side
    input   logic   [0 : 0]     tms,        // test mode select
    input   logic   [0 : 0]     tck,        // test clock
    input   logic   [0 : 0]     trst,       // test reset
    output  logic   [0 : 0]     iclk,       // internal clock
    output  logic   [0 : 0]     iresetn,    // internal reset
    output  logic   [0 : 0]     sel_tdo,    // select tdo
    // data register side
    output  logic   [0 : 0]     mode,       // mode
    output  logic   [0 : 0]     shift_dr,   // shift data register
    output  logic   [0 : 0]     clk_dr,     // clock data register
    output  logic   [0 : 0]     update_dr,  // update data register
    // instruction register side
    output  logic   [0 : 0]     shift_ir,   // shift instruction register
    output  logic   [0 : 0]     clk_ir,     // clock instruction register
    output  logic   [0 : 0]     update_ir   // update instruction register
);

    enum
    logic   [3 : 0]     { 
                            TEST_LOGIC_RESET_S, 
                            RUN_TEST_IDLE_S,
                            SELECT_DR_SCAN_S, 
                            CAPTURE_DR_S,
                            SHIFT_DR_S,
                            EXIT1_DR_S,
                            PAUSE_DR_S,
                            EXIT2_DR_S,
                            UPDATE_DR_S,
                            SELECT_IR_SCAN_S,
                            CAPTURE_IR_S,
                            SHIFT_IR_S,
                            EXIT1_IR_S,
                            PAUSE_IR_S,
                            EXIT2_IR_S,
                            UPDATE_IR_S
                        } state, next_state;
            
    assign iclk      = tck;
    assign iresetn   = trst;

    // setting state
    always_ff @(posedge tck, negedge trst) 
        if( !trst )
            state <= TEST_LOGIC_RESET_S;
        else
            state <= next_state;
    // finding next state
    always_comb
    begin
        next_state = state;
        case( state )
            TEST_LOGIC_RESET_S  :   next_state = tms ? state              : RUN_TEST_IDLE_S;
            RUN_TEST_IDLE_S     :   next_state = tms ? SELECT_DR_SCAN_S   : state;
            SELECT_DR_SCAN_S    :   next_state = tms ? SELECT_IR_SCAN_S   : CAPTURE_DR_S;
            CAPTURE_DR_S        :   next_state = tms ? EXIT1_DR_S         : SHIFT_DR_S;
            SHIFT_DR_S          :   next_state = tms ? EXIT1_DR_S         : state;
            EXIT1_DR_S          :   next_state = tms ? UPDATE_DR_S        : PAUSE_DR_S;
            PAUSE_DR_S          :   next_state = tms ? EXIT2_DR_S         : state;
            EXIT2_DR_S          :   next_state = tms ? UPDATE_DR_S        : SHIFT_DR_S;
            UPDATE_DR_S         :   next_state = tms ? SELECT_DR_SCAN_S   : RUN_TEST_IDLE_S;
            SELECT_IR_SCAN_S    :   next_state = tms ? TEST_LOGIC_RESET_S : CAPTURE_IR_S;
            CAPTURE_IR_S        :   next_state = tms ? EXIT1_IR_S         : SHIFT_IR_S;
            SHIFT_IR_S          :   next_state = tms ? EXIT1_IR_S         : state;
            EXIT1_IR_S          :   next_state = tms ? UPDATE_IR_S        : PAUSE_IR_S;
            PAUSE_IR_S          :   next_state = tms ? EXIT2_IR_S         : state;
            EXIT2_IR_S          :   next_state = tms ? UPDATE_IR_S        : SHIFT_IR_S;
            UPDATE_IR_S         :   next_state = tms ? SELECT_DR_SCAN_S   : RUN_TEST_IDLE_S;
            default             : ;
        endcase         
    end
    // setting mode output
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            mode <= '0;
        else if( state == TEST_LOGIC_RESET_S )
            mode <= tms ? '0 : '1;
    // setting update data register
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            update_dr <= '0;
        else
        begin
            case( state )
                EXIT1_DR_S  :   update_dr <= tms ? '1 : update_dr;
                EXIT2_DR_S  :   update_dr <= tms ? '1 : update_dr;
                UPDATE_DR_S :   update_dr <= '0;
                default     : ;
            endcase
        end
    // setting shift data register
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            shift_dr <= '0;
        else
        begin
            case( state )
                CAPTURE_DR_S    :   shift_dr <= tms ? shift_dr : '1;
                SHIFT_DR_S      :   shift_dr <= tms ? '0 : '1;
                default         : ;
            endcase
        end
    // setting clock data register
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            clk_dr <= '0;
        else
        begin
            case( state )
                SELECT_DR_SCAN_S    :   clk_dr <= tms ? clk_dr : '1;
                CAPTURE_DR_S        :   clk_dr <= tms ? '0 : '1;
                SHIFT_DR_S          :   clk_dr <= tms ? '0 : '1;
                default             : ;
            endcase
        end
    // setting update instruction register
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            update_ir   <= '0;
        else
        begin
            case( state )
                EXIT1_IR_S  :   update_ir <= tms ? '1 : update_ir;
                EXIT2_IR_S  :   update_ir <= tms ? '1 : update_ir;
                UPDATE_IR_S :   update_ir <= '0;
                default     : ;
            endcase
        end
    // setting shift instruction register
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            shift_ir <= '0;
        else
        begin
            case( state )
                CAPTURE_IR_S    :   shift_ir <= tms ? shift_ir : '1;
                SHIFT_IR_S      :   shift_ir <= tms ? '0 : '1;
                default         : ;
            endcase
        end
    // setting clock instruction register
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            clk_ir <= '0;
        else
        begin
            case( state )
                SELECT_IR_SCAN_S    :   clk_ir <= tms ? clk_ir : '0;
                CAPTURE_IR_S        :   clk_ir <= tms ? '0 : '1;
                SHIFT_IR_S          :   clk_ir <= tms ? '0 : '1;
                default             : ;
            endcase
        end
    // setting selection tdo
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            sel_tdo <= '0;
        else
        begin
            case( state )
                SELECT_DR_SCAN_S    :   sel_tdo <= tms ? sel_tdo : '0;
                SELECT_IR_SCAN_S    :   sel_tdo <= tms ? sel_tdo : '1;
                default             : ;
            endcase
        end

endmodule : dp_tap_controller
