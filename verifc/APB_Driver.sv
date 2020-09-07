//------------------------------------------------------------------------------
// S.C. EasyIC Design S.R.L.
// Proiect     : Verification of APBtoBurst
// File        : Driver.sv
// Autor       : Ciomag Andrei Daniel(CAD)
// Data        : 20.08.2020
//------------------------------------------------------------------------------
// Descriere   : Driver is class which generates the packets and then drives 
// it to the DUT input interface.
//------------------------------------------------------------------------------
// Modificari  :
// 20.08.2020 (CAD): Initial 
//------------------------------------------------------------------------------

`ifndef GUARD_APB_DRIVER
`define GUARD_APB_DRIVER

`include "register_model.sv"
`include "APB_transfer.sv"

class APB_Driver;

virtual apb_interface.APB_DRIVER apb_intf;

mailbox apb_transfer_mailbox;

function new(virtual apb_interface.APB_DRIVER apb_intf_new, mailbox apb_transfer_mailbox_new);
this.apb_intf = apb_intf_new;
this.apb_transfer_mailbox = apb_transfer_mailbox_new;
endfunction : new

//------------------------------------------------------------------------------------------------------------
// CFG TASK
//------------------------------------------------------------------------------------------------------------
                                                                                        
task cfg();

$display(" %0d : APB_Driver : cfg() task", $time);

wait(apb_intf.apb_driver_cb.idle);

if(current_transaction == WRITE_TRANSACTION)
begin
APB_transfer length_reg_rcv, max_burst_size_reg_rcv;
$display(" %0d : APB_Driver : Configuration task of APB_Driver",$time);
//getting the length register configuration via mailbox
apb_transfer_mailbox.get(length_reg_rcv);
$display(" %0d : APB_Driver : Getting the Length Register Configuration", $time);
length_reg_rcv.display();
drive_transfer(length_reg_rcv);
//getting the max burst size register configuration via mailbox
apb_transfer_mailbox.get(max_burst_size_reg_rcv);
$display(" %0d : APB_Driver : Getting the Max Burst Size Register Configuration", $time);
max_burst_size_reg_rcv.display();
drive_transfer(max_burst_size_reg_rcv);
end

else if(current_transaction == READ_TRANSACTION)
begin

APB_transfer length_reg_rcv, max_burst_size_reg_rcv, start_reg_rcv;
$display(" %0d : APB_Driver : Configuration task of APB_Driver",$time);
//getting the length register configuration via mailbox
apb_transfer_mailbox.get(length_reg_rcv);
$display(" %0d : APB_Driver : Getting the Length Register Configuration", $time);
length_reg_rcv.display();
drive_transfer(length_reg_rcv);
//getting the max burst size register configuration via mailbox
apb_transfer_mailbox.get(max_burst_size_reg_rcv);
$display(" %0d : APB_Driver : Getting the Max Burst Size Register Configuration", $time);
max_burst_size_reg_rcv.display();
drive_transfer(max_burst_size_reg_rcv);
//getting the start register configuration via apb_transfer_mailbox
apb_transfer_mailbox.get(start_reg_rcv);
$display(" %0d : APB_Driver : Getting the Start Register Configuration", $time);
start_reg_rcv.display();
drive_transfer(start_reg_rcv);
this.apb_intf.apb_driver_cb.pwrite <= 0;
end

endtask : cfg

//------------------------------------------------------------------------------------------------------------
// START TASK
//------------------------------------------------------------------------------------------------------------

task start();
APB_transfer apbt_rcv;
$display(" %0d : APB_Driver : Start task to drive the data bytes", $time);

//forever begin
//if the current transaction is a WRITE_TRANSACTION
if(current_transaction == WRITE_TRANSACTION)
begin
repeat (length_reg_copy + 1) begin
apb_transfer_mailbox.get(apbt_rcv);
apbt_rcv.display();
drive_transfer(apbt_rcv);
$display(" %0d : APB_Driver : Drive a Write transfer to DUT", $time);
@(posedge apb_intf.clk);
end
end
//if the current transaction is a READ_TRANSACTION
else if (current_transaction == READ_TRANSACTION)
begin
repeat (length_reg_copy) begin
wait(apb_intf.apb_driver_cb.apb_rd_done);
apb_transfer_mailbox.get(apbt_rcv);
apbt_rcv.display();
drive_transfer(apbt_rcv);
$display(" %0d : APB_Driver : Drive a READ transfer to DUT", $time);
@(posedge apb_intf.clk);
end
end
//end

endtask : start


virtual protected task drive_transfer(APB_transfer apbt);
this.apb_intf.apb_driver_cb.paddr   <= apbt.paddr;
this.apb_intf.apb_driver_cb.pwdata  <= apbt.pwdata;
this.apb_intf.apb_driver_cb.pwrite  <= apbt.pwrite;
this.apb_intf.apb_driver_cb.psel    <= 1;
@(posedge apb_intf.clk);
this.apb_intf.apb_driver_cb.penable <= 1;
@(posedge apb_intf.clk);
this.apb_intf.apb_driver_cb.psel    <= 0;
this.apb_intf.apb_driver_cb.penable <= 0;
endtask : drive_transfer

endclass : APB_Driver

`endif

