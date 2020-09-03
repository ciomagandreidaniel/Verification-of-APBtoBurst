`ifndef GUARD_APB_AGENT
`define GUARD_APB_AGENT

`include "register_model.sv"
`include "APB_Generator.sv"
`include "APB_Driver.sv"
`include "APB_Monitor.sv"

class APB_Agent;

APB_Generator genr;
APB_Driver    drvr;
APB_Monitor   mont;

mailbox mailbox_genr_drvr;

function new(
virtual apb_interface.APB_DRIVER apb_driver_intf_new,
virtual apb_interface.APB_MONITOR apb_monitor_intf_new,
mailbox mon2scb_new
);

mailbox_genr_drvr = new();
drvr = new(apb_driver_intf_new,mailbox_genr_drvr);
mont = new(apb_monitor_intf_new, mon2scb_new);
genr = new(mailbox_genr_drvr);

endfunction : new

task cfg();

std::randomize(current_transaction); 

//current_transaction = WRITE_TRANSACTION;
//current_transaction = READ_TRANSACTION;

$display(" %0d : APB_Agent : The curent Transaction is %s", $time,current_transaction);
genr.cfg();
drvr.cfg();

endtask : cfg

task start();

fork
genr.start(); 
drvr.start();
mont.start();
join_any

endtask : start

endclass : APB_Agent

`endif