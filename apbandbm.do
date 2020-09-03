onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /top/apb_intf/apb_driver_cb/idle
add wave -noupdate -radix unsigned /top/apb_intf/apb_driver_cb/apb_rd_done
add wave -noupdate -radix unsigned /top/apb_intf/apb_driver_cb/plsverr
add wave -noupdate -radix unsigned /top/apb_intf/apb_driver_cb/prdata
add wave -noupdate -radix unsigned /top/apb_intf/apb_driver_cb/pwdata
add wave -noupdate -radix unsigned /top/apb_intf/apb_driver_cb/psel
add wave -noupdate -radix unsigned /top/apb_intf/apb_driver_cb/pwrite
add wave -noupdate -radix unsigned /top/apb_intf/apb_driver_cb/penable
add wave -noupdate -radix unsigned /top/apb_intf/apb_driver_cb/paddr
add wave -noupdate -radix unsigned /top/apb_intf/apb_driver_cb/apb_driver_cb_event
add wave -noupdate -radix unsigned /top/bm_intf/bm_driver_cb/db_valid
add wave -noupdate -radix unsigned /top/bm_intf/bm_driver_cb/last
add wave -noupdate -radix unsigned /top/bm_intf/bm_driver_cb/db_length
add wave -noupdate -radix unsigned /top/bm_intf/bm_driver_cb/data_burst_out
add wave -noupdate -radix unsigned /top/bm_intf/bm_driver_cb/burst_last
add wave -noupdate -radix unsigned /top/bm_intf/bm_driver_cb/db_ready
add wave -noupdate -radix unsigned /top/bm_intf/bm_driver_cb/data_burst_in
add wave -noupdate -radix unsigned /top/bm_intf/bm_driver_cb/burst_ready
add wave -noupdate -radix unsigned /top/bm_intf/bm_driver_cb/burst_valid
add wave -noupdate -radix unsigned /top/bm_intf/bm_driver_cb/bm_driver_cb_event
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4025 ns} 0}
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
WaveRestoreZoom {3940 ns} {4722 ns}
