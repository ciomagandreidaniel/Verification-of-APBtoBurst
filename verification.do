cd {D:/Verification-of-APBtoBurst}
vlib work
vmap work work
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/RTL code/data_burst_controller.v}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/RTL code/register_bank.v}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/RTL code/register_bank_controller.v}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/RTL code/rtl_top.v}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/register_model.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/interface.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/Burst.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/APB_transfer.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/BM_Generator.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/BM_Monitor.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/BM_Driver.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/BM_Agent.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/APB_Generator.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/APB_Monitor.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/APB_Driver.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/APB_Agent.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/Scoreboard.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/Environment.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/testcase.sv}
vlog -reportprogress 300 -work work {D:/Verification-of-APBtoBurst/verifc/top.sv}
vsim work.top -novopt -sv_seed random 

run -all