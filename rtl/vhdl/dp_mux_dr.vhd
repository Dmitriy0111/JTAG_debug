--
-- File            :   dp_mux_dr.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This is debug mux for data register
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library dp;
use dp.dp_constants.all;
use dp.dp_help_pkg.all;

entity dp_mux_dr is
    port
    (
        sdi             : in    logic_array(3 downto 0);        -- serial data input
        shift_dr        : in    std_logic;                      -- shift data register
        clk_dr          : in    std_logic;                      -- clock data register
        update_dr       : in    std_logic;                      -- update data register

        sdo             : out   std_logic;                      -- serial data output
        shift_dr_out    : out   logic_array(3 downto 0);        -- shift data register output
        clk_dr_out      : out   logic_array(3 downto 0);        -- clock data register output
        update_dr_out   : out   logic_array(3 downto 0);        -- update data register output

        bsr_sel         : in    std_logic_vector(3 downto 0)    -- selecting data output
    );
end dp_mux_dr;

architecture rtl of dp_mux_dr is
begin
            
    mux_proc : process( all )
    begin
        sdo <= '0';
        update_dr_out <= 4X"0";
        shift_dr_out <= 4X"0";
        clk_dr_out <= 4X"0";
        case ?( bsr_sel ) is
            when SEL_IDCODE     => sdo  <= sdi( SEL_IDCODE_I ); update_dr_out( SEL_IDCODE_I ) <= update_dr; clk_dr_out( SEL_IDCODE_I ) <= clk_dr; shift_dr_out( SEL_IDCODE_I ) <= shift_dr;
            when SEL_DTMCS      => sdo  <= sdi( SEL_DTMCS_I  ); update_dr_out( SEL_DTMCS_I  ) <= update_dr; clk_dr_out( SEL_DTMCS_I  ) <= clk_dr; shift_dr_out( SEL_DTMCS_I  ) <= shift_dr;
            when SEL_DMI        => sdo  <= sdi( SEL_DMI_I    ); update_dr_out( SEL_DMI_I    ) <= update_dr; clk_dr_out( SEL_DMI_I    ) <= clk_dr; shift_dr_out( SEL_DMI_I    ) <= shift_dr;
            when SEL_BYPASS     => sdo  <= sdi( SEL_BYPASS_I ); update_dr_out( SEL_BYPASS_I ) <= update_dr; clk_dr_out( SEL_BYPASS_I ) <= clk_dr; shift_dr_out( SEL_BYPASS_I ) <= shift_dr;
            when others         => sdo  <= sdi( SEL_IDCODE_I ); update_dr_out( SEL_IDCODE_I ) <= update_dr; clk_dr_out( SEL_IDCODE_I ) <= clk_dr; shift_dr_out( SEL_IDCODE_I ) <= shift_dr;
        end case ?;
    end process;
    
end rtl; -- dp_mux_dr
