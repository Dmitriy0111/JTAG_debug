--
-- File            :   dp_ir.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This is debug instruction register
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library dp;
use dp.dp_components.all;

entity dp_ir is 
    generic
    (
        width       : integer := 8;
        UPD_r       : std_logic_vector;
        CAP_r       : std_logic_vector
    );
    port
    (
        -- clock and reset
        iclk        : in    std_logic;                              -- internal clock
        iresetn     : in    std_logic;                              -- internal reset
        -- parallel data
        pdi         : in    std_logic_vector(width-1 downto 0);     -- parallel data input
        pdo         : out   std_logic_vector(width-1 downto 0);     -- parallel data output
        -- serial data
        sdi         : in    std_logic;                              -- serial data input
        sdo         : out   std_logic;                              -- serial data output
        -- from tap controller
        shift_ir    : in    std_logic;                              -- shift instruction register
        clk_ir      : in    std_logic;                              -- clock instruction register
        update_ir   : in    std_logic                               -- update instruction register
    );
end dp_ir;

architecture rtl of dp_ir is
    signal i_con    : std_logic_vector(width downto 0); -- internal connect
begin

    sdo      <= i_con(width);
    i_con(0) <= sdi;

    irc_gen:
    for irc_n in 0 to width-1 generate
        dp_one_irc_i : dp_one_irc
        generic map
        (
            UPD_r       => UPD_r( irc_n ),
            CAP_r       => CAP_r( irc_n )
        )
        port map
        (
            -- clock and reset
            iclk        => iclk,                    -- internal clock
            iresetn     => iresetn,                 -- internal reset
            -- parallel data
            pdi         => pdi( irc_n ),            -- parallel data input
            pdo         => pdo( irc_n ),            -- parallel data output
            -- serial data
            sdi         => i_con( width-irc_n-1 ),  -- serial data input
            sdo         => i_con( width-irc_n-0 ),  -- serial data output
            -- from tap controller
            shift_ir    => shift_ir,                -- shift instruction register
            clk_ir      => clk_ir,                  -- clock instruction register
            update_ir   => update_ir                -- update instruction register
        );
    end generate irc_gen;

end rtl; -- dp_ir
