module full_adder16
(input 	[15:0] a_i,
 input	[15:0] b_i,
 input	[0:0] c_i,
 output	[15:0] sum_0,
 output	[15:0] c_o);
			
wire c0, c1, c2, c3;
full_adder4 fa0 (a_i[3:0], b_i[3:0], 1'b0, c0, sum_0[3:0]);
full_adder4 fa1 (a_i[7:3], b_i[7:3], c0, c1, sum_0[7:3]);
full_adder4 fa2 (a_i[11:8], b_i[11:8], c1, c2, sum_0[11:8]);
full_adder4 fa3 (a_i[15:12], b_i[15:12], c2, c3, sum_0[15:12]);
			

endmodule