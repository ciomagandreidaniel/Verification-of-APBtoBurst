module data_burst_controller(
//register bank inputs
input                  clk                  ,//the global clock
input                  rst_n                ,//the global reset active in LOW 
input                  rb_db_start          ,//the start signal from the RB 
input         [7:0]    rb_db_data           ,//the readed data from the register bank
input                  rb_db_ack            ,//the acknowledge signal from RB
input                  rb_db_rw             ,//the rw signal, when it's HIGH we make a write transaction and if it's LOW a read transction
input         [7:0]    rb_db_max_burst_size ,//the max burst size
input         [7:0]    rb_db_length         ,//the length of the data
//register bank outputs
output reg             db_rb_req            ,//the request signal from DB to RB
output reg    [7:0]    db_rb_data           ,//the data from DB to RB if we make a read transaction
output reg    [8:0]    db_rb_addr           ,// the generated address
output reg             db_rb_idle           ,// idle signal when the DB makes a transaction
output reg             db_rb_rd_done        ,// rd_done signal it's HIGH when we finish a read transaction
//burst inputs
input                  burst_valid          ,//the valid from the burst interface
input                  burst_ready          ,//the ready signal from the burst interface
input         [7:0]    data_burst_in        ,//the data that it's readed
input                  burst_last           ,//it's HIGH when the last data from a burst is transferred

//burst outputs

output  reg   [7:0]    data_burst_out       ,// the data transferred as a burst using the burst interface
output        [7:0]    db_length            ,// the length of data 
output  reg            last                 ,// high when we transfer the last data from a burst
output  reg            db_ready             ,// the ready signal from the DB
output  reg            db_valid              // the valid signal it's HIGH when we transfer data from the burst interface

);
// data regs
reg [8:0] generated_w_addr;
reg [8:0] generated_rb_addr;
reg [7:0] w_count_length;
reg [7:0] r_count_length;
reg [5:0] w_count_burst;

// register for state
reg [3:0] state;

// state list

parameter INIT               =4'd0;
parameter CONFIG             =4'd1;
parameter READ_BURST         =4'd2;
parameter GEN_BURST          =4'd3;
parameter GEN_RD_ADDR        =4'd4;
parameter GEN_W_ADDR         =4'd5;
parameter RD_DONE            =4'd6;
parameter RST_BURST_SIZE     =4'd7;
parameter DONE               =4'd8;

////////////////////////////////////////////////////////////////////////////////////////////
// CONTROL PATH
//////////////////////
always @(posedge clk or negedge rst_n)
begin
if(~rst_n)state<=INIT;else
begin

case(state) 
    INIT: if(rb_db_start)                               state<=CONFIG;else
                                                        state<=INIT;
    CONFIG:if(rb_db_rw)                                 state<=GEN_BURST;else
	                                                    state<=READ_BURST;
	GEN_BURST:                                          state<=GEN_W_ADDR;
	READ_BURST:                                         state<=GEN_RD_ADDR;
    GEN_W_ADDR:if(w_count_length==0)                    state<=DONE;else
	           if( w_count_burst==0)                    state<=RST_BURST_SIZE;else
                                                        state<=GEN_BURST;
	RST_BURST_SIZE:                                     state<=GEN_BURST;
	GEN_RD_ADDR:if(r_count_length==0)                   state<=RD_DONE;else
	                                                    state<=READ_BURST;
	RD_DONE:                                            state<=DONE;
	DONE:                                               state<=INIT;
	default                                             state<=INIT;
endcase
end
end
////////////////////////////////////////////////////////////////////////////////////////////

//DATA PATH
//////////////////////////////////////////////////
//internal signals if we make a write transaction
//////////////////////////////////////////////////

//	generated_w_addr			   
always @(posedge clk or negedge rst_n)				   
if(~rst_n                          )generated_w_addr<=9'b0;else
if(state==CONFIG                   )generated_w_addr<=9'b0;else
if(state==GEN_W_ADDR & burst_ready )generated_w_addr<=generated_w_addr+1;

