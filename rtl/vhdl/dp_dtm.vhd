--
-- File            :   dp_dtm.sv
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This is debug transport module
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library dp;
use dp.dp_constants.all;
use dp.dp_help_pkg.all;
use dp.dp_components.all;

entity dp_dtm is
    port
    ( 
        -- jtag side
        tdi         : in    std_logic;                      -- test data input
        tms         : in    std_logic;                      -- test mode select
        tck         : in    std_logic;                      -- test clock
        trst        : in    std_logic;                      -- test reset
        tdo         : out   std_logic;                      -- test data output
        -- dmi
        dmi_address : out   std_logic_vector(6  downto 0);  -- dmi address
        dmi_wdata   : out   std_logic_vector(31 downto 0);  -- dmi write data
        dmi_rdata   : in    std_logic_vector(31 downto 0);  -- dmi read data
        dmi_op      : out   std_logic_vector(1  downto 0)   -- dmi operation
    );
end dp_dtm;

architecture rtl of dp_dtm is
    constant IDCODE_V   : std_logic_vector(31 downto 0) := 
                                                            4B"0001" &              -- Version      [31 : 28]
                                                            16B"0000000000000111" & -- PartNumber   [27 : 12]
                                                            11B"00000000111" &      -- ManufId      [11 :  1]
                                                            1B"1";                  -- 1            [0  :  0]  
    constant DTMCS   : std_logic_vector(31 downto 0) := 
                                                            14B"00000000000000" &   -- NU           [31 : 18]
                                                            1B"0" &                 -- dmihardreset [17 : 17]
                                                            1B"0" &                 -- dmireset     [16 : 16]
                                                            1B"0" &                 -- NU           [15 : 15]
                                                            3B"001" &               -- idle         [14 : 12]
                                                            2B"00" &                -- dmistat      [11 : 10]
                                                            6B"000110" &            -- abits        [9  :  4]
                                                            4B"0001";               -- version      [3  :  0]
    constant DMI     : std_logic_vector(40 downto 0) := 
                                                            7B"0000000" &           -- address      [40 : 34]
                                                            32X"00000000" &         -- data         [33 :  2]
                                                            2B"00";                 -- op           [1  :  0]

    -- clock and reset
    signal iclk         : std_logic;                            -- internal clock
    signal iresetn      : std_logic;                            -- internal reset
    -- tap data registers
    signal mode_tap     : std_logic;                            -- mode
    signal shift_tap    : std_logic;                            -- shift data register
    signal clk_tap      : std_logic;                            -- clock data register
    signal update_tap   : std_logic;                            -- update data register
    -- tdo selecting (ir or one of bsrs)
    signal sel_tdo      : std_logic;                            -- select tdo
    signal bsr_sel      : std_logic_vector(3  downto 0);        -- bsr sel for tdo output
    -- 
    signal sdo_ir       : std_logic;                            -- serial data output of instruction register
    signal pdo_ir       : std_logic_vector(4  downto 0);        -- parallel data output of instruction register
    signal sdo_dr       : std_logic;                            -- serial data output from mux 
    signal sdo_bsr      : logic_array(3 downto 0);              -- serial data output of bsrs
    -- bsr registers
    signal mode_bsr     : std_logic;                            -- mode
    signal shift_bsr    : logic_array(3 downto 0);              -- shift data register
    signal clk_bsr      : logic_array(3 downto 0);              -- clock data register
    signal update_bsr   : logic_array(3 downto 0);              -- update data register
    -- instruction register
    signal shift_ir     : std_logic;                            -- shift instruction register
    signal clk_ir       : std_logic;                            -- clock instruction register
    signal update_ir    : std_logic;                            -- update instruction register
    -- dmi register
    signal pdo_dmi      : std_logic_vector(40 downto 0);        -- parallel data output dmi 
    signal pdi_dmi      : std_logic_vector(40 downto 0);
