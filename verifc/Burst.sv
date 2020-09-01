`ifndef GUARD_BURST
`define GUARD_BURST

class Burst;

rand bit [7:0] data_bytes [];
bit [7:0] burst_size;

constraint burst_size_c { data_bytes.size == burst_size ;} 

virtual function bit compare(Burst burst);
compare = 1;
if(burst == null)
begin
$display(" **ERROR** : Burst - Compare : received a null object ");
compare = 0;
end

else

begin
if(burst.burst_size !== this.burst_size)
begin
$display(" **ERROR** : Burst - Compare : burst_size did not match %d,%d", burst.burst_size,this.burst_size);
compare = 0;
end

foreach(this.data_bytes[i])
if(burst.data_bytes[i] !== this.data_bytes[i])
begin
$display(" **ERROR** : Burst - Compare : Data[%d] did not match %d,%d",i, burst.data_bytes[i], this.data_bytes[i]);
compare = 0;
end
end
endfunction : compare


endclass : Burst

`endif