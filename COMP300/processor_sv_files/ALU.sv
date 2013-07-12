/* 
*	Authors: Nicholas Otto and Marc Slaughter
*	nicholasotto / msslaughter@sandiego.edu
*	
*	mul, sub, set, shift (l&r), add
*/
`define MUL 7'b0001
`define ADD 7'b0010
`define SUB 7'b0011
`define OR 7'b0100
`define NOR 7'b0101
`define SR 7'b0110
`define LW 7'b0111
`define SW 7'b1000
`define BNE 7'b1001
`define BEQ 7'b1010
`define SLT 7'b1011
`define J 7'b1100
`define SET 7'b1101
`define SL 7'b1110
`define QUIT 7'b1111
`define IN 7'b1111
`define OUT 7'b1111
`define CALL 7'b1111
`define RET 7'b1111
`define PUSH 7'b1111
`define POP 7'b1111

// C_WIDTH : number of bits needed to specify control
// D_WIDTH : data width
module alu#(parameter C_WIDTH=4, D_WIDTH=34)
(
	input clk,
	input [D_WIDTH-1 : 0] input0_i,
	input [D_WIDTH-1 : 0] input1_i,
	input [C_WIDTH-1 : 0] control,
	
	output zero,
	output [D_WIDTH-1 : 0] result
);


	logic [D_WIDTH-1 : 0] mul_s;
	logic [D_WIDTH-1 : 0] set_s;
	logic [D_WIDTH-1 : 0] shift_r_s;
	logic [D_WIDTH-1 : 0] add_s;
	logic [D_WIDTH-1 : 0] sub_s;
	logic [D_WIDTH-1 : 0] or_s;
	logic [D_WIDTH-1 : 0] nor_s;
	logic [D_WIDTH-1 : 0] slt_s;
	logic [D_WIDTH-1 : 0] result_s;

	
	//Mul
	assign mul_s = input0_i * input1_i;

	//Set
	assign set_s = input1_i;
	
	//shift right
	assign shift_r_s = input1_i >> input0_i;
	
	//or
	assign or_s = input0_i | input1_i;
	
	//nor
	assign nor_s = ~(input0_i | input1_i);
	
	//sub
	assign sub_s = input0_i - input1_i;
	
	//sub
	assign add_s = input0_i + input1_i;
	
	//temporary until control implemented
	assign zero = (input0_i == input1_i ? 1 : 0);

	assign slt_s = (sub_s[D_WIDTH-1] ? 1 : 0);
	

	always_comb
	begin
		unique case(control)
			`MUL: result_s = mul_s;
			`ADD: result_s = add_s;
			`SUB: result_s = sub_s;
			`OR: result_s =  or_s;
			`NOR: result_s  = nor_s;
			`SR: result_s  = shift_r_s;
			`LW: result_s  = add_s;
			`SW: result_s  = add_s;
			`SLT: result_s = slt_s;
			default: result_s = 0;
		endcase
	end
  
  assign result = result_s;


endmodule
