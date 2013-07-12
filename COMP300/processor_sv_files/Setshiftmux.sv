/* 
*	Authors: Nicholas Otto and Marc Slaughter
*	nicholasotto / msslaughter@sandiego.edu
*/


// C_WIDTH : number of bits needed to specify control
// D_WIDTH : data width
module setshiftmux#(parameter D_WIDTH=34, C_WIDTH=4, I_WIDTH = 17)
(
	input clk,
	input [D_WIDTH-1 : 0] alu_result_i,
	input [D_WIDTH-1 : 0] rs_i,			//for shifting, the first register
	input [D_WIDTH-1 : 0] inst_data_i, //only use [5:0] for set and shift
	input [D_WIDTH-1 : 0] mem_data_i,  // data from memory module
	input [D_WIDTH-1 : 0] stack_data_i, 
	input [C_WIDTH-1 : 0] control_i,
	input [I_WIDTH-1 : 0] instruction_full_i,
	
	output [D_WIDTH-1 : 0] out_o
);

	logic [D_WIDTH-1 : 0] shift_val_s;
	logic [D_WIDTH-1 : 0] set_val_s;
	logic [D_WIDTH-1 : 0] mem_val_s;
	logic [D_WIDTH-1 : 0] alu_back_s;
	logic [D_WIDTH-1 : 0] stack_val_s;
	assign shift_val_s = rs_i << inst_data_i[5 : 0];
	logic [D_WIDTH-1 : 0] temp;
	
	//temporary
	//assign out_o = alu_result_i;
	
	//assign out_o = {{D_WIDTH-1-5{1'b0}}, inst_data_i[5-1:0]};
	
	always_comb
		begin
			if(control_i == 4'b0001 || control_i == 4'b0010 || control_i == 4'b0011 || control_i == 4'b0100 || control_i == 4'b0101 || control_i == 4'b0110 || control_i == 4'b1011)
				temp = alu_result_i;
			else if (control_i === 4'b1110)
				temp = shift_val_s;
			else if (instruction_full_i[I_WIDTH-1 : I_WIDTH-7] == 7'b1111110)
				temp = stack_data_i;
			else if (control_i == 4'b0111)
				temp = mem_data_i;
			else
				temp = {{D_WIDTH-1-5{1'b0}}, inst_data_i[5-1:0]};
		end
	assign out_o = temp;


endmodule
