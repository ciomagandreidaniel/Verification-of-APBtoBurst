`ifndef GUARD_COVERAGE
`define GUARD_COVERAGE

`include "APB_transfer.sv"
`include "Burst.sv"
`include "register_model.sv"
class coverage;

APB_transfer apbt;
Burst burst;
bit [7:0] data_from_bm;
bit [7:0] db_length;

//---------------------------------------------------------
// BURST_COVERAGE COVERGROUP
//---------------------------------------------------------



covergroup burst_coverage;
burst_size : coverpoint burst.burst_size{
bins valid_size[] =  {[1:32]};
}
endgroup : burst_coverage

task sample_burst_size(Burst burst);
this.burst = burst;
burst_coverage.sample();
endtask : sample_burst_size

//---------------------------------------------------------
// APB_TRANSFER COVERGROUP
//---------------------------------------------------------

covergroup apb_transfer_coverage;
address : coverpoint apbt.paddr{
bins length_reg             = {256};
bins max_burst_size_reg     = {257};
bins start_reg              = {258};
bins data_reg[]             = {[0:255]};
}
rd_wr   : coverpoint apbt.pwrite{
bins read                   = {READ};
bins write                  = {WRITE};
}
data    : coverpoint apbt.pwdata{
//bins trans_length[] = {[1:255]} with (apbt.paddr == 256);
bins data_zero    = {0};
bins data_max     = {255};
bins data_onehot_1    = {1};
bins data_onehot_2    = {2};
bins data_onehot_4    = {4};
bins data_onehot_8    = {8};
bins data_onehot_16   = {16};
bins data_onehot_32   = {32};
bins data_onehot_64   = {64};
bins data_onehot_128  = {128};
}

endgroup : apb_transfer_coverage

task sample_apb_transfer(APB_transfer apbt);
this.apbt = apbt;
apb_transfer_coverage.sample();
endtask :sample_apb_transfer





function new();
burst_coverage = new();
apb_transfer_coverage = new();
endfunction : new
 
endclass : coverage
`endif
