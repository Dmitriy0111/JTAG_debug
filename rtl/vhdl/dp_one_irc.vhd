--
-- File            :   dp_one_irc.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This is debug instruction register cell
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dp_one_irc is
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
        shift_ir    : in    std_logic;  -- shift instruction register
        clk_ir      : in    std_logic;  -- clock instruction register
        update_ir   : in    std_logic   -- update instruction register
    );
end dp_one_irc;

architecture rtl of dp_one_irc is
    signal shift_ir_mux : std_logic;    -- for selecting data 
    signal CAP          : std_logic;    -- capture register
    signal UPD          : std_logic;    -- update register
begin

    shift_ir_mux <= sdi when ( shift_ir = '1' ) else pdi;
    sdo   <= CAP;
    pdo   <= UPD;

    CAP_proc : process( iclk, iresetn )
    begin
        if( not iresetn ) then
            CAP <= CAP_r;
        elsif( rising_edge(iclk) ) then 
            if( clk_ir ) then
                CAP <= shift_ir_mux;
            end if;
        end if;
    end process;

    UPD_proc : process( iclk, iresetn )
    begin
        if( not iresetn ) then
            UPD <= UPD_r;
        elsif( rising_edge(iclk) ) then 
            if( update_ir ) then
                UPD <= CAP;
            end if;
        end if;
    end process;
    
end rtl; -- dp_one_irc
    