--
-- File            :   dp_bsr.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This is debug boundary scan register
-- Copyright(c)    :   2019 Vlasov D.V.
--

--
-- File            :   dp_bsr.vhd
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

entity dp_bsr is 
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
        mode        : in    std_logic;                              -- mode
        shift_dr    : in    std_logic;                              -- shift instruction register
        clk_dr      : in    std_logic;                              -- clock instruction register
        update_dr   : in    std_logic                               -- update instruction register
    );
end dp_bsr;

architecture rtl of dp_bsr is
    signal i_con    : std_logic_vector(width downto 0); -- internal connect
begin

    sdo      <= i_con(width);
    i_con(0) <= sdi;

    bsc_gen:
    for bsc_n in 0 to width-1 generate
        dp_one_bsc_i : dp_one_bsc
        generic map
        (
            UPD_r       => UPD_r( bsc_n ),
            CAP_r       => CAP_r( bsc_n )
        )
        port map
        (
            -- clock and reset
            iclk        => iclk,                    -- internal clock
            iresetn     => iresetn,                 -- internal reset
            -- parallel data
            pdi         => pdi( bsc_n ),            -- parallel data input
            pdo         => pdo( bsc_n ),            -- parallel data output
            -- serial data
            sdi         => i_con( width-bsc_n-1 ),  -- serial data input
            sdo         => i_con( width-bsc_n-0 ),  -- serial data output
            -- from tap controller
            mode        => mode,                    -- mode
            shift_dr    => shift_dr,                -- shift data register
            clk_dr      => clk_dr,                  -- clock data register
            update_dr   => update_dr                -- update data register
        );
    end generate bsc_gen;

end rtl; -- dp_bsr
