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
 *
 *
 * Sign Extender Module
 *
 * parameters:
 * 	IN: data width for the input
 * 	OUT: data width for the output
 */

module signext#(parameter IN=5, OUT=10)
(
    input   [IN-1:0]    d_i,
    output  [OUT-1:0]   d_o
);


assign d_o = {{OUT-IN{d_i[IN-1]}}, d_i[IN-1:0]};

endmodule
