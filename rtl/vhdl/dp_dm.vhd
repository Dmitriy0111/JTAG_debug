--
-- File            :   dp_dm.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This is debug module
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;

library dp;
use dp.dp_dmr_types.all;

entity dp_dm is
    port
    ( 
        -- dmi
        dmi_address : in    std_logic_vector(6  downto 0);  -- dmi address
        dmi_wdata   : in    std_logic_vector(31 downto 0);  -- dmi write data
        dmi_rdata   : out   std_logic_vector(31 downto 0);  -- dmi read data
        dmi_op      : in    std_logic_vector(1  downto 0)   -- dmi operation
    );
end dp_dm;

architecture rtl of dp_dm is
    signal dmcontrol_in     : std_logic_vector(31 downto 0);
    signal dmstatus_in      : std_logic_vector(31 downto 0);
    signal hartinfo_in      : std_logic_vector(31 downto 0);
    signal data0_in         : std_logic_vector(31 downto 0);
    signal data1_in         : std_logic_vector(31 downto 0);
    signal abstractcs_in    : std_logic_vector(31 downto 0);
    signal command_in       : std_logic_vector(31 downto 0);
    signal abstractauto_in  : std_logic_vector(31 downto 0);
    signal progbuf0_in      : std_logic_vector(31 downto 0);
    signal haltsum0_in      : std_logic_vector(31 downto 0);

    signal dmcontrol_out    : std_logic_vector(31 downto 0);
    signal dmstatus_out     : std_logic_vector(31 downto 0);
    signal hartinfo_out     : std_logic_vector(31 downto 0);
    signal data0_out        : std_logic_vector(31 downto 0);
    signal data1_out        : std_logic_vector(31 downto 0);
    signal abstractcs_out   : std_logic_vector(31 downto 0);
    signal command_out      : std_logic_vector(31 downto 0);
    signal abstractauto_out : std_logic_vector(31 downto 0);
    signal progbuf0_out     : std_logic_vector(31 downto 0);
    signal haltsum0_out     : std_logic_vector(31 downto 0);
begin

    mux_proc : process( all )
    begin
        dmi_rdata <= (others => '0');
        case( dmi_address ) is
            when DATA0_A        => dmi_rdata <= data0_out;
            when DATA1_A        => dmi_rdata <= data1_out;
            when DMCONTROL_A    => dmi_rdata <= dmcontrol_out;
            when DMSTATUS_A     => dmi_rdata <= dmstatus_out;
            when HARTINFO_A     => dmi_rdata <= hartinfo_out;
            when ABSTRACTCS_A   => dmi_rdata <= abstractcs_out;
            when COMMAND_A      => dmi_rdata <= command_out;
            when ABSTRACTAUTO_A => dmi_rdata <= abstractauto_out;
            when PROGBUF0_A     => dmi_rdata <= progbuf0_out;
            when HALTSUM0_A     => dmi_rdata <= haltsum0_out;
            when others         =>
        end case;
    end process;

end rtl; -- dp_dm
