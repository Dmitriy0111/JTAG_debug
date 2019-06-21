--
-- File            :   dp_constants.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This constants
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package dp_constants is

    -- instruction register lenght
    constant INSTR_REG_LEN      : integer := 5;
    constant INSTR_REG_RST_V    : std_logic_vector(4 downto 0) := 5X"01";

    -- instruction decoder selections
    constant SEL_IDCODE : std_logic_vector(3 downto 0) := 4X"0";
    constant SEL_DTMCS  : std_logic_vector(3 downto 0) := 4X"1";
    constant SEL_DMI    : std_logic_vector(3 downto 0) := 4X"2";
    constant SEL_BYPASS : std_logic_vector(3 downto 0) := 4X"3";
    constant SEL_ANY    : std_logic_vector(3 downto 0) := 4B"----";

    constant SEL_IDCODE_I   : integer := to_integer( unsigned( SEL_IDCODE ) );
    constant SEL_DTMCS_I    : integer := to_integer( unsigned( SEL_DTMCS  ) );
    constant SEL_DMI_I      : integer := to_integer( unsigned( SEL_DMI    ) );
    constant SEL_BYPASS_I   : integer := to_integer( unsigned( SEL_BYPASS ) );

    -- risv-v JTAG DTM registers
    constant BYPASS_0       : std_logic_vector(4 downto 0) := 5X"00";
    constant IDCODE         : std_logic_vector(4 downto 0) := 5X"01";
    constant DTMCS          : std_logic_vector(4 downto 0) := 5X"10";
    constant DMI            : std_logic_vector(4 downto 0) := 5X"11";
    constant RSV_BYPASS_0   : std_logic_vector(4 downto 0) := 5X"12";
    constant RSV_BYPASS_1   : std_logic_vector(4 downto 0) := 5X"13";
    constant RSV_BYPASS_2   : std_logic_vector(4 downto 0) := 5X"14";
    constant RSV_BYPASS_3   : std_logic_vector(4 downto 0) := 5X"15";
    constant RSV_BYPASS_4   : std_logic_vector(4 downto 0) := 5X"16";
    constant RSV_BYPASS_5   : std_logic_vector(4 downto 0) := 5X"17";
    constant BYPASS_1       : std_logic_vector(4 downto 0) := 5X"1f";
    constant ANY            : std_logic_vector(4 downto 0) := 5B"-----";

end package dp_constants;
