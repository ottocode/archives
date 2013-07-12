`timescale 1ns / 1ps

/*
 * COMP300: Lab 1A
 * University of San Diego
 * 
 * Written by Matt DeVuyst, 3/30/2010
 * Modified by Vikram Bhatt, 30/3/2010
 */

//
// NOTE: This verilog is non-synthesizable.
// You can only use constructs like "initial", "#10", "forever"
// inside your test bench! Do not use it in your actual design.
//

module test_full_adder1;

   reg  clk;
   reg  a_r;
   reg  b_r;
  reg  c_i_r;
   wire sum_o;
   wire c_o;

   // The design under test (cut) is our adder
   full_adder1 dut (.a_i(a_r)
						  ,.b_i(b_r)
						  ,.c_i(c_i_r)
						  ,.sum_o(sum_o)
						  ,.c_o(c_o));

   // Toggle the clock every 10 ns
   initial
     begin
        clk = 0;
        forever #10 clk = !clk;
     end

   // Test with a variety of inputs.
   // Introduce new stimulus on the falling clock edge so that values
   // will be on the input wires in plenty of time to be read by
   // registers on the subsequent rising clock edge.
   initial
     begin
        a_r = 1'b0;
        b_r = 1'b0;
		  c_i_r = 1'b0;
        @(negedge clk);
        a_r = 1'b0;
		  b_r = 1'b0;
		  c_i_r = 1'b1;
        @(negedge clk);
		  a_r = 1'b0;
		  b_r = 1'b1;
		  c_i_r = 1'b0;
        @(negedge clk);
		  a_r = 1'b0;
		  b_r = 1'b1;
		  c_i_r = 1'b1;
        @(negedge clk);
		  a_r = 1'b1;
		  b_r = 1'b0;
		  c_i_r = 1'b0;
        @(negedge clk);
		  a_r = 1'b1;
		  b_r = 1'b0;
		  c_i_r = 1'b1;
        @(negedge clk);
		  a_r = 1'b1;
		  b_r = 1'b1;
		  c_i_r = 1'b0;
        @(negedge clk);
		  a_r = 1'b1;
		  b_r = 1'b1;
		  c_i_r = 1'b1;
        @(negedge clk);
     end // initial begin

endmodule // test_full_adder1

