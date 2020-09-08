`ifndef GUARD_REGMODEL
`define GUARD_REGMODEL

bit [7:0] length_reg_copy = 0;
bit [7:0] max_burst_size_reg_copy= 0;

typedef enum {READ_TRANSACTION, WRITE_TRANSACTION} transaction_e;
//transaction type
transaction_e current_transaction;
//scoreboard controller
int start_scoreboard = 1;
//error counter
int errors = 0;
//when bm_driver stopped
int bm_driver_stop = 0;

`endif
