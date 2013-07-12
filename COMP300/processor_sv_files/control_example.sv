// define what opcode will be for different instructions
`define RTYPE_OP 3'b000
`define LW_OP 3'b001
`define SW_OP 3'b010
`define BEQ_OP 3'b011
`define IO_OP 3'b111

// define how we interpret the instruction
`define OPCODE_UPPER 15
`define OPCODE_LOWER 13
`define IO_BIT 9

module backend_control#(parameter I_WIDTH=17, IA_WIDTH=12)
(
	input clk,
	input reset_i,
	
	input [I_WIDTH-1 : 0] instruction_data_i,
	input instruction_valid_i,
	input [IA_WIDTH-1 : 0] pc_next_i,
	
	input dmem_refused_i,
	
	output logic dmem_req_o,
	output logic dmem_wen_o,
	output logic rf_wen_o,
	output logic branch_o,
	output logic alu_in_sel_o,
	output logic [1:0] rf_write_data_src_sel_o,
	output logic in_req_o,
	output logic out_req_o,
	output logic [2 : 0] alu_op_o,
	
	output logic dequeue_o,
	output logic restart_o,
	output logic [IA_WIDTH-1 : 0] restart_addr_o
);

	// relabeling wires for convenience
	logic [2 : 0] opcode;
	logic io_bit;
	assign opcode = instruction_data_i[`OPCODE_UPPER:`OPCODE_LOWER];
	assign io_bit = instruction_data_i[`IO_BIT];

	typedef enum { sDecode, sExecute, sMemory, sIO } state_s;
	state_s substate_r, substate_next;
	
	always_ff @ (posedge clk)
	begin
		substate_r <= reset_i ? sDecode : substate_next;
	end

	// use combinational logic to calculate next stage
	always_comb
	begin
		unique case (substate_r)
			sDecode: substate_next = instruction_valid_i ? sExecute : sDecode
			sExecute:
			begin
				unique casex (opcode)
					`BEQ_OP: substate_next = sDecode;
					`LW_OP: substate_next = sMemory;
					`SW_OP: substate_next = sMemory;
					`IO_OP: substate_next = sIO;
					default: substate_next = sDecode;
				endcase
			end
			sMemory:
			begin
				if(dmem_refused_i) substate_next = sMemory;
				else substate_next = sDecode;
			end
			sIO:
			begin
				if(~in_ack_i & ~out_ack_i) substate_next = sIO;
				else substate_next = sDecode;
			end
			default: substate_next = sDecode;
		endcase
	end

	// calculate other control signals
	always_comb
	begin
		rf_wen_o = 0;

		unique case (substate_r)
			sExecute:
			begin
				unique casex (opcode)
					`RTYPE_OP: rf_wen_o = 1;
					default: rf_wen_o = 0;
				endcase
			end
			sMemory:
			begin
				if(~dmem_refused_i & opcode === `LW_OP) rf_wen_o;
				else rf_wen_o = 0;
			end
			sIO:
			begin
				if(in_ack_i) rf_wen_o = 1;
				else rf_wen_o = 0;
			end
			default: rf_wen_o = 0;
		endcase
	end
endmodule
