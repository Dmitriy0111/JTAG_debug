
vlib work

set test "verilog design test"
#set test "vhdl design test"

set sub_test "dp_tap_controller_tb"
#set sub_test "dp_dtm_tb"
set sub_test "dp_dtm_dm_tb"

# compile vhdl or verilog design and testbench
if {$test == "verilog design test"} {
    set i0 +incdir+../rtl/sv
    set i1 +incdir+../tb/sv

    set s0 ../rtl/sv/*.*v
    set s1 ../tb/sv/*.*v

    vlog $i0 $i1 $s0 $s1
} elseif { $test == "vhdl design test" } {

    vcom -2008 ../inc/vhdl/dp_help_pkg.vhd          -work dp
    vcom -2008 ../inc/vhdl/dp_constants.vhd         -work dp
    vcom -2008 ../inc/vhdl/dp_components.vhd        -work dp
    vcom -2008 ../inc/vhdl/dp_dmr_types.vhd         -work dp

    vcom -2008  ../rtl/vhdl/*.vhd

    vlog ../tb/sv/*.*v
}

# run subtestes
if {$sub_test == "dp_tap_controller_tb"} {
    vsim -novopt work.dp_tap_controller_tb
    add wave -radix hexadecimal -position insertpoint sim:/dp_tap_controller_tb/*
    add wave -radix hexadecimal -position insertpoint sim:/dp_tap_controller_tb/dp_tap_controller_0/*
} elseif {$sub_test == "dp_dtm_tb"} {
    vsim -novopt work.dp_dtm_tb
    add wave -radix hexadecimal -position insertpoint sim:/dp_dtm_tb/*
    add wave -radix hexadecimal -position insertpoint sim:/dp_dtm_tb/dp_dtm_0/*
    add wave -radix hexadecimal -position insertpoint sim:/dp_dtm_tb/dp_dtm_0/dp_tap_controller_0/state
    add wave -radix hexadecimal -position insertpoint sim:/dp_dtm_tb/dp_dtm_0/dp_tap_controller_0/next_state
} elseif {$sub_test == "dp_dtm_dm_tb"} {
    vsim -novopt work.dp_dtm_dm_tb
    add wave -radix hexadecimal -position insertpoint sim:/dp_dtm_dm_tb/*
    add wave -radix hexadecimal -position insertpoint sim:/dp_dtm_dm_tb/dp_dtm_0/*
    add wave -radix hexadecimal -position insertpoint sim:/dp_dtm_dm_tb/dp_dtm_0/dp_tap_controller_0/state
    add wave -radix hexadecimal -position insertpoint sim:/dp_dtm_dm_tb/dp_dtm_0/dp_tap_controller_0/next_state
}

run -all

wave zoom full

#quit
