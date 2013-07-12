`timescale 1ns / 1ps

/* 
 * register_file_wrap.sv
 *
 * A simple register file wrapper
 *
 * COMP 300
 * University of San Diego
 *
 * Written by Matt DeVuyst (4/7/2010)
 * Modified by Vikram Bhatt (4/1/2011)
 * Modified by Nikolaos Strikos (4/8/2011)
 *
 */

/*
 * parameters:
 *  NUM_REGS: number of registers
 *  NUM_REGS_LOG: log_2(NUM_REGS)
 *  DATA_WIDTH: width of each register
 */
module register_file_wrap#(parameter NUM_REGS=8, NUM_REGS_LOG=3, DATA_WIDTH=16)
(
	input clk,// Clock to control when write happen.
	input wen_i, // Enable writing to a register.
	input [NUM_REGS_LOG-1:0] ra0_i, // The number of a register to read from.
	input [NUM_REGS_LOG-1:0] ra1_i, // The number of a register to read from.
	input [NUM_REGS_LOG-1:0] wa_i, // The number of a register to write to.
	input [DATA_WIDTH-1:0]   wd_i, // Data to write to a given register.

	output logic [DATA_WIDTH-1:0]  rd0_o, // Data read from a given register.
	output logic [DATA_WIDTH-1:0]  rd1_o // Data read from a given register.
);

logic                    wen_l; // write enable signal
logic [NUM_REGS_LOG-1:0] ra0_l; // read address 0
logic [NUM_REGS_LOG-1:0] ra1_l; // read address 1
logic [NUM_REGS_LOG-1:0] wa_l; // write address
logic [DATA_WIDTH-1:0]   wd_l; // write data
logic [DATA_WIDTH-1:0]   rd0_l; // read data 0
logic [DATA_WIDTH-1:0]   rd1_l; // read data 1

register_file rf
(
	// Inputs
	 .clk (clk)
	,.wen_i	(wen_l)
	,.ra0_i	(ra0_l)
	,.ra1_i (ra1_l)
	,.wa_i (wa_l)
	,.wd_i (wd_l)
	// Outputs
	,.rd0_o (rd0_o)
	,.rd1_o (rd1_o)
);

always_ff @(posedge clk)
begin
	wen_l  <= wen_i;
	ra0_l  <= ra0_i;
	ra1_l  <= ra1_i;
	wa_l   <= wa_i;
	wd_l   <= wd_i;
end

endmodule // register_file_wrap
