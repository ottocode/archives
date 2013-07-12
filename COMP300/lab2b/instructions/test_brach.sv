/*
 * test_branch.sv
 *
 * A test bench to see if branches/jumps are working correctly in the fetch unit.
 */

`timescale 1ns/1ps

module test_branch#(parameter PERIOD=20, DUTY_CYCLE=0.5, OFFSET=100);
    logic clk = 1'b0;
    logic dequeue = 1'b0;
    logic restart = 1'b0;
    logic [9:0] restart_addr = 10'b0000000000;
    logic load_store_valid = 1'b0;
    logic store_en = 1'b0;
    logic [9:0] load_store_addr = 10'b0000000000;
    logic [16:0] store_data = 17'b00000000000000000;
    logic [16:0] load_data;
    logic load_data_valid;
    logic [16:0] instruction_data;
    logic [9:0] instruction_addr;
    logic instruction_valid;

    initial    // Clock process for clk
    begin
        #OFFSET;
        forever
        begin
            clk = 1'b0;
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
            #(PERIOD*DUTY_CYCLE);
        end
    end

    fetch dut
	(
        .clk(clk),
        .dequeue_i(dequeue),
        .restart_i(restart),
        .restart_addr_i(restart_addr),
        .load_store_valid_i(load_store_valid),
        .store_en_i(store_en),
        .load_store_addr_i(load_store_addr),
        .store_data_i(store_data),
        .load_data_o(load_data),
        .load_data_valid_o(load_data_valid),
        .instruction_data_o(instruction_data),
        .instruction_addr_o(instruction_addr),
        .instruction_valid_o(instruction_valid)
	);

    initial
	begin
        // -------------  Current Time:  120ns
        @(negedge clk)
        load_store_valid = 1'b1;
        store_en = 1'b1;
        load_store_addr = 10'b0000000010;
        store_data = 17'b10000000000000101;
        // -------------------------------------
        // -------------  Current Time:  140ns
        @(negedge clk)
        load_store_addr = 10'b0000000111;
        store_data = 17'b10000000000011001;
        // -------------------------------------
        // -------------  Current Time:  160ns
        @(negedge clk)
        load_store_valid = 1'b0;
        store_en = 1'b0;
        load_store_addr = 10'b0000000001;
        store_data = 17'b00000000000000001;
        // -------------------------------------
        // -------------  Current Time:  200ns
        @(negedge clk)
        @(negedge clk)
        restart = 1'b1;
        // -------------------------------------
        // -------------  Current Time:  220ns
        @(negedge clk)
        restart = 1'b0;
        // -------------------------------------
        // -------------  Current Time:  280ns
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        dequeue = 1'b1;
        // -------------------------------------
        // -------------  Current Time:  320ns
        @(negedge clk)
        @(negedge clk)
        dequeue = 1'b0;
        // -------------------------------------
        // -------------  Current Time:  400ns
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        restart = 1'b1;
        restart_addr = 10'b0000000011;
        // -------------------------------------
        // -------------  Current Time:  420ns
        @(negedge clk)
        restart = 1'b0;
        restart_addr = 10'b0000000001;
        // -------------------------------------
        // -------------  Current Time:  480ns
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        dequeue = 1'b1;
        // -------------------------------------
        // -------------  Current Time:  640ns
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        dequeue = 1'b0;
        // -------------------------------------
    end

endmodule

