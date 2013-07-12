`timescale 1ns / 1ps
/* Marc Slaughter msslaughter@sandiego.edu and
	Nick Otto 		nicholasotto@sandiego.edu
	*/
/*
 * COMP300 - Lab 2A: FIFO
 * University of San Diego
 * 
 * Written by Michael Taylor, May 1, 2010
 * Modified by Nikolaos Strikos, April 11, 2012
 *
 * SystemVerilog FIFO module
 *
 * parameters:
 * 	I_WIDTH: instruction width
 * 	A_WIDTH: SRAM address width
 *  DEPTH: lg (number of elements)
 */

`include "instr_packet_s.sv"


module fifo#(parameter I_WIDTH=17, A_WIDTH=10, LG_DEPTH=3)
(
	input clk,
	input instr_packet_s instr_packet_i,
	input enque_i, 
	input deque_i,	
	input clear_i,
	output instr_packet_s instr_packet_o,
	output empty_o,
	output full_o,
	output valid_o
);

   // some storage
   instr_packet_s storage [(2**LG_DEPTH)-1:0];
   
   // one read pointer, one write pointer;
   logic [LG_DEPTH-1:0] rptr_r, wptr_r;

   logic error_r; // lights up if the fifo was used incorrectly

   assign full_o = ((wptr_r + 1'b1) == rptr_r);
   assign empty_o = (wptr_r == rptr_r);
   assign valid_o = !empty_o;
   
   assign instr_packet_o = storage[rptr_r];
   
   always_ff @(posedge clk)
     if (enque_i)
       storage[wptr_r] <= instr_packet_i;
   
   always_ff @(posedge clk)
   begin
	if (clear_i)
	  begin
	     rptr_r <= 0;
	     wptr_r <= 0;
	     error_r <= 1'b0;
	  end
	else
	  begin
	     rptr_r <= rptr_r + deque_i;
	     wptr_r <= wptr_r + enque_i;
	     
	     // synthesis translate off
	     
	     if (full_o & enque_i)
	       $display("error: wrote full fifo");
	     if (empty_o & deque_i)
	       $display("error: deque empty fifo");			
	     
	     // synthesis translate on				
	     
	     error_r  <= error_r | (full_o & enque_i) | (empty_o & deque_i);
	  end 
   end
   
endmodule
