`ifndef GUARD_BM_MONITOR
`define GUARD_BM_MONITOR

`include "Burst.sv"
`include "register_model.sv"

class BM_Monitor;

//creating a virtual interface handle
virtual bm_interface.BM_MONITOR bm_intf;

//creating a mailbox handle
mailbox mon2scb;

//data to scoreboard
//bit[7:0] mailbox_data;
Burst burst;


//constructor
function new(virtual bm_interface.BM_MONITOR bm_intf_new, mailbox mon2scb_new);

 //getting the interface
 this.bm_intf = bm_intf_new;
 //getting the mailbox handles from environment
 this.mon2scb = mon2scb_new;
 

endfunction : new

//--------------------------------------------------------------------------------------------------------
// START TASK
//--------------------------------------------------------------------------------------------------------

task start();
//if current transaction is WRITE_TRANSACTION
if(current_transaction == WRITE_TRANSACTION)
begin
int i = 0;
burst = new();
burst.data_bytes = new [1]; 
$display(" %0d : BM_Monitor : Start task", $time);


forever begin
 @(posedge bm_intf.clk);
 wait(bm_intf.bm_monitor_cb.db_valid & bm_intf.bm_monitor_cb.burst_ready)
 if(~bm_intf.bm_monitor_cb.last)
 begin
 burst.data_bytes[i] = bm_intf.bm_monitor_cb.data_burst_out;
 burst.data_bytes    = new [burst.data_bytes.size() + 1] (burst.data_bytes);
 $display(" %0d : BM_Monitor : Data byte %d added to burst",$time, burst.data_bytes[i]);
 i = i +1 ;
 end 
 else begin
 burst.data_bytes[i] = bm_intf.bm_monitor_cb.data_burst_out;
 $display(" %0d : BM_Monitor : Data byte %d added to burst",$time, burst.data_bytes[i]);
 burst.burst_size = burst.data_bytes.size();
 $display(" %0d : BM_Monitor : Burst size set to %d", $time, burst.burst_size); 
 mon2scb.put(burst);
 $display(" %0d : BM_Monitor : Burst packet from APB send to Scoreboard via mailbox", $time);
 burst = new();
 burst.data_bytes = new [1]; 
 i = 0;
 end
end
end


//if current transaction is READ_TRANSACTION 
else if(current_transaction == READ_TRANSACTION)
begin

bit [7:0] data_to_read;
$display(" %0d : BM_Monitor : Start task", $time);
forever begin
@(posedge bm_intf.clk);
wait(bm_intf.bm_monitor_cb.db_ready & bm_intf.bm_monitor_cb.burst_valid);
data_to_read = bm_intf.bm_monitor_cb.data_burst_in;
mon2scb.put(data_to_read);
$display(" %0d : BM_Monitor : Data byte send to Scoreboard via mailbox", $time);
end
 
end

endtask : start

endclass : BM_Monitor

`endif
