`ifndef GUARD_COVERAGE
`define GUARD_COVERAGE

`include "APB_transfer.sv"
`include "Burst.sv"

class coverage;

APB_transfer apb_transfer;
Burst burst;
bit [7:0] data_from_bm;

endclass : coverage
`endif
