`timescale 1ns / 1ps
/* Marc Slaughter msslaughter@sandiego.edu and
	Nick Otto 		nicholasotto@sandiego.edu
	*/
/*
 * COMP300 Lab 2A: Fetch Datapath
 * University of San Diego
 *
 * Written by Donghwan Jeon, 4/10/2007
 * Updated by Sat Garcia, 4/8/2008
 * Updated by MBT, 4/4/2011
 *
 * 2-input Multiplexer (MUX)
 *
 * parameters:
 * 	WIDTH: data width for inputs and output
 */
 
module mux#(parameter WIDTH=10)
(
    input    sel,
    input    [WIDTH-1:0] d0_i,
    input    [WIDTH-1:0] d1_i,
    output   [WIDTH-1:0] d_o
);

assign d_o = (sel) ? d1_i : d0_i;

endmodule
