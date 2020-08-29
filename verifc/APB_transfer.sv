//------------------------------------------------------------------------------
// S.C. EasyIC Design S.R.L.
// Proiect     : Verification of APBtoBurst
// File        : APB_transfer.sv
// Autor       : Ciomag Andrei Daniel(CAD)
// Data        : 20.08.2020
//------------------------------------------------------------------------------
// Descriere   : This class is used to generate all possible read or write
// APB transfers
//------------------------------------------------------------------------------
// Modificari  :
// 20.08.2020 (CAD): Initial 
//------------------------------------------------------------------------------

`ifndef GUARD_APBTRANS
`define GUARD_APBTRANS

//typedef for read/write transfer type
typedef enum {READ, WRITE} kind_e;

class APB_transfer;

     bit [8:0]  paddr; //address 
rand bit [7:0]  pwdata;//write data
     bit [7:0]  prdata;//read data
kind_e          pwrite;//command type

constraint c1{paddr[8:0] >= 0; paddr <= 260;};

function void cfg(kind_e pwrite_new, bit[8:0] paddr_new);

this.pwrite = pwrite_new;
this.paddr  = paddr_new;

endfunction : cfg

virtual function void display();
$display(" %0d : %s transfer at %d address, data = %d",$time, pwrite.name(),paddr, pwdata);
endfunction : display

endclass

`endif 

