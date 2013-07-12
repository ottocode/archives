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

   // validate inputs
   // synthesis translate off
   always_comb
     begin
        if (store_en_r & ~load_store_valid_r)
          $display("Warning: store_en_r set but load_store_valid_r not set!\n");
     end
   // synthesis translate on

   logic [A_WIDTH-1 : 0] pc_r;
	logic [A_WIDTH+I_WIDTH-1 : 0] ip_in;
   
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
   ram_17_1024b ram
     (
      .address(ram_addr)
      ,.clock(clk)
      ,.data(store_data_r)
      ,.wren(ram_we)
      ,.q(ram_data)             //data_out
      );
		
		

   // TODO: noble student, complete this file!
	
	//muxes
   logic sel_mux[3:0];
	assign sel_mux[1] = fifo_full;
	assign sel_mux[2] = restart_i;
	assign sel_mux[3] = load_store_valid_i;
	assign sel_mux[0] = ram_data[I_WIDTH-1];
	
	assign fifo_clear = restart_i;
	assign fifo_enqueue = store_en_i;
	
	logic [9:0] pc_plus_one;
	logic [31:0] big_pc_p ;
	adder plus_one (
		.d0_i({{32-A_WIDTH{1'b0}}, pc_r[A_WIDTH-1:0]}),
		.d1_i({{32-1{1'b0}}, 1'b1}), 
		.d_o(big_pc_p) );
		
	assign pc_plus_one = big_pc_p[9:0];
	
	logic [9:0] offset_val;
	signext extendme (
		.d_i(ram_data[4:0])
		,.d_o(offset_val) );
		
	logic [9:0] pc_plus_offset;
	logic [31:0] big_pc_off ;
	adder plus_offset (
		.d0_i({{32-A_WIDTH{1'b0}}, pc_r[A_WIDTH-1:0]}),
		.d1_i({{32-9{1'b0}}, offset_val}), 
		.d_o(big_pc_off) );
		
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
    mux #(.WIDTH(A_WIDTH)) mux1
    (
        .sel(sel_mux[1])
        ,.d1_i(mux0_o)
        ,.d0_i(mux2_o)
        ,.d_o(mux1_o)
    );
	
	    // mux2
    logic [A_WIDTH-1:0] mux2_o;
    mux #(.WIDTH(A_WIDTH)) mux2
    (
        .sel(sel_mux[2])
        ,.d1_i(mux1_o)
        ,.d0_i(restart_addr_i)
        ,.d_o(mux2_o)
    );
	 
	 	
	    // mux3
    logic [A_WIDTH-1:0] mux3_o;
    mux #(.WIDTH(A_WIDTH)) mux3
    (
        .sel(sel_mux[3])
        ,.d0_i(mux2_o)
        ,.d1_i(load_store_addr_i)
        ,.d_o(mux3_o)
    );
	 
	 always_ff
		begin
		ram_addr <= mux3_o;
		store_data_r <= store_data_i;
		ip_in[I_WIDTH-1 : 0] <= ram_data[I_WIDTH-1 : 0];
		ip_in[A_WIDTH+I_WIDTH-1 : I_WIDTH] = pc_r;
		end
		
	always_ff @(posedge clk)
		begin
			pc_r <= mux2_o;
		end
	
endmodule
