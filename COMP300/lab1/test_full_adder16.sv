`timescale 1ns / 1ps

module test_full_adder16;
  reg clk;
  reg [15:0] a_r;
  reg [15:0] b_r;
  reg c_i_r;
  wire [15:0] sum_o;
  wire c_o;
  
  full_adder16 dut(.a_i(a_r)
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
        a_r = 16'd0;
        b_r = 16'd0;
		    c_i_r = 1'd0;
        
        @(negedge clk);
            a_r = 16'h0000;
		    b_r = 16'h0000;
		    c_i_r = 1'd0;
        @(negedge clk);
            a_r = 16'hf0f0;
		    b_r = 16'h0f0f;
		    c_i_r = 1'd0;
        @(negedge clk);
            b_r = 16'hf0f0;
		    a_r = 16'h0f0f;
		    c_i_r = 1'd0;
        @(negedge clk);
            a_r = 16'hf0f0;
		    b_r = 16'h0f0f;
		    c_i_r = 1'd1;
        @(negedge clk);
            b_r = 16'hf0f0;
		    a_r = 16'h0f0f;
		    c_i_r = 1'd1;
        @(negedge clk);
            a_r = 16'hfff0;
		    b_r = 16'h000f;
		    c_i_r = 1'd1;
        @(negedge clk);
            b_r = 16'hfff0;
		    a_r = 16'h000f;
		    c_i_r = 1'd1;
    
        @(negedge clk);
      end
endmodule
