//------------------------------------------------------------------------------
// S.C. EasyIC Design S.R.L.
// Proiect     : Verification of APBtoBurst
// File        : interface.sv
// Autor       : Ciomag Andrei Daniel(CAD)
// Data        : 20.08.2020
//------------------------------------------------------------------------------
// Descriere   : This file contains the SystemVerilog Interfaces used for
// the verification of the APBtoBurst RTL code
//------------------------------------------------------------------------------
// Modificari  :
// 20.08.2020 (CAD): Initial 
//------------------------------------------------------------------------------

`ifndef GUARD_INTERFACE
`define GUARD_INTERFACE

//------------------------------------------------------------------------------
// Interface declaration for the APB
//------------------------------------------------------------------------------

interface apb_interface (input bit clk, rst_n);
 //declaring the signals
 logic [8:0]    paddr        ;
 logic          psel         ;
 logic          penable      ;
 logic          pwrite       ;
 logic [7:0]    pwdata       ;
 logic [7:0]    prdata       ;
 logic          plsverr      ;
 logic          apb_rd_done  ;
 logic          idle         ;
 
 //apb driver clocking block
 clocking apb_driver_cb @(posedge clk);
  default input #1 output #1;
  output paddr;
  output psel;
  output penable;
  output pwrite;
  output pwdata;
  input  prdata;
  input  plsverr;
  input  apb_rd_done;
  input  idle;
 endclocking : apb_driver_cb
 
 //apb monitor clocking block
 clocking apb_monitor_cb @(posedge clk);
  default input #1 output #1;
  input  paddr;
  input  psel;
  input  penable;
  input  pwrite;
  input  pwdata;
  input  prdata;
  input  plsverr;
  input  apb_rd_done;
  input  idle;
 endclocking : apb_monitor_cb
 
 //apb driver modport
 modport APB_DRIVER   (clocking apb_driver_cb, input clk, rst_n);
 
 //apb monitor modport
 modport APB_MONITOR  (clocking apb_monitor_cb, input clk, rst_n);
 
//------------------------------------------------------------------------------
//APB Assertions

  // psel without penable (first clock of cycle)
  sequence APB_PHASE_1;
    psel && !penable;
  endsequence

  // psel with penable (second clock of cycle)
  sequence APB_PHASE_2;
   psel && penable;
  endsequence

  // A complete bus cycle
  sequence APB_CYCLE;
    APB_PHASE_1 ##1 APB_PHASE_2;
  endsequence

  
  //Safety properties

  property APB_NO_PENABLE_OUTSIDE_CYCLE2;
    @(posedge clk) (penable |-> $stable(psel) ##1 (!penable));
  endproperty

 property APB_WRITE_AND_ADDR_STABLE;
    @(posedge clk) ((psel && penable) |-> $stable({pwrite, paddr}));
  endproperty
  
  property APB_WRITE_DATA_STABLE;
    @(posedge clk) ((penable && pwrite) |-> $stable(pwdata));
  endproperty
  
  property APB_PRDATA_NO_X_STATE;
    @(posedge clk) ( ((^prdata) !== 1'bx) |->
                      ( (!pwrite) throughout APB_CYCLE)
                    );
  endproperty
  
  property APB_PLSVERR;
    @(posedge clk) (plsverr |-> APB_PHASE_2);
  endproperty
  
  // Assertions to check the safety properties

  xstate_apb_check             : assert property (APB_PRDATA_NO_X_STATE)
                                 else $warning("*WARNING* prdata is x!!!!!!!!!!!!!!!!!!!!");
  apb_penable_psel_check       : assert property (APB_NO_PENABLE_OUTSIDE_CYCLE2)
                                 else $warning("*WARNING* peanble is HIGH outside APB cycle!!!!!!!!!!!!");
  apb_stable_signals_check_1   : assert property (APB_WRITE_AND_ADDR_STABLE)
                                 else $warning("*WARNING* pwrite or paddr not stable!!!!!!!!!!!!!!!!!");
  apb_stable_signals_check_2   : assert property (APB_WRITE_DATA_STABLE)
                                 else $warning("*WARNING* pwdata not stable!!!!!!!!!!!!!!!!!!");
  apb_plsverr_check            : assert property (APB_PLSVERR)
                                 else $warning("*WARNING* wrong assertion on plsverr!!!!!!!!!!!");

     

endinterface : apb_interface


//------------------------------------------------------------------------------
// Interface declaration for the Burst Master
//------------------------------------------------------------------------------

interface bm_interface(input bit clk, rst_n);
 //declaring the signals
 logic          burst_valid    ;
 logic          burst_ready    ;
 logic [7:0]    data_burst_in  ;
 logic          burst_last     ;
 logic [7:0]    data_burst_out ;
 logic [7:0]    db_length      ;
 logic          last           ;
 logic          db_ready       ;
 logic          db_valid       ;
 
 //bm driver clocking block
 clocking bm_driver_cb @(posedge clk);
  default input #1 output #1;
  output burst_valid;
  output burst_ready;
  output data_burst_in;
  output burst_last;
  input  data_burst_out;
  input  db_length;
  input  last;
  input  db_ready;
  input  db_valid;
 endclocking : bm_driver_cb
 
 //bm monitor clocking block
 clocking bm_monitor_cb @(posedge clk);
  default input #1 output #1;
  input  burst_valid;
  input  burst_ready;
  input  data_burst_in;
  input  burst_last;
  input  data_burst_out;
  input  db_length;
  input  last;
  input  db_ready;
  input  db_valid;
 endclocking : bm_monitor_cb
 
 //bm driver modport
 modport BM_DRIVER  (clocking bm_driver_cb, input clk, rst_n);
 
 //bm monitor modport
 modport BM_MONITOR (clocking bm_monitor_cb, input clk, rst_n);
 
//assertions.......

property DATA_ON_BURST_READY; 
 @(posedge clk) ((!burst_ready) |-> $stable(data_burst_out)); 
endproperty

property X_STATE_ON_OUTPUTS;
 @(posedge clk) ((^{data_burst_out, db_length,last, db_ready, db_valid }) !== 1'bx); 
endproperty

burs_ready_check     : assert property (DATA_ON_BURST_READY)
                       else $warning("*WARNING* data_burst_out not stable when burst_ready is LOW!!!!");

xstate_bm_check      : assert property (X_STATE_ON_OUTPUTS)
                       else $warning("*WARNING* bm_interface outputs are in x state!!!!!!!!!"); 

endinterface : bm_interface

`endif
 
