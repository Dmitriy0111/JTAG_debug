--
-- File            :   dp_dmr_types.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.21
-- Language        :   VHDL
-- Description     :   This is debug module registers
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package dp_dmr_types is

    -- |  Name                                  | Address   | Line  | Used  |
    -- | -------------------------------------- | --------- | ----- | ----- |
    -- |  Abstract Data 0                       | ( 0x04 )  |    40 |   +   |
    -- |  Abstract Data 1                       | ( 0x05 )  |    45 |   +   |
    -- |  Debug Module Control                  | ( 0x10 )  |    50 |   +   |
    -- |  Debug Module Status                   | ( 0x11 )  |    67 |   +   |
    -- |  Hart Info                             | ( 0x12 )  |    91 |   +   |
    -- |  Halt Summary 1                        | ( 0x13 )  |   101 |       |
    -- |  Hart Array Window Select              | ( 0x14 )  |   106 |       |
    -- |  Hart Array Window                     | ( 0x15 )  |   112 |       |
    -- |  Abstract Control and Status           | ( 0x16 )  |   117 |   +   |
    -- |  Abstract Command                      | ( 0x17 )  |   129 |   +   |
    -- |  Abstract Command Autoexec             | ( 0x18 )  |   135 |   +   |
    -- |  Configuration String Pointer 0        | ( 0x19 )  |   141 |       |
    -- |  Next Debug Module                     | ( 0x1d )  |   146 |       |
    -- |  Program Buffer 0                      | ( 0x20 )  |   151 |   +   |
    -- |  Authentication Data                   | ( 0x30 )  |   157 |       |
    -- |  Halt Summary 2                        | ( 0x34 )  |   162 |       |
    -- |  Halt Summary 3                        | ( 0x35 )  |   167 |       |
    -- |  System Bus Address 127:96             | ( 0x37 )  |   172 |       |
    -- |  System Bus Access Control and Status  | ( 0x38 )  |   177 |       |
    -- |  System Bus Address 31:0               | ( 0x39 )  |   196 |       |
    -- |  System Bus Address 63:32              | ( 0x3a )  |   201 |       |
    -- |  System Bus Address 95:64              | ( 0x3b )  |   206 |       |
    -- |  System Bus Data 31:0                  | ( 0x3c )  |   211 |       |
    -- |  System Bus Data 63:32                 | ( 0x3d )  |   216 |       |
    -- |  System Bus Data 95:64                 | ( 0x3e )  |   221 |       |
    -- |  System Bus Data 127:96                | ( 0x3f )  |   226 |       |
    -- |  Halt Summary 0                        | ( 0x40 )  |   231 |   +   |

    constant DATA0_A        : std_logic_vector(6 downto 0) := 7X"04";
    constant DATA1_A        : std_logic_vector(6 downto 0) := 7X"05";
    constant DMCONTROL_A    : std_logic_vector(6 downto 0) := 7X"10";
    constant DMSTATUS_A     : std_logic_vector(6 downto 0) := 7X"11";
    constant HARTINFO_A     : std_logic_vector(6 downto 0) := 7X"12";
    constant ABSTRACTCS_A   : std_logic_vector(6 downto 0) := 7X"16";
    constant COMMAND_A      : std_logic_vector(6 downto 0) := 7X"17";
    constant ABSTRACTAUTO_A : std_logic_vector(6 downto 0) := 7X"18";
    constant PROGBUF0_A     : std_logic_vector(6 downto 0) := 7X"20";
    constant HALTSUM0_A     : std_logic_vector(6 downto 0) := 7X"40";

end package dp_dmr_types;
