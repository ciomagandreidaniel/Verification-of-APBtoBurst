onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /top/TC/apb_monitor_intf/clk
add wave -noupdate -radix unsigned /top/TC/apb_monitor_intf/rst_n
add wave -noupdate -radix unsigned /top/TC/apb_monitor_intf/paddr
add wave -noupdate -radix unsigned /top/TC/apb_monitor_intf/psel
add wave -noupdate -radix unsigned /top/TC/apb_monitor_intf/penable
add wave -noupdate -radix unsigned /top/TC/apb_monitor_intf/pwrite
add wave -noupdate -radix unsigned /top/TC/apb_monitor_intf/pwdata
add wave -noupdate -radix unsigned /top/TC/apb_monitor_intf/prdata
add wave -noupdate -radix unsigned /top/TC/apb_monitor_intf/plsverr
add wave -noupdate -radix unsigned /top/TC/apb_monitor_intf/apb_rd_done
add wave -noupdate -radix unsigned /top/TC/apb_monitor_intf/idle
add wave -noupdate -radix unsigned /top/TC/bm_monitor_intf/clk
add wave -noupdate -radix unsigned /top/TC/bm_monitor_intf/rst_n
add wave -noupdate -radix unsigned /top/TC/bm_monitor_intf/burst_valid
add wave -noupdate -radix unsigned /top/TC/bm_monitor_intf/burst_ready
add wave -noupdate -radix unsigned /top/TC/bm_monitor_intf/data_burst_in
add wave -noupdate -radix unsigned /top/TC/bm_monitor_intf/burst_last
add wave -noupdate -radix unsigned /top/TC/bm_monitor_intf/data_burst_out
add wave -noupdate -radix unsigned /top/TC/bm_monitor_intf/db_length
add wave -noupdate -radix unsigned /top/TC/bm_monitor_intf/last
add wave -noupdate -radix unsigned /top/TC/bm_monitor_intf/db_ready
add wave -noupdate -radix unsigned /top/TC/bm_monitor_intf/db_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {59442 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {59340 ns} {60340 ns}
