module tap_controller
(
    input                   TMS,
    input                   TCK,
    input                   TRST,
    output                  ICLK,

    output  reg             mode,
    output  reg             shift_dr,
    output  reg             clk_dr,
    output  reg             update_dr,
    output  reg             shift_ir,
    output  reg             clk_ir,
    output  reg             update_ir,
    output  [3:0]           state_out,
    output  reg             sel_tdo
);

reg [3:0] state;

localparam  TEST_LOGIC_RESET_S      = 4'h0 ,
            RUN_TEST_IDLE_S         = 4'h1 ,
            SELECT_DR_SCAN_S        = 4'h2 ,
            CAPTURE_DR_S            = 4'h3 ,
            SHIFT_DR_S              = 4'h4 ,
            EXIT1_DR_S              = 4'h5 ,
            PAUSE_DR_S              = 4'h6 ,
            EXIT2_DR_S              = 4'h7 ,
            UPDATE_DR_S             = 4'h8 ,
            SELECT_IR_SCAN_S        = 4'h9 ,
            CAPTURE_IR_S            = 4'hA ,
            SHIFT_IR_S              = 4'hB ,
            EXIT1_IR_S              = 4'hC ,
            PAUSE_IR_S              = 4'hD ,
            EXIT2_IR_S              = 4'hE ,
            UPDATE_IR_S             = 4'hF ;
            
    assign ICLK      = TCK ;
    assign state_out = state ;

    always @(posedge TCK or negedge TRST)
        begin
            if( TRST == 1'b0 )
                begin
                    state       <= TEST_LOGIC_RESET_S    ;
                    mode        <= 1'b0                  ;
                    update_dr   <= 1'b0                  ;
                    shift_dr    <= 1'b0                  ;
                    clk_dr      <= 1'b0                  ;
                    update_ir   <= 1'b0                  ;
                    shift_ir    <= 1'b0                  ;
                    clk_ir      <= 1'b0                  ;
                    sel_tdo     <= 1'b0                  ;
                end 
            else
                case( state )
                    TEST_LOGIC_RESET_S:
                        begin
                            mode <= 1'b0 ;
                            if( ~TMS )
                                begin   
                                    state <= RUN_TEST_IDLE_S ;
                                    mode  <= 1'b1 ;
                                end 
                        end
                    RUN_TEST_IDLE_S:
                        if( TMS )
                            begin
                                state <= SELECT_DR_SCAN_S ;
                            end
                    SELECT_DR_SCAN_S:
                        if( TMS )
                            begin
                                state <= SELECT_IR_SCAN_S ;
                            end
                        else
                            begin
                                sel_tdo <=1'b0 ;
                                clk_dr  <=1'b1 ;
                                state   <=CAPTURE_DR_S ;
                            end
                    CAPTURE_DR_S:
                        begin
                            clk_dr <= 1'b0 ;
                            if( TMS )
                                begin
                                    state <= EXIT1_DR_S ;
                                end
                            else
                                begin
                                    state    <= SHIFT_DR_S ;
                                    clk_dr   <= 1'b1 ;
                                    shift_dr <= 1'b1 ;
                                end
                        end
                    SHIFT_DR_S:
                        begin
                            clk_dr   <= 1'b1 ;
                            shift_dr <= 1'b1 ;
                            if( TMS )
                                begin
                                    shift_dr <= 1'b0 ;
                                    clk_dr   <= 1'b0 ;
                                    state    <= EXIT1_DR_S ;
                                end
                        end
                    EXIT1_DR_S:
                        if( TMS )
                            begin
                                update_dr <= 1'b1 ;
                                state     <= UPDATE_DR_S ;
                            end
                        else
                            begin
                                state <= PAUSE_DR_S ;
                            end
                    PAUSE_DR_S:
                        if( TMS )
                            begin
                                state <= EXIT2_DR_S ;
                            end
                    EXIT2_DR_S:
                        if( TMS )
                            begin
                                update_dr <= 1'b1 ;
                                state     <= UPDATE_DR_S ;
                            end
                        else
                            begin
                                state <= SHIFT_DR_S ;
                            end
                    UPDATE_DR_S:
                        begin
                            update_dr <= 1'b0 ;
                            if( TMS )
                                begin
                                    state <= SELECT_DR_SCAN_S ;
                                end
                            else
                                begin
                                    state <= RUN_TEST_IDLE_S ;
                                end
                        end
                    SELECT_IR_SCAN_S:
                        if( TMS )
                            begin
                                state <= TEST_LOGIC_RESET_S ;
                            end
                        else
                            begin
                                sel_tdo <= 1'b1 ;
                                clk_ir  <= 1'b1 ;
                                state   <= CAPTURE_IR_S ;
                            end 
                    CAPTURE_IR_S:
                        begin
                            clk_ir <= 1'b0 ;
                            if( TMS )
                                begin
                                    state <= EXIT1_IR_S ;
                                end
                            else
                                begin
                                    state    <= SHIFT_IR_S ;
                                    clk_ir   <= 1'b1 ; 
                                    shift_ir <= 1'b1 ;
                                end
                        end
                    SHIFT_IR_S:
                        begin
                            clk_ir      <= 1'b1 ;
                            shift_ir    <= 1'b1 ;
                            if(TMS)
                                begin
                                    shift_ir <= 1'b0 ;
                                    clk_ir   <= 1'b0 ;
                                    state    <= EXIT1_IR_S ;
                                end
                        end
                    EXIT1_IR_S:
                        if( TMS )
                            begin
                                update_ir <= 1'b1 ;
                                state     <= UPDATE_IR_S ;
                            end
                        else
                            begin
                                state <= PAUSE_IR_S ;
                            end
                    PAUSE_IR_S:
                        if( TMS )
                            begin
                                state <= EXIT2_IR_S ;
                            end
                    EXIT2_IR_S:
                        if( TMS )
                            begin
                                update_ir <= 1'b1 ;
                                state     <= UPDATE_IR_S ;
                            end
                        else
                            begin
                                state <= SHIFT_IR_S ;
                            end
                    UPDATE_IR_S:
                    begin
                        update_ir <= 1'b0 ;
                        if( TMS )
                            begin
                                state <= SELECT_DR_SCAN_S ;
                            end
                        else
                            begin
                                state <= RUN_TEST_IDLE_S ;
                            end
                    end
                endcase         
        end
    initial 
        begin
            state       = TEST_LOGIC_RESET_S ;
            mode        = 1'b0 ;
            update_dr   = 1'b0 ;
            shift_dr    = 1'b0 ;
            clk_dr      = 1'b0 ;
            update_ir   = 1'b0 ;
            shift_ir    = 1'b0 ;
            clk_ir      = 1'b0 ;
            sel_tdo     = 1'b0 ;
        end

endmodule
