/* 
*	Authors: Nicholas Otto and Marc Slaughter
*	nicholasotto / msslaughter@sandiego.edu
*/

// NUM_REG : number of registers in the register file
// L_WIDTH : number of bits needed to specify label register
// D_WIDTH : instruction addr width
module labelregfile#(parameter NUM_REG=16, SEL_WIDTH=6, D_WIDTH=12)
(
	input clk,
	input write_enable_i,
	input [SEL_WIDTH-1 : 0] write_reg_i,// addr of reg to write
	input [D_WIDTH-1 : 0] write_data_i, // data to write to reg
	input [SEL_WIDTH-1 : 0] label1_i,
	input [SEL_WIDTH-1 : 0] label2_i,
	
	output [D_WIDTH-1 : 0] label1_o,
	output [D_WIDTH-1 : 0] label2_o
		
	//output [D_WIDTH-1 : 0] ls_o,
	//output [D_WIDTH-1 : 0] lt_o
);

register_file#(D_WIDTH, 127, SEL_WIDTH) register_filer(
	.clk(clk)
	,.wen_i(write_enable_i)
	,.wa_i(write_reg_i)
	,.ra0_i(label1_i)
	,.ra1_i(label2_i)
	,.wd_i(write_data_i)
	,.rd0_o(label1_o)
	,.rd1_o(label2_o)
);

endmodule
