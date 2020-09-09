/*--------------------------------------------------*/
// Module : register_bank                                                               
// Author : Ciobanu Eduard Mihai                                                        
// Date  : 30.08.2020                                                                
// Description : 


module register_bank(
//global inputs
input      clk   , 
input      rst_n ,

//register bank controller inputs
input[8:0]       rc_rb_addr           ,//the address from the RC used for write
input[7:0]       rc_rb_data           ,//the data_in from the RC 
input            rc_rb_req            ,//the request for writing
input            rc_rb_rw             ,//the rw signal, if HIGH-we make a write transaction, if LOW we make a read transaction
input            rc_rb_idle           ,// the signal it's LOW if the RC it's busy


//register bank controller outputs
output reg       rb_rc_ack            ,//it's high when we receive a request and data
output     [7:0] rb_rc_data           ,//the readed data
output reg       rb_rc_rd_done        ,// when the DB finish the read transaction
///////////////////////////////////////
//data burst controller inputs
input            db_rb_rd_done        ,//the rd_done from the DB
input            db_rb_req            ,// request from the DB to write in the RB
input[7:0]       db_rb_data           ,//the readed data from the burst interface
input[8:0]       db_rb_addr           ,//the address from the DB that represents a location from the rb
input            db_rb_idle           ,//this signal it's LOW when the DB make a transaction

// data burst controller outputs
output           rb_db_start          ,//the start signal for the DB
output     [7:0] rb_db_data           ,//the data from the RB
output           rb_db_ack            ,//the acknowledge signal as a response for the request and data
output     [7:0] rb_db_length         ,//the length of data
output           rb_db_rw             ,//the rw signal
output     [7:0] rb_db_max_burst_size ,//the max burst size from the RB to DB

//global output
output idle

);

/////////////////////////
// LOCAL PARAMETERS
////////////////////////
localparam LENGTH_ADDR         =9'd256;
localparam MAX_BURST_SIZE_ADDR =9'd257;
localparam START_REG_ADDR      =9'd258;

/////////////////////////
// REGISTERS
////////////////////////
reg [7:0] data_reg [255:0] ;
reg [7:0] length           ;
reg [7:0] rw               ;
reg [7:0] max_burst_size   ;
reg [7:0] start_reg        ;
reg [7:0] rd_done          ;

//global idle generation
assign idle= (rb_db_start)?1'b0:(rc_rb_idle & db_rb_idle);

//register bank controller data
always @(posedge clk or negedge rst_n)
if((rc_rb_rw & rc_rb_req)  & (rc_rb_addr < LENGTH_ADDR)) data_reg[rc_rb_addr]<=rc_rb_data;else
if((~rc_rb_rw & db_rb_req) & (db_rb_addr < LENGTH_ADDR)) data_reg[db_rb_addr]<=db_rb_data;

//length register
always @(posedge clk or negedge rst_n)
if(~rst_n                                           )length<=8'b00000000;else
if(rc_rb_req & rc_rb_rw & (rc_rb_addr ==LENGTH_ADDR))length<=rc_rb_data;

//rw register
always @(posedge clk or negedge rst_n)
if( rc_rb_rw )rw<=8'b11111111;else
if( ~rc_rb_rw)rw<=8'b00000000;

//max burst size register
always @(posedge clk or negedge rst_n)
if(~rst_n                                                    )max_burst_size<=8'b00000000;else
if(rc_rb_req  & rc_rb_rw & (rc_rb_addr ==MAX_BURST_SIZE_ADDR))max_burst_size<=rc_rb_data;

//start register
always @(posedge clk or negedge rst_n)
if(~rst_n                                              )start_reg<=8'b00000000;else
if(rc_rb_req & rc_rb_rw & (rc_rb_addr ==START_REG_ADDR))start_reg<=rc_rb_data ;else
if(db_rb_idle                                          )start_reg<=8'b00000000;

//rd_done register

 //rd_done signal
always @(posedge clk or negedge rst_n)
if(db_rb_rd_done ) rd_done<=8'b11111111;else
if(~db_rb_rd_done) rd_done<=8'b00000000;


/////////////////////////
// Generate signals for the register bank controller
////////////////////////

//rb_rc_ack
always @(posedge clk or negedge rst_n)
if(~rst_n    )rb_rc_ack<=1'b0;else
if(rc_rb_req )rb_rc_ack<=1'b1;else
              rb_rc_ack<=1'b0;

//rb_rc_data 
assign rb_rc_data=(rc_rb_req & ~rc_rb_rw)?data_reg[rc_rb_addr]:(rc_rb_rw)?'bx:rb_rc_data;


//rb_rc_rd_done
always @(posedge clk)
if(rd_done==8'b11111111 )rb_rc_rd_done<=1'b1;else
                         rb_rc_rd_done<=1'b0; 
/////////////////////////
// Generate signals for data_burst_controller
////////////////////////
//rb_db_start
assign rb_db_start= &start_reg;


//rb_db_data
assign rb_db_data =(db_rb_req & rc_rb_rw )?data_reg[db_rb_addr]:rb_db_data;

//rb_db_ack  
assign rb_db_ack=db_rb_req;

   
//rb_db_length//assign
assign 	rb_db_length = length;
	
//rb_db_rw
assign rb_db_rw = rc_rb_rw;

//rb_db_max_burst_size//assign
assign 	rb_db_max_burst_size =max_burst_size;
endmodule