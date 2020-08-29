//------------------------------------------------------------------------------
// S.C. EasyIC Design S.R.L.
// Proiect     : Verification of APBtoBurst
// File        : Monitor.sv
// Autor       : Ciomag Andrei Daniel(CAD)
// Data        : 23.08.2020
//------------------------------------------------------------------------------
// Descriere   : The monitor samples the APB interface signals and converts
// the signal level activity to the APB_transfer level. The sampled APB_transfer
// is send to Scoreboard via Mailbox. 
//------------------------------------------------------------------------------
// Modificari  :
// 23.08.2020 (CAD): Initial 
//------------------------------------------------------------------------------

`ifndef GUARD_APB_MONITOR
`define GUARD_APB_MONITOR

`include "Burst.sv"
`include "register_model.sv"

class APB_Monitor;



//creating a virtual interface handle
virtual apb_interface.APB_MONITOR apb_intf;

//creating a mailbox handle
mailbox mon2scb;

//data to scoreboard
//bit[7:0] mailbox_data;
Burst burst;

//constructor
function new(virtual apb_interface.APB_MONITOR apb_intf_new, mailbox mon2scb_new);

 //getting the interface
 this.apb_intf = apb_intf_new;
 //getting the mailbox handles from environment
 this.mon2scb = mon2scb_new;
 

endfunction : new

task start();
int i = 0;
burst = new();

burst.burst_size = max_burst_size_reg_copy;
burst.data_bytes = new  [max_burst_size_reg_copy];

$display(" %0d : APB_Monitor :  Start task", $time);

forever begin

@(posedge apb_intf.clk);
 wait(apb_intf.apb_monitor_cb.pwrite  & 
      apb_intf.apb_monitor_cb.psel    & 
      apb_intf.apb_monitor_cb.penable &
      (apb_intf.apb_monitor_cb.paddr <= 255));
      //$display("======================i este %d==============", i);
      if(i < burst.burst_size)
      begin
      burst.data_bytes[i] = apb_intf.apb_monitor_cb.pwdata;
      $display(" %0d : APB_Monitor : Data byte %d added to burst",$time, burst.data_bytes[i]);
      i = i + 1;
      end
      
      else
      
      begin
      
      mon2scb.put(burst);
      $display("%0d : APB_Monitor :  Burst data from APB send to Scoreboard via mailbox", $time);
      
      burst = new();
      burst.burst_size = max_burst_size_reg_copy;
      burst.data_bytes = new  [max_burst_size_reg_copy];
      i = 0;
      
      burst.data_bytes[i] = apb_intf.apb_monitor_cb.pwdata;
      $display(" %0d : APB_Monitor : Data byte %d added to burst",$time, burst.data_bytes[i]);
      i = i + 1;     
      
      end
       


end

endtask : start

endclass : APB_Monitor

`endif