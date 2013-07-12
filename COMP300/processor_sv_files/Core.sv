/* 
*	Authors: Nicholas Otto and Marc Slaughter
*	nicholasotto / msslaughter@sandiego.edu
*/

// D_WIDTH : data width
// PA_WIDTH : port (i.e. IO channel) address width
module Core#(parameter D_WIDTH = 34, PA_WIDTH = 4, IA_WIDTH=10, I_WIDTH=13)
(
	input clock,
	input reset_i,
	// I/O interface
	input [D_WIDTH-1 : 0] in_data_i,
	input in_ack_i,
	input out_ack_i,
	output in_req_o,
	output out_req_o,
	output [PA_WIDTH-1 : 0] in_addr_o,
	output [PA_WIDTH-1 : 0] out_addr_o,
	output [D_WIDTH-1 : 0] out_data_o
);

/* Fetch Unit */
	logic dequeue_f, restart_f, load_store_valid_f, store_en_f, load_data_valid_f, instruction_valid_f;
	logic [IA_WIDTH-1 : 0] restart_addr_f;
	logic [IA_WIDTH-1 : 0] load_store_addr_f;
	logic [IA_WIDTH-1 : 0] instruction_addr_f;
	logic [I_WIDTH-1 : 0] store_data_f;
	logic [I_WIDTH-1 : 0] instruction_data_f;
	logic [I_WIDTH-1 : 0] load_data_f;
// Instantiate the front end (fetch)
fetch fetcher(
	.clk(clock)
	,.dequeue_i(dequeue_f)
	,.restart_i(restart_f)
	,.restart_addr_i(restart_addr_f)
	,.load_store_valid_i(load_store_valid_f)
	,.store_en_i(store_en_f)
	,.load_store_addr_i(load_store_addr_f)
	,.store_data_i(store_data_f)
	,.load_data_o(load_data_f)
	,.load_data_valid_o(load_data_valid_f)
	,.instruction_data_o(instruction_data_f)
	,.instruction_addr_o(instruction_addr_f)
	,.instruction_valid_o(instruction_valid_f)
	);
	
	/*Backend */
    logic [PA_WIDTH-1 : 0] in_addr_i;
    logic [PA_WIDTH-1 : 0] out_addr_i;
    logic [D_WIDTH-1 : 0] out_data_i;
    logic in_ack_o, out_ack_o;
Backend backender(
    .clk(clock)
    ,.reset_i(reset_i)
    ,.instruction_data_i(instruction_data_f)
    ,.instruction_addr_i(instruction_addr_f)
    ,.instruction_valid_i(instruction_valid_f)
    ,.dequeue_o(dequeue_f)
    ,.restart_o(restart_f)
    ,.restart_addr_o(restart_addr_f)
    ,.load_store_valid_o(load_store_valid_f)
    ,.store_en_o(store_en_f)
    ,.load_store_addr_o(load_store_addr_f)
    ,.store_data_o(store_data_f)
    ,.in_req_o(in_ack_i)
    ,.out_req_o(out_ack_i)
    ,.in_addr_o(in_addr_i)
    ,.out_addr_o(out_addr_i)
    ,.in_data_i(in_data_o)
    ,.out_data_o(out_data_i)
    ,.in_ack_i(in_ack_o)
    ,.out_ack_i(out_ack_o)
    );
	 


endmodule
