`ifndef GUARD_BM_AGENT
`define GUARD_BM_AGENT

`include "BM_Driver.sv"
`include "BM_Monitor.sv"

class BM_Agent;

BM_Driver  drvr;
BM_Monitor mont;

function new(
virtual bm_interface.BM_DRIVER bm_driver_intf_new,
virtual bm_interface.BM_MONITOR bm_monitor_intf_new,
mailbox mon2scb_new
);
drvr = new(bm_driver_intf_new);
mont = new(bm_monitor_intf_new, mon2scb_new);
endfunction : new 

task start();
fork
drvr.start_burst_ready();
mont.start();
join_any
endtask : start

endclass : BM_Agent
`endif


