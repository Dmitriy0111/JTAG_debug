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
    output  logic   [0 : 0]     iclk,       // i clock
    // 
    output  logic   [0 : 0]     mode,       // mode
    output  logic   [0 : 0]     shift_dr,   // shift data register
    output  logic   [0 : 0]     clk_dr,     // clock data register
    output  logic   [0 : 0]     update_dr,  // update data register
    output  logic   [0 : 0]     shift_ir,   // shift instruction register
    output  logic   [0 : 0]     clk_ir,     // clock instruction register
    output  logic   [0 : 0]     update_ir,  // update instruction register
    output  logic   [3 : 0]     state_out,  // current state out
    output  logic   [0 : 0]     sel_tdo     // select tdo
);

    enum
    logic   [3 : 0]     { 
                            TEST_LOGIC_RESET_s, 
                            RUN_TEST_IDLE_s,
                            SELECT_DR_SCAN_s, 
                            CAPTURE_DR_s,
                            SHIFT_DR_s,
                            EXIT1_DR_s,
                            PAUSE_DR_s,
                            EXIT2_DR_s,
                            UPDATE_DR_s,
                            SELECT_IR_SCAN_s,
                            CAPTURE_IR_s,
                            SHIFT_IR_s,
                            EXIT1_IR_s,
                            PAUSE_IR_s,
                            EXIT2_IR_s,
                            UPDATE_IR_s
                        } state, next_state;
            
    assign iclk      = tck;
    assign state_out = state;
    // setting state
    always_ff @(posedge tck, negedge trst) 
        if( !trst )
            state <= TEST_LOGIC_RESET_s;
        else
            state <= next_state;
    // finding next state
    always_comb
    begin
        next_state = state;
        case( state )
            TEST_LOGIC_RESET_s:
                if( !tms )
                    next_state = RUN_TEST_IDLE_s;
            RUN_TEST_IDLE_s:
                if( tms )
                    next_state = SELECT_DR_SCAN_s;
            SELECT_DR_SCAN_s:
                if( tms )
                    next_state = SELECT_IR_SCAN_s;
                else
                    next_state =CAPTURE_DR_s;
            CAPTURE_DR_s:
                if( tms )
                    next_state = EXIT1_DR_s;
                else
                    next_state = SHIFT_DR_s;
            SHIFT_DR_s:
                if( tms )
                    next_state = EXIT1_DR_s;
            EXIT1_DR_s:
                if( tms )
                    next_state = UPDATE_DR_s;
                else
                    next_state = PAUSE_DR_s;
            PAUSE_DR_s:
                if( tms )
                    next_state = EXIT2_DR_s;
            EXIT2_DR_s:
                if( tms )
                    next_state = UPDATE_DR_s;
                else
                    next_state = SHIFT_DR_s;
            UPDATE_DR_s:
                if( tms )
                    next_state = SELECT_DR_SCAN_s;
                else
                    next_state = RUN_TEST_IDLE_s;
            SELECT_IR_SCAN_s:
                if( tms )
                    next_state = TEST_LOGIC_RESET_s;
                else
                    next_state = CAPTURE_IR_s;
            CAPTURE_IR_s:
                if( tms )
                    next_state = EXIT1_IR_s;
                else
                    next_state = SHIFT_IR_s;
            SHIFT_IR_s:
                if( tms )
                    next_state = EXIT1_IR_s;
            EXIT1_IR_s:
                if( tms )
                    next_state = UPDATE_IR_s;
                else
                    next_state = PAUSE_IR_s;
            PAUSE_IR_s:
                if( tms )
                    next_state = EXIT2_IR_s;
            EXIT2_IR_s:
                if( tms )
                    next_state = UPDATE_IR_s;
                else
                    next_state = SHIFT_IR_s;
            UPDATE_IR_s:
                if( tms )
                    next_state = SELECT_DR_SCAN_s;
                else
                    next_state = RUN_TEST_IDLE_s;
        endcase         
    end
    // setting mode output
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            mode <= 1'b0;
        else
        begin
            if( state == TEST_LOGIC_RESET_s )
            begin
                mode <= 1'b0;
                if( !tms )
                    mode  <= 1'b1;
            end
        end
    // setting update data register
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            update_dr <= 1'b0;
        else
        begin
            case( state )
                EXIT1_DR_s:
                    if( tms )
                        update_dr <= 1'b1;
                EXIT2_DR_s:
                    if( tms )
                        update_dr <= 1'b1;
                UPDATE_DR_s:
                    update_dr <= 1'b0;
            endcase
        end
    // setting shift data register
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            shift_dr <= 1'b0;
        else
        begin
            case( state )
                CAPTURE_DR_s:
                begin
                    if( !tms )
                        shift_dr <= 1'b1;
                end
                SHIFT_DR_s:
                begin
                    shift_dr <= 1'b1;
                    if( tms )
                        shift_dr <= 1'b0;
                end
            endcase
        end
    // setting clock data register
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            clk_dr <= 1'b0;
        else
        begin
            case( state )
                SELECT_DR_SCAN_s:
                    if( !tms )
                        clk_dr  <=1'b1;
                CAPTURE_DR_s:
                begin
                    clk_dr <= 1'b0;
                    if( !tms )
                        clk_dr   <= 1'b1;
                end
                SHIFT_DR_s:
                begin
                    clk_dr   <= 1'b1;
                    if( tms )
                        clk_dr   <= 1'b0;
                end
            endcase
        end
    // setting update instruction register
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            update_ir   <= 1'b0;
        else
        begin
            case( state )
                EXIT1_IR_s:
                    if( tms )
                        update_ir <= 1'b1;
                EXIT2_IR_s:
                    if( tms )
                        update_ir <= 1'b1;
                UPDATE_IR_s:
                    update_ir <= 1'b0;
            endcase
        end
    // setting shift instruction register
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            shift_ir <= 1'b0;
        else
        begin
            case( state )
                CAPTURE_IR_s:
                begin
                    if( !tms )
                        shift_ir <= 1'b1;
                end
                SHIFT_IR_s:
                begin
                    shift_ir    <= 1'b1;
                    if( tms )
                        shift_ir <= 1'b0;
                end
            endcase
        end
    // setting clock instruction register
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            clk_ir <= 1'b0;
        else
        begin
            case( state )
                SELECT_IR_SCAN_s:
                    if( !tms )
                        clk_ir  <= 1'b1;
                CAPTURE_IR_s:
                begin
                    clk_ir <= 1'b0;
                    if( !tms )
                        clk_ir   <= 1'b1; 
                end
                SHIFT_IR_s:
                begin
                    clk_ir      <= 1'b1;
                    if( tms )
                        clk_ir   <= 1'b0;
                end
            endcase
        end
    // setting selection tdo
    always_ff @(posedge tck, negedge trst)
        if( !trst )
            sel_tdo     <= 1'b0;
        else
        begin
            case( state )
                SELECT_DR_SCAN_s:
                    if( !tms )
                        sel_tdo <=1'b0;
                SELECT_IR_SCAN_s:
                    if( !tms )
                        sel_tdo <= 1'b1;
            endcase
        end

endmodule : dp_tap_controller
