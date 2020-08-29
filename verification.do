cd {D:/Verification Env}
vlib work
vmap work work
vlog -reportprogress 300 -work work {D:/Verification Env/RTL code/data_burst_controller.v}
vlog -reportprogress 300 -work work {D:/Verification Env/RTL code/register_bank.v}
vlog -reportprogress 300 -work work {D:/Verification Env/RTL code/register_bank_controller.v}
vlog -reportprogress 300 -work work {D:/Verification Env/RTL code/rtl_top.v}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/register_model.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/interface.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/Burst.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/APB_transfer.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/BM_Monitor.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/BM_Driver.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/BM_Agent.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/APB_Generator.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/APB_Monitor.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/APB_Driver.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/APB_Agent.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/Scoreboard.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/Environment.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/testcase.sv}
vlog -reportprogress 300 -work work {D:/Verification Env/verifc/top.sv}
vsim work.top -novopt -sv_seed random

run -all