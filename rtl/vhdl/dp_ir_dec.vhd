--
-- File            :   dp_ir_dec.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This is debug instruction decoder
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library dp;
use dp.dp_constants.all;

entity dp_ir_dec is
    port
    (
        pdi         : in    std_logic_vector(4 downto 0);   -- parallel data input
        bsr_sel     : out   std_logic_vector(3 downto 0)    -- boundary scan register select
    );
end dp_ir_dec;

architecture rtl of dp_ir_dec is
begin
    
    mux_proc : process( all )
    begin
        bsr_sel <= SEL_IDCODE;
        case ?( pdi ) is
            when IDCODE         => bsr_sel <= SEL_IDCODE;
            when DTMCS          => bsr_sel <= SEL_DTMCS;
            when DMI            => bsr_sel <= SEL_DMI;
            when BYPASS_0       => bsr_sel <= SEL_BYPASS;
            when BYPASS_1       => bsr_sel <= SEL_BYPASS;
            when RSV_BYPASS_0   => bsr_sel <= SEL_BYPASS;
            when RSV_BYPASS_1   => bsr_sel <= SEL_BYPASS;
            when RSV_BYPASS_2   => bsr_sel <= SEL_BYPASS;
            when RSV_BYPASS_3   => bsr_sel <= SEL_BYPASS;
            when RSV_BYPASS_4   => bsr_sel <= SEL_BYPASS;
            when RSV_BYPASS_5   => bsr_sel <= SEL_BYPASS;
            when others         => bsr_sel <= SEL_IDCODE;
        end case ?;
    end process;
    
end rtl; -- dp_ir_dec
