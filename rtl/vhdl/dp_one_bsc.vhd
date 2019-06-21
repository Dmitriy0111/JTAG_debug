--
-- File            :   dp_one_bsc.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This is debug boundary scan cell
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dp_one_bsc is
    generic
    (
        UPD_r       : std_logic := '0';
        CAP_r       : std_logic := '0'
    );
    port
    (
        -- clock and reset
        iclk        : in    std_logic;  -- internal clock
        iresetn     : in    std_logic;  -- internal reset
        -- parallel data
        pdi         : in    std_logic;  -- parallel data input
        pdo         : out   std_logic;  -- parallel data output
        -- serial data
        sdi         : in    std_logic;  -- serial data input
        sdo         : out   std_logic;  -- serial data output
        -- from tap controller
        mode        : in    std_logic;  -- mode
        shift_dr    : in    std_logic;  -- shift data register
        clk_dr      : in    std_logic;  -- clock data register
        update_dr   : in    std_logic   -- update data register
    );
end dp_one_bsc;

architecture rtl of dp_one_bsc is
    signal shift_dr_mux : std_logic;    -- for selecting data 
    signal CAP          : std_logic;    -- capture register
    signal UPD          : std_logic;    -- update register
begin
    
    shift_dr_mux <= sdi when ( shift_dr = '1' ) else pdi;
    sdo   <= CAP;
    pdo   <= UPD when ( mode = '1' ) else pdi;

    CAP_proc : process( iclk, iresetn )
    begin
        if( not iresetn ) then
            CAP <= CAP_r;
        elsif( rising_edge(iclk) ) then 
            if( clk_dr ) then
                CAP <= shift_dr_mux;
            end if;
        end if;
    end process;

    UPD_proc : process( iclk, iresetn )
    begin
        if( not iresetn ) then
            UPD <= UPD_r;
        elsif( rising_edge(iclk) ) then 
            if( update_dr ) then
                UPD <= CAP;
            end if;
        end if;
    end process;
    
end rtl; -- dp_one_bsc
    