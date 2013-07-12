/* 
*	Authors: Nicholas Otto and Marc Slaughter
*	nicholasotto / msslaughter@sandiego.edu
*/

// NUM_REG : number of registers in the register file
// S_WIDTH : number of bits needed to specify special register
// D_WIDTH : data width
module specregfile#(parameter NUM_REG=16, PA_WIDTH = 4, S_WIDTH=6, D_WIDTH=34)
(
	input clk,
	input write_enable_i,
	input [S_WIDTH-1 : 0] write_reg_i,// addr of reg to write
	input [D_WIDTH-1 : 0] write_data_i, // data to write to reg
	
	output in_req_o,
	output out_req_o,
	output [PA_WIDTH-1 : 0] in_addr_o,
	output [PA_WIDTH-1 : 0] out_addr_o,
	
	input [D_WIDTH-1 : 0] in_data_i,
	output [D_WIDTH-1 : 0] out_data_o,
	
	input in_ack_i,
	input out_ack_i
);

assign out_dat_o = in_data_i;
assign in_req_o = in_ack_i;
assign out_req_o = out_ack_i;
assign in_addr_o = {PA_WIDTH{1'b1}};
assign out_addr_o = {PA_WIDTH{1'b1}};


/*
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
*/

endmodule
