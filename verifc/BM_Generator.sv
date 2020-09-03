`ifndef GUARD_BM_GENERATOR
`define GUARD_BM_GENERATOR

`include "register_model.sv"

class BM_Generator;
mailbox bm_mailbox_generator;
function new(mailbox bm_mailbox_generator_new);
this.bm_mailbox_generator = bm_mailbox_generator_new;
endfunction : new

task start();

if(current_transaction == READ_TRANSACTION)
begin
bit [7:0] data_byte;
$display(" %0d : BM_Generator : Start task", $time);
repeat(length_reg_copy)
begin
data_byte = $random;
bm_mailbox_generator.put(data_byte);
$display(" %0d : BM_Generator : The data byte generated is %0d", $time, data_byte);
end
end
endtask : start

endclass : BM_Generator
`endif