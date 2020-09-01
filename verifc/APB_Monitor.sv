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
int j = 0;
int i = 0;
int normal_bursts  = length_reg_copy / max_burst_size_reg_copy;
int off_burst_size = length_reg_copy % max_burst_size_reg_copy;

burst = new();



burst.burst_size = max_burst_size_reg_copy;
burst.data_bytes = new  [1];

$display(" %0d : APB_Monitor :  Start task", $time);
$display(" %0d : APB_Monitor :  The number of Normal Bursts  is %0d", $time,normal_bursts);
$display(" %0d : APB_Monitor :  Last Burst size  is %0d", $time,off_burst_size);  

forever begin

      
      if (j < normal_bursts) begin
      if(i < burst.burst_size)
      begin
      
      @(posedge apb_intf.clk);
      wait(apb_intf.apb_monitor_cb.pwrite  & 
      apb_intf.apb_monitor_cb.psel    & 
      apb_intf.apb_monitor_cb.penable &
      (apb_intf.apb_monitor_cb.paddr <= 255));
      
      
      $display("======================i este %d==============", i);
      
      burst.data_bytes[i] = apb_intf.apb_monitor_cb.pwdata;
      burst.data_bytes    = new [burst.data_bytes.size() + 1] (burst.data_bytes);
      $display(" %0d : APB_Monitor : Data byte %d added to burst",$time, burst.data_bytes[i]);
      i = i + 1;
      end
      
      else
      
      begin
      
      
      mon2scb.put(burst);
      j = j + 1;
      $display("======================finalul burstu-ului cu numarul(j) %d==============", j);
      $display("%0d : APB_Monitor :  Burst data from APB send to Scoreboard via mailbox", $time);
      
      @(posedge apb_intf.clk);
      wait(apb_intf.apb_monitor_cb.pwrite  & 
      apb_intf.apb_monitor_cb.psel    & 
      apb_intf.apb_monitor_cb.penable &
      (apb_intf.apb_monitor_cb.paddr <= 255));  
      
      burst = new();
      burst.burst_size = max_burst_size_reg_copy;
      burst.data_bytes = new  [1];
      i = 0;
      $display("======================i este %d==============", i);
      burst.data_bytes[i] = apb_intf.apb_monitor_cb.pwdata;
      burst.data_bytes    = new [burst.data_bytes.size() + 1] (burst.data_bytes);
      $display(" %0d : APB_Monitor : Data byte %d added to burst",$time, burst.data_bytes[i]);
      i = i + 1;     
      end
      end
      
      else
       
      begin
      if(i < off_burst_size)
      begin
      
      @(posedge apb_intf.clk);
      wait(apb_intf.apb_monitor_cb.pwrite  & 
      apb_intf.apb_monitor_cb.psel    & 
      apb_intf.apb_monitor_cb.penable &
      (apb_intf.apb_monitor_cb.paddr <= 255));
      
      $display("======================i este %d==============", i);      
      burst.data_bytes[i] = apb_intf.apb_monitor_cb.pwdata;
      burst.data_bytes    = new [burst.data_bytes.size() + 1] (burst.data_bytes);
      
      $display(" %0d : APB_Monitor : Data byte %d added to burst",$time, burst.data_bytes[i]);
      i = i + 1;
      end
      
      else if(i == off_burst_size) 
      begin
      burst.burst_size = burst.data_bytes.size() - 1;
      $display(" %0d : APB_Monitor : Last Burst size set to %d", $time, burst.burst_size);
      mon2scb.put(burst);
      $display("%0d : APB_Monitor :  Burst data from APB send to Scoreboard via mailbox", $time);
      i = 0;
      end 
      end
       


end

endtask : start

endclass : APB_Monitor

`endif