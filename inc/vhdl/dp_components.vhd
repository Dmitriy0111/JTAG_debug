--
-- File            :   dp_components.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This dp components
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library dp;
use dp.dp_help_pkg.all;

package dp_components is
    -- dp_br
    component dp_br
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
    end component dp_br;
    -- dp_ir_dec
    component dp_ir_dec
        port
        (
            pdi         : in    std_logic_vector(4 downto 0);   -- parallel data input
            bsr_sel     : out   std_logic_vector(3 downto 0)    -- boundary scan register select
        );
    end component dp_ir_dec;
    -- dp_mux_dr
    component dp_mux_dr
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
    end component dp_mux_dr;
    -- dp_one_bsc
    component dp_one_bsc
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
    end component dp_one_bsc;
    -- dp_one_irc
    component dp_one_irc
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
    end component dp_one_irc;
    -- dp_ir
    component dp_ir 
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
    end component dp_ir;
    -- dp_bsr
    component dp_bsr
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
    end component dp_bsr;
    -- dp_tap_controller
    component dp_tap_controller
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
    end component dp_tap_controller;
    -- dp_dtm
    component dp_dtm
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
    end component dp_dtm;
    -- dp_dm
    component dp_dm
        port
        ( 
            -- dmi
            dmi_address : in    std_logic_vector(6  downto 0);  -- dmi address
            dmi_wdata   : in    std_logic_vector(31 downto 0);  -- dmi write data
            dmi_rdata   : out   std_logic_vector(31 downto 0);  -- dmi read data
            dmi_op      : in    std_logic_vector(1  downto 0)   -- dmi operation
        );
    end component dp_dm;

end package dp_components;
