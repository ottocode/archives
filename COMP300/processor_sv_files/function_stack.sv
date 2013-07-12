/* 
*	Authors: Nicholas Otto and Marc Slaughter
*	nicholasotto / msslaughter@sandiego.edu
*/

// INC_WIDTH : number of bits needed to specify which register
// D_WIDTH : data width
module function_stack#(parameter INC_WIDTH=1, IA_WIDTH = 12, D_WIDTH = 34)
(
	input clk,
	input [1 : 0] write_enable_i, // [0] is write [1] is pop
	input [IA_WIDTH-1 : 0] data_i,
	
	output [D_WIDTH-1 : 0] data_o
);

	logic [IA_WIDTH-1 : 0] addr_s;
	logic [D_WIDTH-1 : 0] data_s;
	assign addr_s = 0;
	
stackmem stackmemer(
		.clk(clk)
		,.write_en_i(write_enable_i[0])
		,.addr_i(addr_s)
		,.din_i(data_i)
		,.dout_o(data_s)
	);

endmodule