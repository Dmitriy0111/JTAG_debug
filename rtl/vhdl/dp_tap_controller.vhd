--
-- File            :   dp_tap_controller.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This is debug test access port
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library dp;
use dp.dp_help_pkg.all;

entity dp_tap_controller is
    port
    (
        -- jtag side
        tms         : in    std_logic;  -- test mode select
        tck         : in    std_logic;  -- test clock
        trst        : in    std_logic;  -- test reset
        iclk        : out   std_logic;  -- internal clock
        iresetn     : out   std_logic;  -- internal reset
        sel_tdo     : out   std_logic;  -- select tdo
        -- data register side
        mode        : out   std_logic;  -- mode
        shift_dr    : out   std_logic;  -- shift data register
        clk_dr      : out   std_logic;  -- clock data register
        update_dr   : out   std_logic;  -- update data register
        -- instruction register side
        shift_ir    : out   std_logic;  -- shift instruction register
        clk_ir      : out   std_logic;  -- clock instruction register
        update_ir   : out   std_logic   -- update instruction register
    );
end dp_tap_controller;

architecture rtl of dp_tap_controller is
    type   fsm_state is (
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
                        );
    signal state        : fsm_state;    -- current state of fsm
    signal next_state   : fsm_state;    -- next state for fsm

    signal update_dr_i  : std_logic;
    signal shift_dr_i   : std_logic;
    signal clk_dr_i     : std_logic;
    signal update_ir_i  : std_logic;
    signal shift_ir_i   : std_logic;
    signal clk_ir_i     : std_logic;
    signal sel_tdo_i    : std_logic;

    function sel_state( bool_v : boolean ; s_1 : fsm_state ; s_0 : fsm_state ) return fsm_state is
        variable ret_s : fsm_state;
    begin
        if( bool_v ) then 
            ret_s := s_1;
        else
            ret_s := s_0;
        end if;
        return ret_s;
    end function;
