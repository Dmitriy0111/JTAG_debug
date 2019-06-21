--
-- File            :   dp_br.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This is debug bypass register
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dp_br is
    port
    (
        -- clock and reset
        iclk        : in    std_logic;  -- internal clock
        iresetn     : in    std_logic;  -- internal reset
        -- serial data
        sdi         : in    std_logic;  -- serial data input
        sdo         : out   std_logic;  -- serial data output
        -- from tap controller
        clock_dr    : in    std_logic   -- clock data register
    );
end dp_br;

architecture rtl of dp_br is
begin

    sdo_proc : process( iclk, iresetn )
    begin
        if( not iresetn ) then
            sdo <= '0';
        elsif( rising_edge(iclk) ) then
            if( clock_dr ) then
                sdo <= sdi;
            end if;
        end if;
    end process;

end rtl; -- dp_br
