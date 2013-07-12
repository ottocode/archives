`timescale 1ns / 1ps

module test_fulladder4;
  reg clk;
  reg [3:0] a_r;
  reg [3:0] b_r;
  reg c_i_r;
  wire [3:0] sum_o;
  wire c_o;
  
  full_adder4 dut(.a_i(a_r)
                  ,.b_i(b_r)
                  ,.c_i(c_i_r)
                  ,.sum_o(sum_o)
                  ,.c_o(c_o));
  
  
    initial
     begin
        clk = 0;
        forever #10 clk = !clk;
     end
  
  initial
    begin
        a_r = 4'd0;
        b_r = 4'd0;
		    c_i_r = 1'd0;
        @(negedge clk);
            a_r = 4'h0;
            b_r = 4'h0;
		    c_i_r = 1'd0;
        @(negedge clk);
            a_r = 4'h0;
            b_r = 4'h0;
		    c_i_r = 1'd1;
        @(negedge clk);
            a_r = 4'hf;
            b_r = 4'h0;
		    c_i_r = 1'd0;
        @(negedge clk);
            a_r = 4'hf;
            b_r = 4'h0;
		    c_i_r = 1'd1;
        @(negedge clk);
            a_r = 4'h5;
            b_r = 4'hc;
		    c_i_r = 1'd0;
        @(negedge clk);
            a_r = 4'h5;
            b_r = 4'hc;
		    c_i_r = 1'd1;
        @(negedge clk);
            a_r = 4'h5;
            b_r = 4'h5;
		    c_i_r = 1'd1;
        @(negedge clk);
            a_r = 4'hc;
            b_r = 4'hc;
		    c_i_r = 1'd1;
        @(negedge clk);
            a_r = 4'hf;
            b_r = 4'hf;
		    c_i_r = 1'd1;
        @(negedge clk);
      end
endmodule
