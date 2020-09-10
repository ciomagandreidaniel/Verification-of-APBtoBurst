`ifndef GUARD_REGMODEL
`define GUARD_REGMODEL

//-------------------------------------------------------------------------|
// THIS FAIL CONTAINS THE REGISERS CONFIGURATION AND SOME GLOBAL VARIABLES |
//-------------------------------------------------------------------------|

//-----------------------------------------------------------------
// REGISTERS CONFIGURATION
//-----------------------------------------------------------------

//length register
bit [7:0] length_reg_copy = 0;
//max burst size register
bit [7:0] max_burst_size_reg_copy= 0;

//-----------------------------------------------------------------
// TYPEDEF ENUM FOR KNOWING THE CURRENT TRANSACTION
//-----------------------------------------------------------------

typedef enum {READ_TRANSACTION, WRITE_TRANSACTION} transaction_e;
//transaction type
transaction_e current_transaction;
//scoreboard controller

//-----------------------------------------------------------------
// GLOBAL VARIABLE FOR CONTROLLING THE SCOREBOARD
//-----------------------------------------------------------------

int start_scoreboard = 1;

//-----------------------------------------------------------------
// ERROR COUNTER
//-----------------------------------------------------------------

int errors = 0; 

//-----------------------------------------------------------------
// APB_RD_DONE ERROR HANDLER
//-----------------------------------------------------------------

int bm_driver_stop = 0;

`endif
