`timescale 1ns / 1ps
/* Backend.sv
*	Authors: Nicholas Otto and Marc Slaughter
*	nicholasotto / msslaughter@sandiego.edu
*/

// I_WIDTH : instruction width
// IA_WIDTH : instruction address width
// D_WIDTH : data width
// PA_WIDTH : port address width
// INC_WIDTH : increment or decrement stack 
module Backend#(parameter I_WIDTH = 13, IA_WIDTH = 10, D_WIDTH = 34,
PA_WIDTH = 4, SEL_WIDTH=3, C_WIDTH=4, A_WIDTH=13, S_WIDTH=6, L_WIDTH=6, INC_WIDTH=1)
(
	input clk,
	input reset_i,											//to reset to 0x0
	// inputs from the fetch unit
	input [I_WIDTH-1 : 0] instruction_data_i,		// the instruction
	input [IA_WIDTH-1 : 0] instruction_addr_i,	// the addr of instruction
	input instruction_valid_i,							// if instruction was good
	
	// outputs to the fetch unit
	output dequeue_o,
	output restart_o,
	output [IA_WIDTH-1 : 0] restart_addr_o,
	output load_store_valid_o,
	output store_en_o,
	output [IA_WIDTH-1 : 0] load_store_addr_o,
	output [I_WIDTH-1 : 0] store_data_o,
	
	// I/O interface
	output in_req_o,
	output out_req_o,
	output [PA_WIDTH-1 : 0] in_addr_o,
	output [PA_WIDTH-1 : 0] out_addr_o,
	input [D_WIDTH-1 : 0] in_data_i,
	output [D_WIDTH-1 : 0] out_data_o,
	input in_ack_i,
	input out_ack_i
);

	/* the "_s" notation mean it is just a signal (a transient wire) */
	logic reset_s, branch_s, branch_eq_s, write_enable_s;
	logic mem_rw_s, mem_write_en_s, mem_refused_s;
	logic restart_s;
	logic spec_reg_write_en_s, label_reg_write_en_s;
	logic [I_WIDTH-1 : 0] instruction_data_s;
	logic [IA_WIDTH-1 : 0] instruction_addr_s;
	logic [IA_WIDTH-1 : 0] restart_addr_s;
	logic [C_WIDTH-1 : 0] alu_control_s;
	

	
	//General Register File
	logic [SEL_WIDTH-1 : 0] write_reg_s;
	logic [SEL_WIDTH-1 : 0] rs_s;
	logic [SEL_WIDTH-1 : 0] rt_s;
	logic [SEL_WIDTH-1 : 0] rd_s;
	logic [D_WIDTH-1 : 0] r0_d_s;
	logic [D_WIDTH-1 : 0] r1_d_s;
	logic [D_WIDTH-1 : 0] r2_d_s;
	logic [D_WIDTH-1 : 0] reg_write_data_s;
	assign rs_s = instruction_data_i[8:6];
	assign rt_s = instruction_data_i[5:3];
	assign rd_s = instruction_data_i[2:0];
	
	
	//ALU
	logic zero_s;
	logic [D_WIDTH-1 : 0] alu1_s;
	logic [D_WIDTH-1 : 0] alu2_s;
	logic [D_WIDTH-1 : 0] alu_result_s;
	assign alu1_s = r0_d_s;
	assign alu2_s = r1_d_s;
	
	//Memory
	logic [A_WIDTH-1 : 0] mem_addr_s;
	logic [D_WIDTH-1 : 0] mem_write_s;
	logic [D_WIDTH-1 : 0] mem_data_read_s;
	assign mem_write_s = r2_d_s;
	assign mem_addr_s = alu_result_s;

	//special reg file
	logic [S_WIDTH-1 : 0] spec_reg_write_s;
	logic [D_WIDTH-1 : 0] spec_reg_write_data_s;
	logic in_req_s;
	logic out_req_s;
	logic [PA_WIDTH-1 : 0] in_addr_s;
	logic [PA_WIDTH-1 : 0] out_addr_s;
	logic [D_WIDTH-1 : 0] out_data_s;
	logic in_ack_s;
	logic out_ack_s;
	assign in_req_i = in_req_s;
	assign out_req_o = out_req_s;
	assign in_addr_o = in_addr_s;
	assign out_addr_o = out_addr_s;
	assign in_ack_s = in_ack_i;
	assign out_ack_s = out_ack_i;
	
	//label reg file
	logic [L_WIDTH-1 : 0] label_write_reg_s;
	logic [IA_WIDTH-1 : 0] label_write_data_s;
	logic [L_WIDTH-1 : 0] label_raw_s;
	logic [IA_WIDTH-1 : 0] label1_val_s;
	logic [IA_WIDTH-1 : 0] label2_val_s;
	
	//setshiftmux
	logic [D_WIDTH-1 : 0] ssm_inst_data_s;
	logic [D_WIDTH-1 : 0] ssm_mem_data_s;
	logic [D_WIDTH-1 : 0] ssm_stack_data_s;
	logic [C_WIDTH-1 : 0] ssm_control_s;
	logic [D_WIDTH-1 : 0] ssm_out_s;
	assign reg_write_data_s = ssm_out_s;
	assign ssm_mem_data_s = mem_data_read_s;
	
	
	//function_stack
	logic [IA_WIDTH-1 : 0] fs_data_i_s;
	logic [D_WIDTH-1 : 0] fs_data_o_s;
	assign fs_data_i_s = instruction_addr_s;
	
	//general_stack
	logic gs_write_en_s, gs_addr_s, gs_push_s;
	logic [D_WIDTH-1 : 0] gs_data_i_s;
	logic [D_WIDTH-1 : 0] gs_data_o_s;
	logic [D_WIDTH-1 : 0] ssm_gs_data_s;
	assign gs_data_i_s = r0_d_s;
	
	
	
	assign reset_s = reset_i;
	assign instruction_data_s = instruction_data_i;
	//assign write_enable_s = 1;
	assign ssm_control_s = alu_control_s;
	
	
/* Control */
control controler(
	.clk(clk)
	,.reset_i(reset_s)
	,.instr_i(instruction_data_s)
	,.branch_o(branch_s)
	,.branch_eq_o(branch_eq_s)
	,.alu_control(alu_control_s)
	,.write_enable_o(write_enable_s)
	,.write_reg_o(write_reg_s)
	,.spec_reg_write_en_o(spec_reg_write_en_s)
	,.fs_write_en_o(fs_write_en_s)
	,.gs_write_en_o(gs_write_en_s)
	,.gs_push_o(gs_push_s)
	,.mem_write_enable_o(mem_write_en_s)
	,.instruction_valid_i(instruction_valid_i)
	,.dequeue_o(dequeue_o)
);

/* General Register lookup (the "decode" stage) */
genregfile genregfiler(
	.clk(clk)
	,.write_enable_i(write_enable_s)
	,.write_reg_i(write_reg_s)
	,.write_data_i(reg_write_data_s)
	,.rs_val_i(rs_s)
	,.rt_val_i(rt_s)
	,.rd_val_i(rd_s)
	,.rd0_o(r0_d_s)
	,.rd1_o(r1_d_s)
	,.rd2_o(r2_d_s)
);

/* ALU setup */
alu alur(
	.clk(clk)
	,.input0_i(alu1_s)
	,.input1_i(alu2_s)
	,.control(alu_control_s)
	,.zero(zero_s)
	,.result(alu_result_s)
);

/* Data Memory! */
	/*
dmem dmemr(
	.reset_i(reset_s)
	,.clk(clk)
	,.read_write_req_i(1'b1)
	,.write_en_i(mem_write_en_s)
	,.addr_i(mem_addr_s)
	,.din_i(r0_d_s)
	,.dout_o(mem_data_read_s)
	,.refused_o(mem_refused_s)
);
*/

dmem_34_8192 mem(
	.address(mem_addr_s), // Bus [12 : 0] 
	.clock(clk),
	.data(r0_d_s), // Bus [33 : 0] 
	.wren(mem_write_en_s),
	.q(mem_data_read_s) 
); 



/* Special Register File */
specregfile specregfiler(
	.clk(clk)
	,.write_enable_i(spec_reg_write_en_s)
	,.write_reg_i(spec_reg_write_s)
	,.write_data_i(spec_reg_write_data_s)
	,.in_req_o(in_req_s)
	,.out_req_o(out_req_s)
	,.in_addr_o(in_addr_s)
	,.out_addr_o(out_addr_s)
	,.in_data_i(in_data_s)
	,.out_data_o(out_data_s)
	,.in_ack_i(in_ack_s)
	,.out_ack_i(out_ack_s)
	
);

/* Label Register File */
labelregfile labelregfiler(
	.clk(clk)
	,.write_enable_i(label_reg_write_en_s)
	,.write_reg_i(label_write_reg_s)
	,.write_data_i(label_write_data_s)
	,.label1_i({3'b000, instruction_data_i[2:0]})
	,.label2_i({3'b000, instruction_data_i[8:6]})
	,.label1_o(label1_val_s)
	,.label2_o(label2_val_s)
);

setshiftmux setshiftmuxer(
	.inst_data_i(instruction_data_i)
	,.alu_result_i(alu_result_s)
	,.rs_i(r0_d_s)
	,.mem_data_i(ssm_mem_data_s)
	,.stack_data_i(ssm_stack_data_s)
	,.control_i(instruction_data_i[I_WIDTH-1 : I_WIDTH-4])
	,.instruction_full_i(instruction_data_i)
	,.out_o(ssm_out_s)
);

function_stack function_stacker(
	.clk(clk)
	,.write_enable_i(fs_write_en_s)
	,.data_i(fs_data_i_s)
	,.data_o(fs_data_o_s)
);

/* General Stack lookup */
general_stack genstacker(
	.clk(clk)
	,.write_enable_i(gs_write_en_s)
	,.reset(reset_i)
	,.push(gs_push_s)
	,.write_data_i(r2_d_s)
	,.pop_o(ssm_stack_data_s)
);


branchlogic branchlogicer(
	.clk(clk)
	,.alu_zero_i(zero_s)
	,.operation_i(instruction_data_i[I_WIDTH-1 : I_WIDTH-7])
	,.branch_i(branch_s)
	,.branch_eq_i(branch_eq_s)
	,.function_pop_addr_i(fs_data_o_s)
	,.ls_i(ls_s)
	,.lt_i(lt_s)
	,.label1_i(label1_val_s)
	,.label2_i(label2_val_s)
	,.instr_addr_i(instruction_addr_i)
	,.restart_o(restart_s)
	,.restart_addr_o(restart_addr_s)
);

logic restart_q;
logic [IA_WIDTH-1 : 0] restart_addr_q;
	always_comb
	begin
	  if(reset_i)
	    begin
	      restart_q = 1;
	      restart_addr_q = 0;
	      end
	   else
	        begin
	        restart_q = restart_s;
	        restart_addr_q = restart_addr_s;
	     end
	      end
	       
	
	assign restart_o = restart_q;
	assign restart_addr_o = restart_addr_q;
	assign load_store_addr_o = 0;
	assign load_store_valid_o = 0;


endmodule
