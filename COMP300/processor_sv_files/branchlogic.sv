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

// C_WIDTH : number of bits needed to specify control
// D_WIDTH : data width
module branchlogic#(parameter D_WIDTH=34, C_WIDTH=4, S_WIDTH=6, IA_WIDTH=12)
(
	input clk,
	input [6 : 0] operation_i,
	input alu_zero_i,
	input branch_i,
	input branch_eq_i,
	input [S_WIDTH-1 : 0] ls_i,
	input [S_WIDTH-1 : 0] lt_i,
	input [IA_WIDTH-1 : 0] label1_i,
	input [IA_WIDTH-1 : 0] label2_i,
	input [IA_WIDTH-1 : 0] instr_addr_i,
	input [IA_WIDTH-1 : 0] function_pop_addr_i,
	output [IA_WIDTH-1 : 0] restart_addr_o,
	output [IA_WIDTH-1 : 0] next_addr_o,
	output restart_o
);

	logic restart_s;
	logic [IA_WIDTH-1 : 0] restart_addr_s;
	logic [IA_WIDTH-1 : 0] normal_next;
	assign normal_next = instr_addr_i + 1;

always_comb
	begin
		unique casex(operation_i)
			`BNE: begin
				restart_addr_s = alu_zero_i ? normal_next : label1_i;
				restart_s = ~alu_zero_i;
				end
			`BEQ: begin
				restart_addr_s = alu_zero_i ? label1_i : normal_next;
				restart_s = alu_zero_i;
				end
			`J: begin
				restart_addr_s = label1_i + label2_i;
				restart_s = 1;
				end
			default: begin
				restart_addr_s = normal_next;
				restart_s = 0;
				end
		endcase
	end
	
	assign restart_addr_o = restart_addr_s;
	assign restart_o = restart_s;



endmodule