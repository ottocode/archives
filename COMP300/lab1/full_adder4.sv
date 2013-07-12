module full_adder4
(input 	[3:0] a_i, 
 input [3:0] b_i, 
 input [0:0] c_i,
 output	[3:0] sum_0, 
 output [0:0] c_o);
			
wire c0, c1, c2;
full_adder1 fa0 (a_i[0], b_i[0], 1'b0, c0, sum_0[0]);
full_adder1 fa1 (a_i[1], b_i[1], c0, c1, sum_0[0]);
full_adder1 fa2 (a_i[2], b_i[2], c1, c2, sum_0[0]);
full_adder1 fa3 (a_i[3], b_i[3], c2, c3, sum_0[0]);
			

endmodule
