`ifndef GUARD_SCOREBOARD
`define GUARD_SCOREBOARD

`include "register_model.sv"
`include "Burst.sv"
`include "coverage.sv"
class Scoreboard;

mailbox fromapb2sb;
mailbox frombm2sb;

coverage cov = new();

//constructor
function new(mailbox fromapb2sb_new, mailbox frombm2sb_new);
this.fromapb2sb = fromapb2sb_new;
this.frombm2sb  = frombm2sb_new;
endfunction : new

//---------------------------------------------------------------------------------------------
// START TASK
//---------------------------------------------------------------------------------------------

task start();

//if current transaction is WRITE TRANSACTION

$display(" %0d : Scoreboard : Start Task start_scoreboard is %0d", $time, start_scoreboard);

if(current_transaction == WRITE_TRANSACTION)
begin
Burst burst_rcv, burst_exp;

while(start_scoreboard) begin

frombm2sb.get(burst_rcv);
$display(" %0d : Scoreboard : Scoreboard received a data burst from receiver ",$time);
fromapb2sb.get(burst_exp);
if(burst_rcv.compare(burst_exp))
begin
$display(" %0d : Scoreboard : Burst Matched ",$time);
cov.sample_burst_size(burst_rcv);
end
else
begin
$display(" %0d : Scoreboard : ERROR!!!!!!!!!!!!!",$time);
errors = errors +1;
end
end
$display(" %0d : Scoreboard : Closed! - WRITE_TRANSACTION", $time);
end

//if current transaction is READ_TRANSACTION
else if (current_transaction == READ_TRANSACTION)
begin

bit [7:0] data_to_read_rcv;
bit [7:0] data_to_read_exp;

while(start_scoreboard) begin
fromapb2sb.get(data_to_read_rcv);
$display(" %0d : Scoreboard : Scoreboard received a data byte from receiver ",$time);
frombm2sb.get(data_to_read_exp);
if(data_to_read_exp !== data_to_read_rcv)
begin
$display(" %0d : Scoreboard : ERROR!!!!!!!!!!!!!",$time);
$display(" %0d : Scoreboard : Data byte received is %0d and the data byte expected is %0d",$time, data_to_read_rcv, data_to_read_exp);
errors = errors +1;
end
else
begin
$display(" %0d : Scoreboard : Burst Matched ",$time);
end
end
$display(" %0d : Scoreboard : Closed! - READ_TRANSACTION", $time);
end

endtask : start

endclass : Scoreboard

`endif