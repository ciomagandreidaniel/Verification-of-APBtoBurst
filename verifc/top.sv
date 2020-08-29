//------------------------------------------------------------------------------
// S.C. EasyIC Design S.R.L.
// Proiect     : Verification of APBtoBurst
// File        : top.sv
// Autor       : Ciomag Andrei Daniel(CAD)
// Data        : 20.08.2020
//------------------------------------------------------------------------------
// Descriere   : This module is the highest scope of modules.
//------------------------------------------------------------------------------
// Modificari  :
// 20.08.2020 (CAD): Initial
// 20.08.2020 (CAD): DUT Instance
//------------------------------------------------------------------------------

`ifndef GUARD_TOP
`define GUARD_TOP


module top();

//------------------------------------------------------------------------------
// Clock Declaration and Generation
//------------------------------------------------------------------------------

bit clk;

initial
 forever #10 clk = ~clk;

//------------------------------------------------------------------------------
// Reset Declaration and Generation
//------------------------------------------------------------------------------

bit rst_n;

initial begin
 rst_n = 0;
 #40 rst_n = 1;
end

//------------------------------------------------------------------------------
// APB Interface Instance
//------------------------------------------------------------------------------

apb_interface apb_intf(clk, rst_n);

//------------------------------------------------------------------------------
// Burst Master Interface Instance
//------------------------------------------------------------------------------

bm_interface bm_intf(clk, rst_n);

//------------------------------------------------------------------------------
// Program Block Testcase program
//------------------------------------------------------------------------------

testcase TC ( apb_intf.APB_DRIVER, apb_intf.APB_MONITOR, bm_intf.BM_DRIVER, bm_intf.BM_MONITOR);

//------------------------------------------------------------------------------
// DUT instance and signal connection
//------------------------------------------------------------------------------
apbtoburst_top
apbtoburst_top_DUT(
.clk(clk),                   
.rst_n(rst_n),                 
.paddr(apb_intf.paddr),                 
.psel(apb_intf.psel),
.penable(apb_intf.penable),               
.pwrite(apb_intf.pwrite),                
.pwdata(apb_intf.pwdata),                
.prdata(apb_intf.prdata),                
.plsverr(apb_intf.plsverr),               
.apb_rd_done(apb_intf.apb_rd_done),           

.idle(apb_intf.idle),                  

.burst_ready(bm_intf.burst_ready),          
.data_burst_in(bm_intf.data_burst_in),         
.data_burst_out(bm_intf.data_burst_out),        
.db_length(bm_intf.db_length),             
.last(bm_intf.last),                  
.db_valid(bm_intf.db_valid),                        
.burst_last(bm_intf.burst_last),                         
.burst_valid(bm_intf.burst_valid),                    
.db_ready(bm_intf.db_ready)              
);


endmodule : top

`endif
