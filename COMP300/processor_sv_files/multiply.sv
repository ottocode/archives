/* 
*	Authors: Nicholas Otto and Marc Slaughter
*	nicholasotto / msslaughter@sandiego.edu
*	
*	
*/

// C_WIDTH : number of bits needed to specify control
// D_WIDTH : data width
module multiply#(D_WIDTH=34)
(
	input [D_WIDTH-1 : 0] result_i,
	input [D_WIDTH-1 : 0] first_i,
	input [D_WIDTH-1 : 0] second_i,
	
	output [D_WIDTH-1 : 0] result_o,
	output [D_WIDTH-1 : 0] first_o,
	output [D_WIDTH-1 : 0] second_o,
	output least_sig_o
);

	logic [D_WIDTH-1 : 0] result_t;
	logic [D_WIDTH-1 : 0] first_t;
	logic [D_WIDTH-1 : 0] second_t;
	
	assign result_t = result_i + (first_t & second_t[0]);
	assign result_o = result_t >> 1;
	assign first_o = first_t << 1;
	assign second_o = second_t >>1;
	assign least_sig_o = result_t[0];

endmodule