`ifndef GUARD_BM_GENERATOR
`define GUARD_BM_GENERATOR

`include "register_model.sv"
`include "Burst.sv"

class BM_Generator;

mailbox bm_mailbox_generator;

function new (mailbox bm_mailbox_generator_new);
this.bm_mailbox_generator = bm_mailbox_generator_new;
endfunction : new

task start();

int i = 0;

int gen_burst_size = 8;

int number_of_normal_bursts = length_reg_copy / gen_burst_size;
int last_off_burst          = length_reg_copy % gen_burst_size; 

Burst burst;

$display(" %0d : BM_Generator : Start task", $time);

repeat(number_of_normal_bursts)
begin

burst = new();
 
if(i < number_of_normal_bursts)
 begin
  burst.burst_size = gen_burst_size;
  if(burst.randomize())
   begin
   
   bm_mailbox_generator.put(burst);
   $display(" %0d : BM_Generator : Burst generated and sent via mailbox", $time);
   
   end
  else
  begin
  $display(" %0d : BM_Generator : Randomization of Burst failed!", $time);
  end
 end

end

burst = new();
burst.burst_size = last_off_burst;

if(burst.randomize())
begin
   
bm_mailbox_generator.put(burst);
$display(" %0d : BM_Generator : Burst generated and sent via mailbox", $time);
   
end
else
begin
$display(" %0d : BM_Generator : Randomization of Burst failed!", $time);
end


endtask : start

endclass : BM_Generator

`endif