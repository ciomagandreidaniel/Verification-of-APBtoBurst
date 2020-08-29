`ifndef GUARD_BURST_READY
`define GUARD_BURST_READY

class Burst_ready;
rand bit [7:0] generated_burst_ready;
constraint generated_burst_ready_c{generated_burst_ready inside {[1:100]};};
endclass : Burst_ready

`endif 