`ifndef GUARD_APB_GENERATOR
`define GUARD_APB_GENERATOR

`include "register_model.sv"
`include "APB_transfer.sv"

class APB_Generator;

mailbox apb_transfer_mailbox;

function new(mailbox apb_transfer_mailbox_new);
this.apb_transfer_mailbox = apb_transfer_mailbox_new;
endfunction : new

//-------------------------------------------------------------------------------------------------------------
// CFG TASK
//-------------------------------------------------------------------------------------------------------------

//this is the configuration task of the APB_Generator, this task generates the configurations of the DUT
task cfg();

//APB_transfers for the registers

APB_transfer length_reg;
APB_transfer max_burst_size_reg;
APB_transfer start_reg;

$display(" %0d : APB_Generator : cfg() task", $time);

//If the current transaction is a WRITE_TRANSACTION

if(current_transaction == WRITE_TRANSACTION)
begin
length_reg = new();
max_burst_size_reg = new ();

length_reg.cfg(WRITE,256);
max_burst_size_reg.cfg(WRITE,257);
if(length_reg.randomize())
begin
$display (" %0d : APB_Generator Config Length Register : Randomization Successes full. ",$time);

length_reg_copy = length_reg.pwdata;
//send the length register configuration via mailbox
apb_transfer_mailbox.put(length_reg);
$display(" %0d : APB_Generator put the Length Register configuration in the mailbox.", $time);
end

if(max_burst_size_reg.randomize() with { max_burst_size_reg.pwdata <= 32; max_burst_size_reg.pwdata >=1; })
begin
$display (" %0d : APB_Generator Config Max Burst Size Register : Randomization Successes full. ",$time);

max_burst_size_reg_copy = max_burst_size_reg.pwdata;
//send the max burst size register configuration via mailbox
apb_transfer_mailbox.put(max_burst_size_reg);
$display(" %0d : APB_Generator put the Max Burst Size Register configuration in the mailbox.", $time);
end
end

//IF the current transaction is a READ_TRANSACTION

else if(current_transaction == READ_TRANSACTION)
begin

length_reg = new();
max_burst_size_reg = new ();
start_reg  = new();

length_reg.cfg(WRITE,256);
max_burst_size_reg.cfg(WRITE,257);
start_reg.cfg(WRITE,258);

if(length_reg.randomize())
begin
$display (" %0d : APB_Generator : Config Length Register : Randomization Successes full. ",$time);

length_reg_copy = length_reg.pwdata;
//send the length register configuration via mailbox
apb_transfer_mailbox.put(length_reg);
$display(" %0d : APB_Generator : put the Length Register configuration in the mailbox.", $time);
end

if(max_burst_size_reg.randomize() with { max_burst_size_reg.pwdata <= 32; max_burst_size_reg.pwdata >=1; })
begin
$display (" %0d : APB_Generator : Config Max Burst Size Register : Randomization Successes full. ",$time);

max_burst_size_reg_copy = max_burst_size_reg.pwdata;
//send the max burst size register configuration via mailbox
apb_transfer_mailbox.put(max_burst_size_reg);
$display(" %0d : APB_Generator : put the Length Register configuration in the mailbox.", $time);
end

start_reg.pwdata = 255;
//send the start register configuration via mailbox
apb_transfer_mailbox.put(start_reg);
$display (" %0d : APB_Generator : Put Start Register configuration in the mailbox  ",$time);

end
endtask : cfg


//-------------------------------------------------------------------------------------------------------------
// START TASK
//-------------------------------------------------------------------------------------------------------------

task start();

//if the current transaction is a WRITE_TRANSACTION 

if( current_transaction == WRITE_TRANSACTION)
begin

APB_transfer apbt_data;
APB_transfer apbt_start;

int data_address_increment = 0;
$display(" %0d : APB_Generator : Start Task ", $time);
$display(" %0d : APB_Generator : Generating the data bytes", $time);

repeat(length_reg_copy)
begin
apbt_data = new();

if(apbt_data.randomize())

 begin
 $display (" %0d : APB_Generator : Data Randomization successesful. ",$time);
 apbt_data.cfg(WRITE, data_address_increment);
//send data byte to driver via mailbox 
 apb_transfer_mailbox.put(apbt_data);
 $display (" %0d : APB_Generator : Put write data type APB_transfer in the mailbox",$time); 
 data_address_increment = data_address_increment +1;
 end

end

begin
apbt_start = new ();


$display (" %0d : APB_Generator : Put Start Register configuration in the mailbox  ",$time);
apbt_start.cfg(WRITE,258);
apbt_start.pwdata = 255;
//send the start register configuration via mailbox
apb_transfer_mailbox.put(apbt_start);

end

end

//if the current transaction is a READ_TRANSACTION

else if (current_transaction == READ_TRANSACTION)

begin
APB_transfer apbt_read;

for( int i = 0;i<length_reg_copy;i++)
begin
apbt_read = new();
apbt_read.cfg(READ,i);
//send read commands for reading the register bank
apb_transfer_mailbox.put(apbt_read);
$display(" %0d : APB_Generator : Put read data type APB_transfer in the mailbox", $time);
end

end
 
endtask : start



endclass : APB_Generator

`endif