begin

    iclk      <= tck;
    iresetn   <= trst;

    update_dr <= update_dr_i;
    shift_dr  <= shift_dr_i;
    clk_dr    <= clk_dr_i;
    update_ir <= update_ir_i;
    shift_ir  <= shift_ir_i;
    clk_ir    <= clk_ir_i;
    sel_tdo   <= sel_tdo_i;

    -- setting state
    set_new_state_proc : process( tck, trst )
    begin
        if( not trst ) then
            state <= TEST_LOGIC_RESET_S;
        elsif( rising_edge( tck ) ) then
            state <= next_state;
        end if;
    end process;

    -- finding next state
    sel_next_proc : process( all )
    begin
        next_state <= state;
        case( state ) is
            when TEST_LOGIC_RESET_S     => next_state <= sel_state( tms = '1' , state              , RUN_TEST_IDLE_S );
            when RUN_TEST_IDLE_S        => next_state <= sel_state( tms = '1' , SELECT_DR_SCAN_S   , state           );
            when SELECT_DR_SCAN_S       => next_state <= sel_state( tms = '1' , SELECT_IR_SCAN_S   , CAPTURE_DR_S    );
            when CAPTURE_DR_S           => next_state <= sel_state( tms = '1' , EXIT1_DR_S         , SHIFT_DR_S      );
            when SHIFT_DR_S             => next_state <= sel_state( tms = '1' , EXIT1_DR_S         , state           );
            when EXIT1_DR_S             => next_state <= sel_state( tms = '1' , UPDATE_DR_S        , PAUSE_DR_S      );
            when PAUSE_DR_S             => next_state <= sel_state( tms = '1' , EXIT2_DR_S         , state           );
            when EXIT2_DR_S             => next_state <= sel_state( tms = '1' , UPDATE_DR_S        , SHIFT_DR_S      );
            when UPDATE_DR_S            => next_state <= sel_state( tms = '1' , SELECT_DR_SCAN_S   , RUN_TEST_IDLE_S );
            when SELECT_IR_SCAN_S       => next_state <= sel_state( tms = '1' , TEST_LOGIC_RESET_S , CAPTURE_IR_S    );
            when CAPTURE_IR_S           => next_state <= sel_state( tms = '1' , EXIT1_IR_S         , SHIFT_IR_S      );
            when SHIFT_IR_S             => next_state <= sel_state( tms = '1' , EXIT1_IR_S         , state           );
            when EXIT1_IR_S             => next_state <= sel_state( tms = '1' , UPDATE_IR_S        , PAUSE_IR_S      );
            when PAUSE_IR_S             => next_state <= sel_state( tms = '1' , EXIT2_IR_S         , state           );
            when EXIT2_IR_S             => next_state <= sel_state( tms = '1' , UPDATE_IR_S        , SHIFT_IR_S      );
            when UPDATE_IR_S            => next_state <= sel_state( tms = '1' , SELECT_DR_SCAN_S   , RUN_TEST_IDLE_S );
            when others                 =>
        end case;   
    end process;
    -- setting mode output
    set_mode_proc : process( tck, trst )
    begin
        if( not trst ) then
            mode <= '0';
        elsif( rising_edge( tck ) ) then
            if( state = TEST_LOGIC_RESET_S ) then
                mode <= sel_sl( tms = '1', '0', '1');
            end if;
        end if;
    end process;
    -- setting update data register
    set_upd_dr_proc : process( tck, trst )
    begin
        if( not trst ) then
            update_dr_i <= '0';
        elsif( rising_edge( tck ) ) then
            case( state ) is
                when EXIT1_DR_S     => update_dr_i <= sel_sl( tms = '1', '1', update_dr_i);
                when EXIT2_DR_S     => update_dr_i <= sel_sl( tms = '1', '1', update_dr_i);
                when UPDATE_DR_S    => update_dr_i <= '0';
                when others         => 
            end case;
        end if;
    end process;
    -- setting shift data register
    set_shift_dr_proc : process( tck, trst )
    begin
        if( not trst ) then
            shift_dr_i <= '0';
        elsif( rising_edge( tck ) ) then
            case( state ) is
                when CAPTURE_DR_S   => shift_dr_i <= sel_sl( tms = '1', shift_dr_i, '1');
                when SHIFT_DR_S     => shift_dr_i <= sel_sl( tms = '1', '0', '1');
                when others         => 
            end case;
        end if;
    end process;
    -- setting clock data register
    set_clk_dr_proc : process( tck, trst )
    begin
        if( not trst ) then
            clk_dr_i <= '0';
        elsif( rising_edge( tck ) ) then
            case( state ) is
                when SELECT_DR_SCAN_S   => clk_dr_i <= sel_sl( tms = '1', clk_dr_i, '1');
                when CAPTURE_DR_S       => clk_dr_i <= sel_sl( tms = '1', '0', '1');
                when SHIFT_DR_S         => clk_dr_i <= sel_sl( tms = '1', '0', '1');
                when others             => 
            end case;
        end if;
    end process;
    -- setting update instruction register
    set_upd_ir_proc : process( tck, trst )
    begin
        if( not trst ) then
            update_ir_i <= '0';
        elsif( rising_edge( tck ) ) then
            case( state ) is
                when SELECT_DR_SCAN_S   => update_ir_i <= sel_sl( tms = '1', '1', update_ir_i);
                when CAPTURE_DR_S       => update_ir_i <= sel_sl( tms = '1', '1', update_ir_i);
                when SHIFT_DR_S         => update_ir_i <= '0';
                when others             => 
            end case;
        end if;
    end process;
    -- setting shift instruction register
    set_shift_ir_proc : process( tck, trst )
    begin
        if( not trst ) then
            shift_ir_i <= '0';
        elsif( rising_edge( tck ) ) then
            case( state ) is
                when CAPTURE_IR_S   => shift_ir_i <= sel_sl( tms = '1', shift_ir_i, '1');
                when SHIFT_IR_S     => shift_ir_i <= sel_sl( tms = '1', '0', '1');
                when others         => 
            end case;
        end if;
    end process;
    -- setting clock instruction register
    set_clk_ir_proc : process( tck, trst )
    begin
        if( not trst ) then
            clk_ir_i <= '0';
        elsif( rising_edge( tck ) ) then
            case( state ) is
                when SELECT_IR_SCAN_S   => clk_ir_i <= sel_sl( tms = '1', clk_ir_i, '0');
                when CAPTURE_IR_S       => clk_ir_i <= sel_sl( tms = '1', '0', '1');
                when SHIFT_IR_S         => clk_ir_i <= sel_sl( tms = '1', '0', '1');
                when others             => 
            end case;
        end if;
    end process;
    -- setting selection tdo
    set_tdo_proc : process( tck, trst )
    begin
        if( not trst ) then
            sel_tdo_i <= '0';
        elsif( rising_edge( tck ) ) then
            case( state ) is
                when SELECT_DR_SCAN_S   => sel_tdo_i <= sel_sl( tms = '1', sel_tdo_i, '0');
                when SELECT_IR_SCAN_S   => sel_tdo_i <= sel_sl( tms = '1', sel_tdo_i, '1');
                when others             => 
            end case;
        end if;
    end process;

end rtl; -- dp_tap_controller
