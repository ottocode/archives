/* 
*	Authors: Nicholas Otto and Marc Slaughter
*	nicholasotto / msslaughter@sandiego.edu
*/

// NUM_REG : number of registers in the register file
// SEL_WIDTH : number of bits needed to specify a register
// D_WIDTH : data width
module genregfile#(parameter NUM_REG=16, SEL_WIDTH=3, D_WIDTH=34)
(
	input clk,
	input write_enable_i,
	input [SEL_WIDTH-1 : 0] write_reg_i,// addr of reg to write
	input [SEL_WIDTH-1 : 0] rs_val_i,
	input [SEL_WIDTH-1 : 0] rt_val_i,
	input [SEL_WIDTH-1 : 0] rd_val_i,
	
	output [D_WIDTH-1 : 0] rd0_o,
	output [D_WIDTH-1 : 0] rd1_o,
	output [D_WIDTH-1 : 0] rd2_o,
	
	input [D_WIDTH-1 : 0] write_data_i // data to write to reg
);

register_file register_filer(
	.clk(clk)
	,.wen_i(write_enable_i)
	,.wa_i(write_reg_i)
	,.ra0_i(rs_val_i)
	,.ra1_i(rt_val_i)
	,.ra2_i(rd_val_i)
	,.wd_i(write_data_i)
	,.rd0_o(rd0_o)
	,.rd1_o(rd1_o)
	,.rd2_o(rd2_o)
);

endmodule
