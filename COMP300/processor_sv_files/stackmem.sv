`timescale 1ns / 1ps
//
// Lab 3A: Execution Unit Datapath
// COMP 300 @ University of San Diego
// 
// Written by Donghwan Jeon, 5/18/2007
// Update by Sat Garcia, 5/8/2008
// Updated by Arash Arfaee 4/30/2010
// Updated by Nikolaos Strikos, 5/7/2012

// Data Memory Module
//
// parameters:
// 	A_WIDTH: SRAM address width
// 	D_WIDTH: data width

module stackmem#(parameter IA_WIDTH = 13, D_WIDTH = 34)
(
    
	input  clk,
	input  write_en_i,
	input  [IA_WIDTH-1 : 0] addr_i,
	input  [D_WIDTH-1 : 0] din_i,
	output [D_WIDTH-1 : 0] dout_o

);

logic [D_WIDTH-1 : 0] dout_temp;
logic write_control;


assign write_control = write_en_i;
assign dout_o = dout_temp;

dmem_34_8192 mem 
(
	.address(addr_i), // Bus [12 : 0] 
	.clock(clk),
	.data(din_i), // Bus [33 : 0] 
	.wren(write_control),
	.q(dout_temp) 
); 


endmodule