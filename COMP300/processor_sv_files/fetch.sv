`timescale 1ns / 1ps

/* Marc Slaughter msslaughter@sandiego.edu and
	Nick Otto 		nicholasotto@sandiego.edu
	*/

/* 
 * COMP 300 - Lab 2A: Fetch Datapath
 * University of San Diego
 *
 * Written by Donghwan Jeon, 4/10/2007
 * Updated by Sat Garcia, 4/9/2008
 * Updated by Michael Taylor, 4/4/2011
 * Updated by Nikolaos Strikos, 4/11/2012
 */

/* 
 * Fetch unit module
 *
 * parameters:
 *      I_WIDTH: instruction width
 *      A_WIDTH: SRAM address width
 *      O_WIDTH: offset width in a branch instruction (2's complement)
 */

`include "instr_packet_s.sv"

module fetch#(parameter I_WIDTH = 17, A_WIDTH = 10, O_WIDTH = 5)
(
    input   clk,

    // inputs from exec unit
    input   dequeue_i,
    input   restart_i,
    input   [A_WIDTH-1: 0] restart_addr_i,

    // memory interface
    input   load_store_valid_i,
    input   store_en_i,
    input   [A_WIDTH-1: 0] load_store_addr_i,
    input   [I_WIDTH-1: 0] store_data_i,
    output  [I_WIDTH-1: 0] load_data_o,
    output  load_data_valid_o,

    // ouputs to the exec unit
    output  [I_WIDTH-1: 0] instruction_data_o,
    output  [A_WIDTH-1: 0] instruction_addr_o,
    output  instruction_valid_o
);

   logic     fifo_enqueue, fifo_clear, fifo_valid, fifo_full, fifo_empty;
   logic [A_WIDTH-1 : 0] offset;
   logic [A_WIDTH-1 : 0] ram_addr;
   logic [I_WIDTH-1 : 0] ram_data;
   logic                 ram_we;

   logic [A_WIDTH-1 : 0] pc_next;	

   // registers for the data path inputs
   logic [A_WIDTH-1 : 0]  load_store_addr_r;
   logic [I_WIDTH-1 : 0]  store_data_r;
   logic [A_WIDTH-1 : 0]  restart_addr_r;



   logic [A_WIDTH-1 : 0] pc_r;
	instr_packet_s ip_in;
	instr_packet_s ip_out;
   
   // fifo instantiation
   fifo fetch_fifo
     (
      .clk(clk)
      ,.instr_packet_i(ip_in)
      ,.deque_i(dequeue_i)
      ,.clear_i(fifo_clear)
      ,.enque_i(fifo_enqueue)
      ,.instr_packet_o(ip_out)
      ,.empty_o(fifo_empty)
      ,.full_o(fifo_full)
      ,.valid_o(fifo_valid)
      );


   // RAM instantiation
   ram_17_1024 ram
     (
      .address(ram_addr)
      ,.clock(clk)
      ,.data(store_data_r)
      ,.wren(ram_we)
      ,.q(ram_data)             //data_out
      );
		
		

   // TODO: noble student, complete this file!
	     logic [3:0]sel_mux;
		  //assign instruction_data_o = ram_data;
		  //assign instruction_addr_o = pc_r;
		  assign {instruction_data_o, instruction_addr_o} = {ip_out.instr, ip_out.addr};


	
	Control control
		(
		.clk(clk)
		,.restart_i(restart_i)
		,.load_store_valid_i(load_store_valid_i)
      ,.store_en_i(store_en_i)
      ,.fifo_empty(fifo_empty)
      ,.fifo_full(fifo_full)
      ,.p_bit(ram_data[I_WIDTH-1])
		,.fifo_valid(fifo_valid)
	 	,.sel_mux(sel_mux)
	   ,.ram_we(ram_we)
	   ,.fifo_enqueue(fifo_enqueue)
	   ,.fifo_clear(fifo_clear)
	   ,.load_data_valid_o(load_data_valid_o)
	   ,.instruction_valid_o(instruction_valid_o));
	
	//muxes
	
	
	logic [9:0] pc_plus_one;
	logic [31:0] big_pc_p ;
	
	/*
	adder plus_one (
		.d0_i({{32-A_WIDTH{1'b0}}, pc_r[A_WIDTH-1:0]}),
		.d1_i({{32-1{1'b0}}, 1'b1}), 
		.d_o(big_pc_p) );
		
		*/
		
		assign big_pc_p = pc_r +  1;
		
	assign pc_plus_one = big_pc_p[9:0];
	
	logic [9:0] offset_val;
	signext extendme (
		.d_i(ram_data[4:0])
		,.d_o(offset_val) );
		
	logic [9:0] pc_plus_offset;
	logic [32:0] big_pc_off ;
	
	/* adder not used
	
	adder plus_offset (
		.d0_i({{32-A_WIDTH{1'b0}}, pc_r[A_WIDTH-1:0]}),
		.d1_i({{32-9{1'b0}}, offset_val}), 
		.d_o(big_pc_off) );
		*/
		
		assign big_pc_off = {{32-A_WIDTH{1'b0}}, pc_r[A_WIDTH-1:0]} + {{32-9{1'b0}}, offset_val};
		
	assign pc_plus_offset = big_pc_off[9:0];
	
    logic [A_WIDTH-1:0] mux0_o;
    mux #(.WIDTH(A_WIDTH)) mux0
    (
        .sel(sel_mux[0])
        ,.d1_i(pc_plus_one)
        ,.d0_i(pc_plus_offset)
        ,.d_o(mux0_o)
    );

    // mux1
    logic [A_WIDTH-1:0] mux1_o;
    logic [A_WIDTH-1:0] mux2_o;
    logic [A_WIDTH-1:0] mux3_o;
    mux #(.WIDTH(A_WIDTH)) mux1
    (
        .sel(sel_mux[1])
        ,.d1_i(mux0_o)
        ,.d0_i(mux2_o)
        ,.d_o(mux1_o)
    );
	
	    // mux2
    mux #(.WIDTH(A_WIDTH)) mux2
    (
        .sel(sel_mux[2])
        ,.d1_i(mux1_o)
        ,.d0_i(restart_addr_r)
        ,.d_o(mux2_o)
    );
	 
	 	
	    // mux3
    mux #(.WIDTH(A_WIDTH)) mux3
    (
        .sel(sel_mux[3])
        ,.d0_i(mux2_o)
        ,.d1_i(load_store_addr_r)
        ,.d_o(ram_addr)
    );
	 //logic [A_WIDTH-1:0]load_store_addr_r, [I_WIDTH-1:0]store_data_r, [A_WIDTH-1:0]restart_addr_r;
	 always_ff @(posedge clk)
		begin
		  restart_addr_r <= restart_addr_i;
		  load_store_addr_r <= load_store_addr_i;
		  store_data_r <= store_data_i;
		  ip_in <= {ram_data, pc_r};
		  pc_r <= mux2_o;
		end

	
endmodule
