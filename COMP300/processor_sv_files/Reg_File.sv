/* 
*	Authors: Nicholas Otto and Marc Slaughter
*	nicholasotto / msslaughter@sandiego.edu
*/

// NUM_REG : number of registers in the register file
// SEL_WIDTH : number of bits needed to specify a register
// D_WIDTH : data width
module regfile#(parameter NUM_REG=16, SEL_WIDTH=4, D_WIDTH=34)
(
	input clk,
	input wen_i,
	input [SEL_WIDTH-1 : 0] wa_i,// addr of reg to write
	input [D_WIDTH-1 : 0] wd_i, // data to write to reg
	input [SEL_WIDTH-1 : 0] ra0_i,
	input [SEL_WIDTH-1 : 0] ra1_i,
	output [D_WIDTH-1 : 0] rd0_o,
	output [D_WIDTH-1 : 0] rd1_o
);

endmodule