begin

    mode_bsr <= mode_tap;
    tdo  <= sdo_ir when ( sel_tdo = '1' ) else sdo_dr;

    dmi_address <= pdo_dmi(40 downto 34);
    dmi_wdata   <= pdo_dmi(33 downto  2);
    dmi_op      <= pdo_dmi(1  downto  0);

    pdi_dmi     <= 7B"0000000" & dmi_rdata & 2B"00";

    -- creating one tap controller
    dp_tap_controller_0 : dp_tap_controller
    port map
    (
        -- jtag side
        tms             => tms,             -- test mode select
        tck             => tck,             -- test clock
        trst            => trst,            -- test reset
        iclk            => iclk,            -- internal clock
        iresetn         => iresetn,         -- internal reset
        sel_tdo         => sel_tdo,         -- select tdo
        -- data register side
        mode            => mode_tap,        -- mode
        shift_dr        => shift_tap,       -- shift data register
        clk_dr          => clk_tap,         -- clock data register
        update_dr       => update_tap,      -- update data register
        -- instruction register side
        shift_ir        => shift_ir,        -- shift instruction register
        clk_ir          => clk_ir,          -- clock instruction register
        update_ir       => update_ir        -- update instruction register
    );
    -- creating one data register multiplexor
    dp_mux_dr_0 : dp_mux_dr  
    port map
    ( 
        sdi             => sdo_bsr,
        shift_dr        => shift_tap,
        clk_dr          => clk_tap,
        update_dr       => update_tap,
        sdo             => sdo_dr,
        shift_dr_out    => shift_bsr,
        clk_dr_out      => clk_bsr,
        update_dr_out   => update_bsr,
        bsr_sel         => bsr_sel
    );
    -- creating one instruction decoder
    dp_ir_dec_0 : dp_ir_dec 
    port map
    ( 
        pdi             => pdo_ir,          -- parallel data input
        bsr_sel         => bsr_sel          -- boundary scan register select
    );
    -- creating one dtmcs bsr
    dp_bsr_dtmcs : dp_bsr 
    generic map
    (
        width           => 32,
        UPD_r           => DTMCS,
        CAP_r           => DTMCS
    ) 
    port map
    (
        -- clock and reset
        iclk            => iclk,                        -- internal clock
        iresetn         => iresetn,                     -- internal reset
        -- parallel data
        pdi             => DTMCS,                       -- parallel data input
        pdo             => open,                        -- parallel data output
        -- serial data
        sdi             => tdi,                         -- serial data input
        sdo             => sdo_bsr      (SEL_DTMCS_I),  -- serial data output
        -- from tap controller
        mode            => mode_bsr,                    -- mode
        shift_dr        => shift_bsr    (SEL_DTMCS_I),  -- shift data register
        clk_dr          => clk_bsr      (SEL_DTMCS_I),  -- clock data register
        update_dr       => update_bsr   (SEL_DTMCS_I)   -- update data register
    );
    -- creating one dmi bsr
    dp_bsr_dmi : dp_bsr 
    generic map
    (
        width           => 41,
        UPD_r           => DMI,
        CAP_r           => DMI
    ) 
    port map
    (
        -- clock and reset
        iclk            => iclk,                        -- internal clock
        iresetn         => iresetn,                     -- internal reset
        -- parallel data
        pdi             => pdi_dmi,                     -- parallel data input
        pdo             => pdo_dmi,                     -- parallel data output
        -- serial data
        sdi             => tdi,                         -- serial data input
        sdo             => sdo_bsr      (SEL_DMI_I),    -- serial data output
        -- from tap controller
        mode            => mode_bsr,                    -- mode
        shift_dr        => shift_bsr    (SEL_DMI_I),    -- shift data register
        clk_dr          => clk_bsr      (SEL_DMI_I),    -- clock data register
        update_dr       => update_bsr   (SEL_DMI_I)     -- update data register
    );
    -- creating one IDCODE bsr
    dp_bsr_idcode : dp_bsr 
    generic map
    (
        width           => 32,
        UPD_r           => IDCODE_V,
        CAP_r           => IDCODE_V
    ) 
    port map
    (
        -- clock and reset
        iclk            => iclk,                        -- internal clock
        iresetn         => iresetn,                     -- internal reset
        -- parallel data
        pdi             => IDCODE_V,                    -- parallel data input
        pdo             => open,                        -- parallel data output
        -- serial data
        sdi             => tdi,                         -- serial data input
        sdo             => sdo_bsr      (SEL_IDCODE_I), -- serial data output
        -- from tap controller
        mode            => mode_bsr,                    -- mode
        shift_dr        => shift_bsr    (SEL_IDCODE_I), -- shift data register
        clk_dr          => clk_bsr      (SEL_IDCODE_I), -- clock data register
        update_dr       => update_bsr   (SEL_IDCODE_I)  -- update data register
    );
    -- creating one bypass register
    dp_br_0 : dp_br
    port map
    ( 
        -- clock and reset
        iclk            => iclk,                        -- internal clock
        iresetn         => iresetn,                     -- internal reset
        -- serial data
        sdi             => tdi,                         -- serial data input
        sdo             => sdo_bsr      (SEL_BYPASS_I), -- serial data output
        -- from tap controller
        clock_dr        => clk_bsr      (SEL_BYPASS_I)  -- clock data register
    );
    -- creating one instruction register
    dp_ir_reg : dp_ir 
    generic map
    (
        width           => INSTR_REG_LEN,
        UPD_r           => INSTR_REG_RST_V,
        CAP_r           => INSTR_REG_RST_V
    ) 
    port map
    (
        -- clock and reset
        iclk            => iclk,            -- internal clock
        iresetn         => iresetn,         -- internal reset
        -- parallel data
        pdi             => INSTR_REG_RST_V, -- parallel data input
        pdo             => pdo_ir,          -- parallel data output
        -- serial data
        sdi             => tdi,             -- serial data input
        sdo             => sdo_ir,          -- serial data output
        -- from tap controller
        shift_ir        => shift_ir,        -- shift instruction register
        clk_ir          => clk_ir,          -- clock instruction register
        update_ir       => update_ir        -- update instruction register
    );

end rtl; -- dp_dtm
