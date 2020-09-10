//------------------------------------------------------------------------------
// S.C. EasyIC Design S.R.L.
// Proiect     : Verification of APBtoBurst
// File        : testcase.sv
// Autor       : Ciomag Andrei Daniel(CAD)
// Data        : 20.08.2020
//------------------------------------------------------------------------------
// Descriere   : This testcase is a program block which peovides an entry point
// for the test and creates a scope that encapsulates program-wide data.
//------------------------------------------------------------------------------
// Modificari  :
// 20.08.2020 (CAD): Initial 
//------------------------------------------------------------------------------

`ifndef GUARD_TESTCASE
`define GUARD_TESTCASE

`include "Environment.sv"

program testcase(
 apb_interface.APB_DRIVER apb_driver_intf,
 apb_interface.APB_MONITOR apb_monitor_intf,
 bm_interface.BM_DRIVER bm_driver_intf,
 bm_interface.BM_MONITOR bm_monitor_intf
);

Environment env;

initial begin
$display("TIME: %0d ------------------------- Start of testcase ------------------------- ",$time);

env = new(apb_driver_intf, apb_monitor_intf, bm_driver_intf, bm_monitor_intf);
env.run();

#1000;
end

final
$display("TIME: %0d -------------------------- End of testcase -------------------------- ",$time);
endprogram : testcase
`endif


