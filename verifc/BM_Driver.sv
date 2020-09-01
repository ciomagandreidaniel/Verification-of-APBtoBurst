`ifndef GUARD_BM_DRIVER
`define GUARD_BM_DRIVER

`include "Burst.sv"
`include "Burst_ready.sv"
class BM_Driver;

virtual bm_interface.BM_DRIVER bm_intf;


Burst_ready burst_rdy;
mailbox bm_mailbox_driver;

function new(virtual bm_interface.BM_DRIVER bm_intf_new, mailbox bm_mailbox_driver_new);
this.bm_intf           = bm_intf_new;
this.bm_mailbox_driver = bm_mailbox_driver_new;
endfunction : new 

task start_burst_ready;

burst_rdy = new();

 forever begin
  if(burst_rdy.randomize())
  begin
   repeat(burst_rdy.generated_burst_ready)
    begin
     @(posedge bm_intf.clk);
    end
   this.bm_intf.bm_driver_cb.burst_ready <= ~this.bm_intf.bm_driver_cb.burst_ready; 
  end
 else
 $display(" %0d : BM_Driver : Failed to randomize burst_ready", $time);
 end
endtask : start_burst_ready

endclass : BM_Driver



`endif
