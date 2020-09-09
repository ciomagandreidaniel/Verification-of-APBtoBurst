//------------------------------------------------------------------------------
// S.C. EasyIC Design S.R.L.
// Proiect     : Verification of APBtoBurst
// File        : Environment.sv
// Autor       : Ciomag Andrei Daniel(CAD)
// Data        : 21.08.2020
//------------------------------------------------------------------------------
// Descriere   : The class is a base class used to implement verification 
// environments. All methods are declared as virtual methods. In environment 
// class, we will formalize the simulation steps using virtual methods. The 
// methods are used to control the execution of the simulation.
//------------------------------------------------------------------------------
// Modificari  :
// 21.08.2020 (CAD): Initial 
//------------------------------------------------------------------------------

`ifndef GUARD_ENV
`define GUARD_ENV
 
`include "register_model.sv"
`include "APB_Agent.sv"
`include "BM_Agent.sv"
`include "Scoreboard.sv"

class Environment;

virtual apb_interface.APB_DRIVER apb_driver_intf;
virtual apb_interface.APB_MONITOR apb_monitor_intf;
virtual bm_interface.BM_DRIVER bm_driver_intf;
virtual bm_interface.BM_MONITOR bm_monitor_intf;

Scoreboard sb;

APB_Agent apb_agent;

BM_Agent bm_agent;

mailbox bmmailbox;

mailbox apbmailbox;

function new(
virtual apb_interface.APB_DRIVER apb_driver_intf_new,
virtual apb_interface.APB_MONITOR apb_monitor_intf_new,
virtual bm_interface.BM_DRIVER bm_driver_intf_new,
virtual bm_interface.BM_MONITOR bm_monitor_intf_new);

this.apb_driver_intf = apb_driver_intf_new;
this.apb_monitor_intf = apb_monitor_intf_new;
this.bm_driver_intf = bm_driver_intf_new;
this.bm_monitor_intf = bm_monitor_intf_new;


$display(" %0d : Environment : created env object", $time);
endfunction : new

//---------------------------------------------------------------------------------------
// BUILD FUNCTION
//---------------------------------------------------------------------------------------

function void build();
$display(" %0d : Environment : start of build() method",$time);

apbmailbox = new();
apb_agent = new(apb_driver_intf,apb_monitor_intf,apbmailbox);

bmmailbox = new();
bm_agent = new(bm_driver_intf,bm_monitor_intf, bmmailbox);

sb = new(apbmailbox, bmmailbox);


$display(" %0d : Environment : end of build() method",$time);
endfunction :build

//---------------------------------------------------------------------------------------
// RESET TASK
//---------------------------------------------------------------------------------------

task reset();
$display(" %0d : Environment : start of reset() method",$time);
//Drive all DUT inputs to a known state
this.apb_driver_intf.apb_driver_cb.paddr       <= 0;                 
this.apb_driver_intf.apb_driver_cb.psel        <= 0;
this.apb_driver_intf.apb_driver_cb.penable     <= 0;             
this.apb_driver_intf.apb_driver_cb.pwrite      <= 0;             
this.apb_driver_intf.apb_driver_cb.pwdata      <= 0;

this.bm_driver_intf.bm_driver_cb.burst_valid   <= 0;
this.bm_driver_intf.bm_driver_cb.burst_ready   <= 1;
this.bm_driver_intf.bm_driver_cb.data_burst_in <= 0;
this.bm_driver_intf.bm_driver_cb.burst_last    <= 0;

@(posedge bm_driver_intf.clk);
@(posedge bm_driver_intf.clk);
@(posedge bm_driver_intf.clk);
                
$display(" %0d : Environment : end of reset() method",$time);
endtask : reset

//---------------------------------------------------------------------------------------
// CFG_DUT TASK
//---------------------------------------------------------------------------------------

task cfg_dut();
$display(" %0d : Environment : start of cfg_dut() method",$time);

std::randomize(current_transaction); 
//current_transaction = WRITE_TRANSACTION;
//current_transaction = READ_TRANSACTION;

//becouse of the delay of apb_rd_done
bm_driver_stop = 0;

//starting the scoreboard
start_scoreboard = 1;
$display(" %0d : Environment : Configuration - The curent Transaction is %s", $time,current_transaction);

apb_agent.cfg();

$display(" %0d : Environment : end of cfg_dut() method",$time);
endtask : cfg_dut

//---------------------------------------------------------------------------------------
// START_TRANSACTION TASK
//---------------------------------------------------------------------------------------

task start_transaction();
$display(" %0d : Environment : start of start_transaction() method",$time);
fork
apb_agent.start();
bm_agent.start();
sb.start();
join_any

$display(" %0d : Environment : end of start_transaction() method",$time);
endtask : start_transaction

//---------------------------------------------------------------------------------------
// START TASK (cfg, start_transaction ...)
//---------------------------------------------------------------------------------------

task start();
$display(" %0d : Environment : start of start() method",$time);
repeat(150) begin
cfg_dut();
start_transaction();
wait_for_end();
report();
end
$display(" %0d : Environment : end of start() method",$time);
endtask : start

//---------------------------------------------------------------------------------------
// WAIT_FOR_END	TASK
//---------------------------------------------------------------------------------------

task wait_for_end();
$display(" %0d : Environment : start of wait_for_end() method",$time);
//#30000
wait(start_scoreboard == 0);
@(posedge apb_driver_intf.clk);
@(posedge apb_driver_intf.clk);
$display(" %0d : Environment : end of wait_for_end() method",$time);
endtask : wait_for_end


//---------------------------------------------------------------------------------------
// RUN TASK
//---------------------------------------------------------------------------------------

task run();
$display(" %0d : Environment : start of run() method",$time);
build();
reset();
start();
$display(" %0d : Environment : end of run() method",$time);
$stop;
endtask : run

//---------------------------------------------------------------------------------------
// REPORT TASK
//---------------------------------------------------------------------------------------

task report();

$display(" %0d : Error Report : The number of errors is %0d", $time, errors);

if(apbmailbox.num() !== 0)
begin
$display(" %0d : Error Report : The APB_Monitor Mailbox has %0d  messages", $time,apbmailbox.num()); 
apbmailbox = new();
end

if(bmmailbox.num() !== 0)
begin
$display(" %0d : Error Report : The BM_Monitor Mailbox has %0d  messages", $time,bmmailbox.num()); 
bmmailbox = new();
end
endtask : report

endclass

`endif
