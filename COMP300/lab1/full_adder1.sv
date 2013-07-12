module full_adder1 	
	(input a_i, b_i, c_i, output c_0, sum_o);
	
	assign sum_0 = ( (a_i & ~(b_i & c_i)) |  (b_i & ~(a_i & c_i)) | (c_i & ~(b_i & a_i)) | (a_i & b_i & c_i) );
	assign c_0	= ((a_i & b_i) | (a_i & c_i) | (b_i & c_i));
endmodule