/* 
*	Authors: Nicholas Otto and Marc Slaughter
*	nicholasotto / msslaughter@sandiego.edu
*/

`define MUL 7'b0001xxx
`define ADD 7'b0010xxx
`define SUB 7'b0011xxx
`define OR 7'b0100xxx
`define NOR 7'b0101xxx
`define SR 7'b0110xxx
`define LW 7'b0111xxx
`define SW 7'b1000xxx
`define BNE 7'b1001xxx
`define BEQ 7'b1010xxx
`define SLT 7'b1011xxx
`define J 7'b1100xxx
`define SET 7'b1101xxx
`define SL 7'b1110xxx
`define QUIT 7'b1111000
`define IN 7'b1111001
`define OUT 7'b1111010
`define CALL 7'b1111011
`define RET 7'b1111100
`define PUSH 7'b1111101
`define POP 7'b1111110

// I_WIDTH : instruction width
module control#(parameter I_WIDTH = 13, IA_WIDTH = 12, D_WIDTH = 34,
PA_WIDTH = 4, SEL_WIDTH=4, C_WIDTH=4)
(
input clk,
input reset_i,
input [I_WIDTH-1 : 0] instr_i,
input instruction_valid_i,
input [IA_WIDTH-1 : 0] pc_next_i,
input dmem_refused_i,
input in_ack_i,
input out_ack_i,

output branch_o,
output branch_eq_o,
output write_enable_o,						// write back? to gen register
output [SEL_WIDTH-1 : 0] write_reg_o, 	//which register to write back to
output [C_WIDTH-1 : 0] alu_control,		//which alu op
output spec_reg_write_en_o,
output label_reg_write_en_o,
output fs_write_en_o,
output gs_write_en_o,
output gs_push_o,
output mem_write_enable_o,
output dequeue_o
);
	// relabeling wires for convenience
	logic [6 : 0] opcode;
	logic io_bit;
	logic garbage;
	assign opcode = instr_i[I_WIDTH-1 : I_WIDTH-7];
	//assign io_bit = instruction_data_i[`IO_BIT];


	// The execution states
	typedef enum { sDecode, sExecute, sMemory, sWB, sIO } state_s;
	state_s substate_r, substate_next;
	
	always_ff @ (posedge clk)
	begin
		substate_r <= reset_i ? sDecode : substate_next;
	end

	// use combinational logic to calculate next stage
	always_comb
	begin
		unique case (substate_r)
			sDecode: substate_next = instruction_valid_i ? sExecute : sDecode;
			sExecute: begin
					unique casex (opcode)
						`LW: substate_next = sMemory;
						`SW: substate_next = sMemory;
						`BNE: substate_next = sDecode;
						`BEQ: substate_next = sDecode;
						`J: substate_next = sDecode;
						`IN: substate_next = sIO;
						`OUT: substate_next = sIO;
						`CALL: substate_next = sMemory;
						`RET: substate_next = sMemory;
						`PUSH: substate_next = sWB;
						`POP: substate_next = sWB;
						default: substate_next = sWB;
					endcase
				end
			sMemory:
				begin
					if(dmem_refused_i) substate_next = sMemory;
					else substate_next = sWB;
				end
			sIO:
				begin
					if(~in_ack_i & ~out_ack_i) substate_next = sIO;
					else substate_next = sWB;
				end
			default: substate_next = sDecode;
		endcase
	end
	
	

		assign dequeue_o = substate_next === sDecode ? 1 : 0;


    logic garbage_s;
    logic branch_s;
    logic branch_eq_s;
    logic write_enable_s;						// write back? to gen register
    logic [SEL_WIDTH-1 : 0] write_reg_s; 	//which register to write back to
    logic [C_WIDTH-1 : 0] alu_control_s;	//which alu op
    logic spec_reg_write_en_s;
    logic label_reg_write_en_s;
    logic fs_write_en_s;
    logic gs_write_en_s;
	logic gs_push_s;
    logic mem_write_enable_s;

	// calculate other control signals
	always_comb
	begin
		garbage_s = 0;
		branch_s		= 0;
		branch_eq_s		= 0;
		write_enable_s		= 0;
		write_reg_s 		= instr_i[2:0];
		alu_control_s		= instr_i[I_WIDTH-1:I_WIDTH-4];
		spec_reg_write_en_s	= 0;
		fs_write_en_s		= 0;
		gs_write_en_s		= 0;
		mem_write_enable_s	= 0;
		gs_push_s = (opcode === `PUSH) ? 1 : 0;

		unique case (substate_r)
			sDecode:
				begin
					//branch_o		= 0;
					//branch_eq_o		= 0;
					///write_enable_o		= 0;
					//write_reg_o 		= 0;
					alu_control_s		= opcode[6:2];
					write_enable_s	= 0;
					//spec_reg_write_en_o	= 0;
					//label_reg_write_en_o	= 0;
					//fs_write_en_o		= 0;
					//gs_write_en_o		= 0;
					//mem_write_enable_o	= 0;
				end
			sExecute:
				begin
					//branch_o		= 0;
					//branch_eq_o		= 0;
					//write_enable_o		= 0;
					//write_reg_o 		= 0;
					//alu_control		= 0;
					//spec_reg_write_en_o	= 0;
					//label_reg_write_en_o	= 0;
					//fs_write_en_o		= 0;
					//gs_write_en_o		= 0;
					//mem_write_enable_o	= 0;

					unique casex (opcode)
						`MUL: write_enable_s = 1;
						`ADD: write_enable_s = 1;
						`SUB: write_enable_s = 1;
						`OR: write_enable_s = 1;
						`NOR: write_enable_s = 1;
						`SR: write_enable_s = 1;
						`LW: garbage_s = 0;
						`SW: mem_write_enable_s = 1;
						`BNE: branch_s = 1;
						`BEQ: begin 
								branch_s = 1;
						      branch_eq_s = 1;
								end
						`SLT: write_enable_s = 1;
						`J: branch_s = 1;
						`SET: begin
							write_enable_s = 1;
							write_reg_s = instr_i[I_WIDTH-5 : I_WIDTH-7];
							end
						`SL: begin
							write_enable_s = 1;
							write_reg_s = instr_i[8 : 6];
							end
						`QUIT: garbage_s = 0;
						`IN:  garbage_s = 0;
						`OUT: garbage_s = 0;
						`CALL: fs_write_en_s = 1;
						`RET: garbage_s = 0;
						`PUSH: gs_write_en_s = 1;
						`POP: begin
								write_enable_s = 1;
								gs_write_en_s = 1;
							end
						default: write_enable_s = 0;
					endcase
				end
			sMemory:
			begin
				branch_s		= 0;
				branch_eq_s		= 0;
				write_enable_s		= 0;
				alu_control_s		= 0;
				spec_reg_write_en_s	= 0;
				fs_write_en_s		= 0;
				gs_write_en_s		= 0;
				mem_write_enable_s	= 0;

					unique casex (opcode)
						`LW: write_enable_s = 1;
						`CALL: spec_reg_write_en_s = 1;
						`RET: spec_reg_write_en_s = 1;
						`POP: write_enable_s = 1;
						default: write_enable_s = 0;
					endcase

					if(~dmem_refused_i & opcode === `LW) write_enable_s = 1;
					else write_enable_s = 0;
				end
			sWB:
				begin
					//if(~dmem_refused_i & opcode === `LW) write_enable_s = 1;
					//else write_enable_s = 0;
					//write_enable_s = 1;  //just kidding(special cases?)
					write_enable_s = 0;
					gs_write_en_s = 0;
				end
			sIO:
			begin
				branch_s		= 0;
				branch_eq_s		= 0;
				write_enable_s		= 0;
				alu_control_s		= 0;
				spec_reg_write_en_s	= 0;
				fs_write_en_s		= 0;
				gs_write_en_s		= 0;
				mem_write_enable_s	= 0;
					unique casex (opcode)
						`IN: write_enable_s = 1;
					endcase
					if(in_ack_i) write_enable_s = 1;
					else write_enable_s = 0;
				end
			default: write_enable_s = 0;
		endcase
	end
	
	
	   assign garbage = garbage_s;
		 assign branch_o = branch_s;
		assign  branch_eq_o		= branch_eq_s;
		 assign write_enable_o = write_enable_s;
		assign  write_reg_o 		= write_reg_s;
		assign  alu_control		= alu_control_s;
		assign  spec_reg_write_en_o	= spec_reg_write_en_s;
		//assign label_reg_write_en_o	= 0;
		assign  fs_write_en_o		= fs_write_en_s;
		assign  gs_write_en_o		= gs_write_en_s;
		assign  mem_write_enable_o	= mem_write_enable_s;
		assign  gs_push_o = gs_push_s;
		
		

endmodule
