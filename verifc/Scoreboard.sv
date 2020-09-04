`ifndef GUARD_SCOREBOARD
`define GUARD_SCOREBOARD

`include "register_model.sv"
`include "Burst.sv"

class Scoreboard;

mailbox fromapb2sb;
mailbox frombm2sb;

function new(mailbox fromapb2sb_new, mailbox frombm2sb_new);
this.fromapb2sb = fromapb2sb_new;
this.frombm2sb  = frombm2sb_new;
endfunction : new

task start();
//if current transaction is WRITE TRANSACTION
if(current_transaction == WRITE_TRANSACTION)
begin
Burst burst_rcv, burst_exp;

forever begin

frombm2sb.get(burst_rcv);
$display(" %0d : Scoreboard : Scoreboard received a data burst from receiver ",$time);
fromapb2sb.get(burst_exp);
if(burst_rcv.compare(burst_exp))
$display(" %0d : Scoreboard : Burst Matched ",$time);
else
begin
$display(" %0d : Scoreboard : ERROR!!!!!!!!!!!!!",$time);
errors = errors +1;
end
end
end

//if current transaction is READ_TRANSACTION
else if (current_transaction == READ_TRANSACTION)
begin

bit [7:0] data_to_read_rcv;
bit [7:0] data_to_read_exp;

forever begin
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

end

endtask : start

endclass : Scoreboard

`endif