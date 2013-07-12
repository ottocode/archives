`timescale 1ns / 1ps
/* Marc Slaughter msslaughter@sandiego.edu and
	Nick Otto 		nicholasotto@sandiego.edu
	*/
/*
 * COMP300 - Lab 2A: Fetch Datapath
 * University of San Diego
 * 
 * Written by Donghwan Jeon, 4/10/2007
 * Updated by Sat Garcia, 4/8/2008
 * Updated by Michael Taylor, 4/4/2011
 *
 * 2-input Adder Module
 *
 * parameters:
 * 	WIDTH: data width for inputs and output
 */
 
module adder#(parameter WIDTH=34)
(
    input   [WIDTH-1:0] d0_i,
    input   [WIDTH-1:0] d1_i,
    output  [WIDTH-1:0] d_o
);
	

   wire [WIDTH:0] sum = {1'b0,d0_i} + {1'b0,d1_i};
	assign d_o = sum[WIDTH-1:0];

endmodule

