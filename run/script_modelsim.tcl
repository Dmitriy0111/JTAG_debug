
vlib work

#set test "dp_tap_controller_tb"
set test "dp_dap_tb"

set i0 +incdir+../rtl
set i1 +incdir+../tb

set s0 ../rtl/*.*v
set s1 ../tb/*.*v

vlog $i0 $i1 $s0 $s1

if {$test == "dp_tap_controller_tb"} {
    vsim -novopt work.dp_tap_controller_tb
    add wave -radix hexadecimal -position insertpoint sim:/dp_tap_controller_tb/*
    add wave -radix hexadecimal -position insertpoint sim:/dp_tap_controller_tb/dp_tap_controller_0/*
} elseif {$test == "dp_dap_tb"} {
    vsim -novopt work.dp_dap_tb
    add wave -radix hexadecimal -position insertpoint sim:/dp_dap_tb/*
    add wave -radix hexadecimal -position insertpoint sim:/dp_dap_tb/dp_dap_0/*
    add wave -radix hexadecimal -position insertpoint sim:/dp_dap_tb/dp_dap_0/dp_tap_controller_0/state
    add wave -radix hexadecimal -position insertpoint sim:/dp_dap_tb/dp_dap_0/dp_tap_controller_0/next_state
}

run -all

wave zoom full

#quit
