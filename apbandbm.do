onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/clk
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/rst_n
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/rb_db_start
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/rb_db_data
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/rb_db_ack
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/rb_db_rw
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/rb_db_max_burst_size
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/rb_db_length
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/db_rb_req
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/db_rb_data
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/db_rb_addr
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/db_rb_idle
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/db_rb_rd_done
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/burst_valid
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/burst_ready
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/data_burst_in
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/burst_last
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/data_burst_out
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/db_length
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/last
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/db_ready
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/db_valid
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/generated_w_addr
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/generated_rb_addr
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/w_count_length
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/r_count_length
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/w_count_burst
add wave -noupdate /top/apbtoburst_top_DUT/db_ctrl_dut/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {300 ns} 0}
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
WaveRestoreZoom {151 ns} {881 ns}
