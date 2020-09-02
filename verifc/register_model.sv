`ifndef GUARD_REGMODEL
`define GUARD_REGMODEL

bit [7:0] length_reg_copy = 0;
bit [7:0] max_burst_size_reg_copy= 0;

typedef enum {READ_TRANSACTION, WRITE_TRANSACTION} transaction_e;

transaction_e current_transaction;

int errors = 0;

`endif
