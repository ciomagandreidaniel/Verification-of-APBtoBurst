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


task cfg();
APB_transfer length_reg_rcv, max_burst_size_reg_rcv;
$display(" %0d : APB_Driver : Configuration task of APB_Driver",$time);
apb_transfer_mailbox.get(length_reg_rcv);
$display(" %0d : APB_Driver : Getting the Length Register Configuration", $time);
length_reg_rcv.display();
drive_transfer(length_reg_rcv);

apb_transfer_mailbox.get(max_burst_size_reg_rcv);
$display(" %0d : APB_Driver : Getting the Max Burst Size Register Configuration", $time);
max_burst_size_reg_rcv.display();
drive_transfer(max_burst_size_reg_rcv);

endtask : cfg

task start();

APB_transfer apbt_rcv;
$display(" %0d : APB_Driver : Start task to drive the data bytes", $time);

forever begin

apb_transfer_mailbox.get(apbt_rcv);
apbt_rcv.display();
drive_transfer(apbt_rcv);
if(current_transaction == READ_TRANSACTION)
begin
$display(" %0d : APB_Driver : This is a read transaction++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++", $time);
this.apb_intf.apb_driver_cb.pwrite <= 0;
end
else
begin
$display(" %0d : APB_Driver : This is not read transaction++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++", $time);
end 
@(posedge apb_intf.clk);
end

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