//w_count_legth
always @(posedge clk or negedge rst_n)
if(~rst_n                           )w_count_length<=4'b0;else
if(state==CONFIG                    )w_count_length<=rb_db_length;else
if(state==GEN_BURST   & burst_ready )w_count_length<=w_count_length-1;

//w_count_burst
always @(posedge clk or negedge rst_n)
if(~rst_n                         )w_count_burst<=4'b0;else
if(state==CONFIG                  )w_count_burst<=rb_db_max_burst_size;else
if(state==RST_BURST_SIZE          )w_count_burst<=rb_db_max_burst_size;else
if(state==GEN_BURST & burst_ready )w_count_burst<=w_count_burst-1;

////////////////////////////////////////////
//internal signals for the read transaction
////////////////////////////////////////////
//r_count_legth
always @(posedge clk or negedge rst_n)
if(~rst_n                     )r_count_length<=4'b0;else
if(state==CONFIG              )r_count_length<=rb_db_length;else
if(burst_valid                )r_count_length<=r_count_length-1;

// generated_r_addr
always @(posedge clk or negedge rst_n)
if(~rst_n                   ) generated_rb_addr<=9'b0;else
if(state==CONFIG            ) generated_rb_addr<=9'b0;else
if(burst_valid              ) generated_rb_addr<=generated_rb_addr+1;

//////////////////////////////////////////
// Generate signals for the register bank
//////////////////////////////////////////

//db_rb_addr //assign
always @(posedge clk or negedge rst_n) 
if(rb_db_rw  )db_rb_addr<=generated_w_addr;else
if(~rb_db_rw )db_rb_addr<=generated_rb_addr;

//db_rb_req
always @(posedge clk or negedge rst_n) 
if(~rst_n                         )db_rb_req<=1'b0;else
if(~burst_ready                   )db_rb_req<=1'b0;else
if(burst_valid | state==GEN_BURST )db_rb_req<=1'b1;else
                                   db_rb_req<=1'b0;
												   
//db_rb_data
always @(posedge clk or negedge rst_n)
if( burst_valid )db_rb_data<=data_burst_in;

//db_rb_idle
always @(posedge clk or negedge rst_n)
if(~rst_n       ) db_rb_idle<=1'b1;else
if(rb_db_start  ) db_rb_idle<=1'b0;else
if(state==DONE  ) db_rb_idle<=1'b1;

//db_rb_rd_done
always @(posedge clk or negedge rst_n)
if(~rst_n |state==CONFIG) db_rb_rd_done<=1'b0;else
if(state==RD_DONE       ) db_rb_rd_done<=1'b1;
                          

/////////////////////////
// Generate signals for the burst interface
////////////////////////
//data_burst_out
always @(posedge clk or negedge rst_n)
if(~rst_n | ~rb_db_rw ) data_burst_out<='b0;else
if(rb_db_ack          ) data_burst_out<=rb_db_data;


//db_length
assign db_length=rb_db_length;

  
//db_valid
always @(posedge clk or negedge rst_n)
if(~rst_n                                              )db_valid<=1'b0;else
if(~burst_ready                                        )db_valid<=1'b0;else
if(state==GEN_W_ADDR                                   )db_valid<=1'b1;else
if(state==GEN_BURST |state==RST_BURST_SIZE|state==DONE )db_valid<=1'b0;

//last
always @(posedge clk or negedge rst_n)
if(~rst_n                                                                     )last<=1'b0;else
if(state==GEN_W_ADDR& w_count_burst==0 | state==GEN_W_ADDR & w_count_length==0)last<=1'b1;else
                                                                               last<=1'b0;
																			   
//db_ready
always @(posedge clk or negedge rst_n)
if(~rst_n           ) db_ready<=1'b0;else
if(state==READ_BURST) db_ready<=1'b1;else
if(state==DONE      ) db_ready<=1'b0;

  
endmodule
