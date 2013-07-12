/* 
*	Authors: Nicholas Otto and Marc Slaughter
*	nicholasotto / msslaughter@sandiego.edu
*/


// INC_WIDTH : number of bits needed to specify which register
// D_WIDTH : data width
module general_stack#(parameter INC_WIDTH=1, IA_WIDTH = 12, D_WIDTH = 34, STACKS = 5)
(
	input clk,
	input write_enable_i,
	input push,
	input reset,
	input [D_WIDTH-1 : 0] write_data_i,
	
	output [D_WIDTH-1 : 0] pop_o
);


	logic stack_we_s;
	logic [STACKS-1 : 0] stack_pointer_s;
	logic [STACKS-1 : 0] pre_pointer_s;
	logic [STACKS-1 : 0] read_stack_s;
	logic stack_we_s2;
	logic [STACKS-1 : 0] stack_pointer_s2;
	logic [STACKS-1 : 0] pre_pointer_s2;
	logic [STACKS-1 : 0] read_stack_s2;
	
	
	always_comb
	begin
			stack_pointer_s2 = stack_pointer_s;
			stack_we_s2 = stack_we_s;
			pre_pointer_s2 = pre_pointer_s;
			read_stack_s2 = read_stack_s;
		if(reset)
			begin
			stack_we_s2 = 1;
			pre_pointer_s2 = 0;
			end
		else if(~reset & write_enable_i)
			begin
			stack_we_s2 = 1;
			if (push)
			begin
				read_stack_s2 = stack_pointer_s;
				pre_pointer_s2 = stack_pointer_s + 1;
			end
			else
				begin
				read_stack_s2 = stack_pointer_s - 1;
				pre_pointer_s2 = stack_pointer_s - 1;
			end
			
			end
		else
			begin
			stack_we_s2 = 0;
			pre_pointer_s2 = pre_pointer_s;
			read_stack_s2 = read_stack_s;
			end
	end
	
	assign stack_we_s = stack_we_s2;
	assign pre_pointer_s = pre_pointer_s2;
	assign read_stack_s = read_stack_s2;
	
	

		
		
	
genregfile genstackRegister(
	.clk(clk)
	,.write_enable_i(write_enable_i)
	,.write_reg_i(read_stack_s)
	,.write_data_i(write_data_i)
	,.rs_val_i(read_stack_s)
	,.rd0_o(pop_o)
);

genregfile trickystackthing(
	.clk(clk)
	,.write_enable_i(stack_we_s)
	,.write_reg_i(0)
	,.write_data_i(pre_pointer_s)
	,.rs_val_i(0)
	,.rd0_o(stack_pointer_s)
);
	
	

endmodule