module apbtoburst_top(
input        clk                   ,
input        rst_n                 ,
input  [8:0] paddr                 ,
input        psel                  ,
input        penable               ,
input        pwrite                ,
input  [7:0] pwdata                ,
output [7:0] prdata                ,
output       plsverr               ,
output       apb_rd_done           ,

output       idle                  ,

input        burst_ready           ,
input  [7:0] data_burst_in         ,
output [7:0] data_burst_out        ,
output [7:0] db_length             ,
output       last                  ,
output       db_valid              ,          
input        burst_last            ,             
input        burst_valid           ,         
output       db_ready              
);
//wires

wire       rb_rc_ack             ;
wire [7:0] rb_rc_data            ;
wire [8:0] rc_rb_addr            ;
wire [7:0] rc_rb_data            ;
wire       rc_rb_req             ;
wire       rc_rb_rw              ;
wire       rc_rb_idle            ;

wire       rb_rc_rd_done         ;    
wire       db_rb_rd_done         ;
wire       db_rb_req             ;
wire [7:0] db_rb_data            ;
wire [8:0] db_rb_addr            ;
wire       db_rb_idle            ;
wire       rb_db_start           ;
wire [7:0] rb_db_data            ;
wire       rb_db_ack             ;
wire [7:0] rb_db_length          ;
wire       rb_db_rw              ;
wire [7:0] rb_db_max_burst_size  ;       

               
               


 
register_bank_controller reg_bank_ctrl_dut(
.clk              (clk           ),
.rst_n            (rst_n         ),
.paddr            (paddr         ),
.psel             (psel          ),
.penable          (penable       ),
.pwrite           (pwrite        ),
.pwdata           (pwdata        ),
.prdata           (prdata        ),
.plsverr          (plsverr       ),
.apb_rd_done      (apb_rd_done   ),
.rb_rc_ack        (rb_rc_ack     ),
.rb_rc_data       (rb_rc_data    ),
.rb_rc_rd_done    (rb_rc_rd_done ),
.rc_rb_addr       (rc_rb_addr    ),
.rc_rb_data       (rc_rb_data    ),
.rc_rb_req        (rc_rb_req     ),
.rc_rb_rw         (rc_rb_rw      ),
.rc_rb_idle       (rc_rb_idle    )

);


register_bank  rb_dut(
.clk                      (clk                 ),
.rst_n                    (rst_n               ),
.rc_rb_addr               (rc_rb_addr          ),
.rc_rb_data               (rc_rb_data          ),
.rc_rb_req                (rc_rb_req           ),
.rc_rb_rw                 (rc_rb_rw            ),
.rc_rb_idle               (rc_rb_idle          ),
.rb_rc_ack                (rb_rc_ack           ),
.rb_rc_data               (rb_rc_data          ),
.rb_rc_rd_done            (rb_rc_rd_done       ),
.db_rb_rd_done            (db_rb_rd_done       ),
.db_rb_req                (db_rb_req           ),
.db_rb_data               (db_rb_data          ),
.db_rb_addr               (db_rb_addr          ),
.db_rb_idle               (db_rb_idle          ),
.rb_db_start              (rb_db_start         ),
.rb_db_data               (rb_db_data          ),
.rb_db_ack                (rb_db_ack           ),
.rb_db_length             (rb_db_length        ),
.rb_db_rw                 (rb_db_rw            ),
.rb_db_max_burst_size     (rb_db_max_burst_size),
.idle                     (idle                )
);

data_burst_controller    db_ctrl_dut(
.clk                     (clk                 ),
.rst_n                   (rst_n               ),
.rb_db_start             (rb_db_start         ),
.rb_db_data              (rb_db_data          ),
.rb_db_ack               (rb_db_ack           ),
.rb_db_rw                (rb_db_rw            ),
.rb_db_max_burst_size    (rb_db_max_burst_size),
.rb_db_length            (rb_db_length        ),
.db_rb_req               (db_rb_req           ),
.db_rb_data              (db_rb_data          ),
.db_rb_addr              (db_rb_addr          ),
.db_rb_idle              (db_rb_idle          ),
.db_rb_rd_done           (db_rb_rd_done       ),
.burst_valid             (burst_valid         ),
.burst_ready             (1'b1                ),
.data_burst_in           (data_burst_in       ),
.burst_last              (burst_last          ),
.data_burst_out          (data_burst_out      ),
.db_length               (db_length           ),
.last                    (last                ),
.db_ready                (db_ready            ),
.db_valid                (db_valid            )
 );



endmodule
