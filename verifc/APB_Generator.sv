`ifndef GUARD_APB_GENERATOR
`define GUARD_APB_GENERATOR

`include "register_model.sv"
`include "APB_transfer.sv"

class APB_Generator;

mailbox apb_transfer_mailbox;

function new(mailbox apb_transfer_mailbox_new);
this.apb_transfer_mailbox = apb_transfer_mailbox_new;
endfunction : new



task cfg();

APB_transfer length_reg;
APB_transfer max_burst_size_reg;

length_reg = new();
max_burst_size_reg = new ();

length_reg.cfg(WRITE,256);
max_burst_size_reg.cfg(WRITE,257);
if(length_reg.randomize())
begin
$display (" %0d : APB_Generator Config Length Register : Randomization Successes full. ",$time);

length_reg_copy = length_reg.pwdata;
apb_transfer_mailbox.put(length_reg);
$display(" %0d : APB_Generator put the Length Register configuration in the mailbox.", $time);
end

if(max_burst_size_reg.randomize() with { max_burst_size_reg.pwdata <= 32; max_burst_size_reg.pwdata >=1; })
begin
$display (" %0d : APB_Generator Config Max Burst Size Register : Randomization Successes full. ",$time);

max_burst_size_reg_copy = max_burst_size_reg.pwdata;
apb_transfer_mailbox.put(max_burst_size_reg);
$display(" %0d : APB_Generator put the Length Register configuration in the mailbox.", $time);
end
endtask : cfg

task start(transaction_e trans);

current_transaction = trans; 

if( trans == WRITE_TRANSACTION)
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
 apb_transfer_mailbox.put(apbt_data);
 $display (" %0d : APB_Generator : Put Data APB_transfer in the mailbox",$time); 
 data_address_increment = data_address_increment +1;
 end

end

begin
apbt_start = new ();

$display (" %0d : APB_Generator : Put Start Register configuration in the mailbox  ",$time);
apbt_start.cfg(WRITE,258);
apbt_start.pwdata = 255;

apb_transfer_mailbox.put(apbt_start);

end

end

else if (trans == READ_TRANSACTION)

begin
APB_transfer apbt_start;
apbt_start = new ();

$display (" %0d : APB_Generator : Put Start Register configuration in the mailbox  ",$time);
apbt_start.cfg(WRITE,258);
apbt_start.pwdata = 255;

apb_transfer_mailbox.put(apbt_start);
end
 
endtask : start



endclass : APB_Generator

`endif