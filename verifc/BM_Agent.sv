`ifndef GUARD_BM_AGENT
`define GUARD_BM_AGENT

`include "BM_Driver.sv"
`include "BM_Monitor.sv"
`include "BM_Generator.sv"

class BM_Agent;

BM_Driver    drvr;
BM_Monitor   mont;
BM_Generator genr;

mailbox mailbox_genr_drvr;

function new(
virtual bm_interface.BM_DRIVER bm_driver_intf_new,
virtual bm_interface.BM_MONITOR bm_monitor_intf_new,
mailbox mon2scb_new
);
mailbox_genr_drvr = new();
drvr = new(bm_driver_intf_new, mailbox_genr_drvr);
mont = new(bm_monitor_intf_new, mon2scb_new);
genr = new(mailbox_genr_drvr);
endfunction : new 

task start();
genr.start();
fork
drvr.start_burst_ready();
drvr.start_read();
//mont.start();
join_any
endtask : start

task burst_ready_gen();
drvr.start_burst_ready();
endtask : burst_ready_gen

endclass : BM_Agent
`endif


