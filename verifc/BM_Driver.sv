`ifndef GUARD_BM_DRIVER
`define GUARD_BM_DRIVER

`include "Burst.sv"
`include "Burst_ready.sv"
`include "register_model.sv"
class BM_Driver;

virtual bm_interface.BM_DRIVER bm_intf;


Burst_ready burst_rdy;
mailbox bm_mailbox_driver;

function new(virtual bm_interface.BM_DRIVER bm_intf_new, mailbox bm_mailbox_driver_new);
this.bm_intf           = bm_intf_new;
this.bm_mailbox_driver = bm_mailbox_driver_new;
endfunction : new 

//-----------------------------------------------------------------------------------------------------
// START_BURST_READY TASK
//-----------------------------------------------------------------------------------------------------

task start_burst_ready();

burst_rdy = new();

 while(start_scoreboard) begin
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

//-----------------------------------------------------------------------------------------------------
// START_READ TASK
//-----------------------------------------------------------------------------------------------------

task start_read();

if(current_transaction == READ_TRANSACTION)
begin
bit [7:0] data_byte;
int i = 0; 

repeat(bm_intf.bm_driver_cb.db_length) begin
 if(i<7)
 begin
  @(posedge bm_intf.clk);
  bm_intf.bm_driver_cb.burst_last <= 0;
  bm_intf.bm_driver_cb.burst_valid <= 0;
  wait(bm_intf.bm_driver_cb.db_ready);
  bm_mailbox_driver.get(data_byte);
  $display(" %0d : BM_Driver : Has received a data_byte via mailbox", $time);
  bm_intf.bm_driver_cb.data_burst_in <= data_byte;
  bm_intf.bm_driver_cb.burst_valid <= 1;
  i = i + 1;
  $display(" %0d : BM_Driver : Put data byte %0d on data_burst_in", $time,data_byte);
 end
 else
 begin
 @(posedge bm_intf.clk);
 bm_intf.bm_driver_cb.burst_valid <= 0;
 wait(bm_intf.bm_driver_cb.db_ready);
 bm_mailbox_driver.get(data_byte);
 $display(" %0d : BM_Driver : Has received a data_byte via mailbox", $time);
 bm_intf.bm_driver_cb.burst_last <= 1;
 bm_intf.bm_driver_cb.data_burst_in <= data_byte;
 bm_intf.bm_driver_cb.burst_valid <= 1;
 i = 0;
    $display(" %0d : BM_Driver : Put data byte %0d on data_burst_in", $time,data_byte);
 end
end
bm_driver_stop = 1;
end
endtask : start_read

endclass : BM_Driver



`endif
