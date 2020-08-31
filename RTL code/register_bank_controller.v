/*--------------------------------------------------*/
// Module : register_bank_controller                                                               
// Author : Ciobanu Eduard Mihai                                                        
// Date  : 30.08.2020                                                                
// Description : 


module register_bank_controller(
//apb inputs
input            clk               , //the global clock
input            rst_n             , //the global reset
input [8:0]      paddr             , //the address from the APB interface
input            psel              , //the psel signal
input            penable           , //the penable signal from the APB interface
input            pwrite            , //the pwrite signal, when it's HIGH we make a write transaction and if it's LOW a read transction
input [7:0]      pwdata            , //the data from the APB interface

//apb outputs
output[7:0]      prdata            , //the readed data from the burst interface
output reg       plsverr           , //high if we use a invalid address
output           apb_rd_done       , //when the signal it's HIGH the apb master will start reading from the rb
/////////////////////////////////////////
//register bank inputs
//input           rb_rc_valid        ,//the signal as a response for the rc_rb_ready signal
input           rb_rc_ack          ,//it's high when the RB receive the data
input [7:0]     rb_rc_data         ,//the readed data from the RB
input           rb_rc_rd_done      ,//this signal it's high when the DB finish the read transaction
//register bank outputs
output [8:0]    rc_rb_addr         ,//the address used for the write transaction
output [7:0]    rc_rb_data         ,//the data from the APB interface
output          rc_rb_req          ,//the request signal from the RC to RB
output          rc_rb_rw           ,//the r/w signal
output reg      rc_rb_idle         //it's set on LOW when RC makes a transaction

);
/////////////////////////
// LOCAL PARAMETERS
////////////////////////
localparam LENGTH_ADDR         =9'd256;
localparam START_REG_ADDR      =9'd258;

////////////////////////////////////
//registers for internal operations
////////////////////////////////////



assign prdata     = rb_rc_data                                   ;
assign rc_rb_addr = paddr                                        ;
assign rc_rb_req  =(psel)? penable:1'b0                          ;
assign rc_rb_data =(paddr==9'd257 & pwdata>8'd32)? 8'd32:pwdata  ;
assign rc_rb_rw   = pwrite                                       ;

//plsverr
always @(posedge clk or negedge rst_n)
if(paddr>START_REG_ADDR)plsverr<=1'b1;else
			            plsverr<=1'b0;
				
//rc_rb_idle
always @(posedge clk or negedge rst_n)
if(~rst_n                        ) rc_rb_idle<=1'b1;else
if(paddr==LENGTH_ADDR            ) rc_rb_idle<=1'b0;else
if(paddr==START_REG_ADDR & pwrite) rc_rb_idle<=1'b1;


//apb_rd_done
assign apb_rd_done = rb_rc_rd_done;



endmodule