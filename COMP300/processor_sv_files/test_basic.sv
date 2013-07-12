
`timescale 1ns/1ps

module AAanOveralTest#(parameter PERIOD=20, DUTY_CYCLE=0.5, OFFSET=100, D_WIDTH = 34, PA_WIDTH = 4, IA_WIDTH=10, I_WIDTH=13);

	logic [D_WIDTH-1 : 0] in_data_i = 0;
	logic in_ack_i = 0;
	logic out_ack_i = 0;
	logic in_req_o;
	logic out_req_o;
	logic [PA_WIDTH-1 : 0] in_addr_o;
	logic [PA_WIDTH-1 : 0] out_addr_o;
	logic [D_WIDTH-1 : 0] out_data_o;
  logic clk = 1'b0;
  logic reset_i = 1'b0;
    
    
    initial    // Clock process for clk
    begin
        #OFFSET;
        forever
        begin
            clk = 1'b0;
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
            #(PERIOD*DUTY_CYCLE) clk = 1'b0;
        end
    end

    Core dut
	(
        .clock(clk),
        .reset_i(reset_i),
        .in_data_i(in_data_i),
	     .in_ack_i(in_ack_i),
	     .out_ack_i(out_ack_i),
	     .in_req_o(in_req_o),
	     .out_req_o(out_req_o),
	     .in_addr_o(in_addr_o),
	     .out_addr_o(out_addr_o),
	     .out_data_o(out_data_o)
	);

    initial
	begin
        // -------------  Current Time:  200ns
        @(negedge clk)
        @(negedge clk)
        reset_i = 1;
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
		        reset_i = 0;
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
		@(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
		@(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
		@(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
		@(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
		@(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
		@(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
		@(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
		@(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        
`define BEHAVIOURAL        
//`ifdef BEHAVIOURAL
//        $monitor("rptr: %x",dut.fetch_fifo.rptr_r);
//`endif
        
        // -------------------------------------
        // -------------  Current Time:  340ns
        @(negedge clk)
        // -------------------------------------
        // -------------  Current Time:  360ns
        @(negedge clk)        // -------------------------------------
        // -------------  Current Time:  400ns
        @(negedge clk)
        @(negedge clk)

        // -------------------------------------
        // -------------  Current Time:  460ns
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        reset_i = 1;


    end

endmodule

