
`timescale 1ns/1ps

module aaabackend_test#(parameter PERIOD=20, DUTY_CYCLE=0.5, OFFSET=100, D_WIDTH = 34, PA_WIDTH = 4, IA_WIDTH=12, I_WIDTH=13);

	logic clk;
	logic reset_i;											//to reset to 0x0
	// inputs from the fetch unit
	logic [I_WIDTH-1 : 0] instruction_data_i;		// the instruction
	logic [IA_WIDTH-1 : 0] instruction_addr_i;	// the addr of instruction
	logic instruction_valid_i;							// if instruction was good
	
	// outputs to the fetch unit
	logic dequeue_o;
	logic restart_o;
	logic [IA_WIDTH-1 : 0] restart_addr_o;
	logic load_store_valid_o;
	logic store_en_o;
	logic [IA_WIDTH-1 : 0] load_store_addr_o;
	logic [I_WIDTH-1 : 0] store_data_o;

	// I/O interface
	logic in_req_o;
	logic out_req_o;
	logic [PA_WIDTH-1 : 0] in_addr_o;
	logic [PA_WIDTH-1 : 0] out_addr_o;
	logic [D_WIDTH-1 : 0] in_data_i;
	logic [D_WIDTH-1 : 0] out_data_o;
	logic in_ack_i;
	logic out_ack_i;
    
    
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

	Backend backend_dut
(
	.clk(clk),
	.reset_i(reset_i),
	.instruction_data_i(instruction_data_i),
	.instruction_addr_i(instruction_addr_i),
	.instruction_valid_i(instruction_valid_i), 
	
	.dequeue_o(dequeue_o),
	.restart_o(restart_o),
	.restart_addr_o(restart_addr_o),
	.load_store_valid_o(load_store_valid_o),
	.store_en_o(store_en_o),
	.load_store_addr_o(load_store_addr_o),
	.store_data_o(store_data_o),
	
	.in_req_o(in_req_o),
	.out_req_o(out_req_o),
	.in_addr_o(in_addr_o),
	.out_addr_o(out_addr_o),
	.in_data_i(in_data_i),
	.out_data_o(out_data_o),
	.in_ack_i(in_ack_i),
	.out_ack_i(out_ack_i)
);
	/* Label Register File 
labelregfile labelregfiler(
	.clk(clk)
	,.write_enable_i(label_reg_write_en_s)
	,.write_reg_i(label_write_reg_s)
	,.write_data_i(label_write_data_s)
	,.label1_i(label_raw_s)
	,.label_o(label_val_s)
);
	*/
	
	
	

    initial
	begin

        // -------------  Current Time:  200ns
        @(negedge clk) $display("\t\tclock edge");
        @(negedge clk) $display("\t\tclock edge");
        reset_i = 1;
        @(negedge clk) $display("\t\tclock edge");
        reset_i = 0;
		instruction_valid_i = 0;
        @(negedge clk) $display("\t\tclock edge");
		@(negedge clk) $display("\t\tclock edge");
		
		backend_dut.label_reg_write_en_s = 1;
		backend_dut.label_write_reg_s = 6'b000001;
		backend_dut.label_write_data_s = 80;
		
		@(negedge clk) $display("\t\tclock edge");
		backend_dut.label_reg_write_en_s = 1;
		backend_dut.label_write_reg_s = 6'b000110;
		backend_dut.label_write_data_s = 45;
		
		@(negedge clk) $display("\t\tclock edge");
		backend_dut.label_reg_write_en_s = 1;
		backend_dut.label_write_reg_s = 6'b000000;
		backend_dut.label_write_data_s = 48;
		
		@(negedge clk) $display("\t\tclock edge");
		backend_dut.label_reg_write_en_s = 0;
        @(negedge clk) $display("\t\tclock edge");
		
		/*MONITORS*/
		$monitor("control write enable: %b, writing: %b to register: %b\n", backend_dut.controler.write_enable_s, backend_dut.genregfiler.write_data_i, backend_dut.write_reg_s);
		//$monitor("\tALU1_i: %b, ALU2_i: %b", backend_dut.alu1_s, backend_dut.alu2_s);
		/* ALU TESTS */
		/* 	
			set $0,3 		1101 000 000 011	//0 = 3
			set $1,1 		1101 000 000 001	//$1 = 1
			mul $2,$1,$0	0001 001 000 010  	//$2 = 3
			add $2,$2,$0	0010 010 000 010	//$2 = 6
			sub $2,$2,$1	0011 010 001 010	//$2 = 5
			or  $2,$2,$0	0100 010 000 010	//$2 = 7
			nor $2,$2,$2	0101 010 010 010	//$2 = 111...111 000
			sr	$2,$2,$1	0110 010 001 010	//$2 = 0001111...111
			add $2,$2,$1	0010 010 001 010	//$2 = 0010000...000
		*/
		
			instruction_data_i = 13'b1101000000011;  		//0 = 3
			instruction_addr_i = 0;
			instruction_valid_i = 1;
		$display("into register file: rs: %b, rt: %b, rd: %b", backend_dut.rs_s, backend_dut.rt_s, backend_dut.rd_s);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("instruction: %b", backend_dut.controler.instr_i);
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("\n Next Instruction SET r1 = 1\n");
		
			instruction_data_i = 13'b1101001000001;		//$1 = 1
			instruction_addr_i = 0;
			instruction_valid_i = 1;
		$display("into register file: rs: %b, rt: %b, rd: %b", backend_dut.rs_s, backend_dut.rt_s, backend_dut.rd_s);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("instruction: %b", backend_dut.controler.instr_i);
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("\n Next Instruction MUL r2 = r0*r1\n");
		
			instruction_data_i = 13'b0001001000010;  	//$2 = 3
			instruction_addr_i = 0;
			instruction_valid_i = 1;
		$display("into register file: rs: %b, rt: %b, rd: %b", backend_dut.rs_s, backend_dut.rt_s, backend_dut.rd_s);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("instruction: %b", backend_dut.controler.instr_i);
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("ALU result: %b, \n\tfrom: %b, and: %b\n\twith control: %b", backend_dut.alur.result, backend_dut.alur.input0_i, backend_dut.alur.input1_i, backend_dut.alur.control);
		@(negedge clk) $display("\t\tclock edge");
		
		
		@(negedge clk) $display("\t\tclock edge");
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("\n Next Instruction ADD r2 = r2*r0\n");
		
			instruction_data_i = 13'b0010010000010;	//$2 = 6
			instruction_addr_i = 0;
			instruction_valid_i = 1;
		$display("into register file: rs: %b, rt: %b, rd: %b", backend_dut.rs_s, backend_dut.rt_s, backend_dut.rd_s);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("instruction: %b", backend_dut.controler.instr_i);
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("ALU result: %b, \n\tfrom: %b, and: %b\n\twith control: %b", backend_dut.alur.result, backend_dut.alur.input0_i, backend_dut.alur.input1_i, backend_dut.alur.control);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("\n Next Instruction SUB r2 = r2-r1\n");
		
			instruction_data_i = 13'b0011010001010;	//$2 = 5
			instruction_addr_i = 0;
			instruction_valid_i = 1;
		$display("into register file: rs: %b, rt: %b, rd: %b", backend_dut.rs_s, backend_dut.rt_s, backend_dut.rd_s);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("instruction: %b", backend_dut.controler.instr_i);
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("ALU result: %b, \n\tfrom: %b, and: %b\n\twith control: %b", backend_dut.alur.result, backend_dut.alur.input0_i, backend_dut.alur.input1_i, backend_dut.alur.control);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("\n Next Instruction OR r2 = r2||r0\n");
		
			instruction_data_i = 13'b0100010000010;	//$2 = 7
			instruction_addr_i = 0;
			instruction_valid_i = 1;
		$display("into register file: rs: %b, rt: %b, rd: %b", backend_dut.rs_s, backend_dut.rt_s, backend_dut.rd_s);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("instruction: %b", backend_dut.controler.instr_i);
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("ALU result: %b, \n\tfrom: %b, and: %b\n\twith control: %b", backend_dut.alur.result, backend_dut.alur.input0_i, backend_dut.alur.input1_i, backend_dut.alur.control);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("\n Next Instruction NOR r2 = ~(r2||r0)\n");
		
			instruction_data_i = 13'b0101010010010;	//$2 = 111...111 000
			instruction_addr_i = 0;
			instruction_valid_i = 1;
		$display("into register file: rs: %b, rt: %b, rd: %b", backend_dut.rs_s, backend_dut.rt_s, backend_dut.rd_s);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("instruction: %b", backend_dut.controler.instr_i);
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("ALU result: %b, \n\tfrom: %b, and: %b\n\twith control: %b", backend_dut.alur.result, backend_dut.alur.input0_i, backend_dut.alur.input1_i, backend_dut.alur.control);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("\n Next Instruction SR r2 = r2>>r0\n");
		
			instruction_data_i = 13'b0110000010010;	//$2 = 0001111...111
			instruction_addr_i = 0;
			instruction_valid_i = 1;
		$display("into register file: rs: %b, rt: %b, rd: %b", backend_dut.rs_s, backend_dut.rt_s, backend_dut.rd_s);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("instruction: %b", backend_dut.controler.instr_i);
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("ALU result: %b, \n\tfrom: %b, and: %b\n\twith control: %b", backend_dut.alur.result, backend_dut.alur.input0_i, backend_dut.alur.input1_i, backend_dut.alur.control);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("\n Next Instruction ADD r2 = r2+r1\n");
		
			instruction_data_i = 13'b0010010001010;	//$2 = 0010000...000
			instruction_addr_i = 0;
			instruction_valid_i = 1;
		$display("into register file: rs: %b, rt: %b, rd: %b", backend_dut.rs_s, backend_dut.rt_s, backend_dut.rd_s);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("instruction: %b", backend_dut.controler.instr_i);
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("ALU result: %b, \n\tfrom: %b, and: %b\n\twith control: %b", backend_dut.alur.result, backend_dut.alur.input0_i, backend_dut.alur.input1_i, backend_dut.alur.control);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("\n Next Instruction SLT\n");
		
		instruction_data_i = 13'b1011000010010;	//$2 = 0010000...000
			instruction_addr_i = 0;
			instruction_valid_i = 1;
		$display("into register file: rs: %b, rt: %b, rd: %b", backend_dut.rs_s, backend_dut.rt_s, backend_dut.rd_s);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("instruction: %b", backend_dut.controler.instr_i);
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("ALU result: %b, \n\tfrom: %b, and: %b\n\twith control: %b", backend_dut.alur.result, backend_dut.alur.input0_i, backend_dut.alur.input1_i, backend_dut.alur.control);
        
		@(negedge clk) $display("\t\tclock edge");
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
        
		@(negedge clk) $display("\t\tclock edge");
		
		$display("\n Next Instruction BNE\n");
		
			instruction_data_i = 13'b1001000010000;	
			instruction_addr_i = 12'b000000000000;
			instruction_valid_i = 1;
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("restart: %b, restart_addr: %b", backend_dut.restart_o, backend_dut.restart_addr_o);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("restart: %b, restart_addr: %b", backend_dut.restart_o, backend_dut.restart_addr_o);
		$display("branchlogicer inputs op: %b, alu_zero: %b, label1_i: %b", backend_dut.branchlogicer.operation_i, backend_dut.branchlogicer.alu_zero_i, backend_dut.branchlogicer.label1_i);
		$display("alu inputs: %b, %b", backend_dut.alu1_s, backend_dut.alu2_s);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("restart: %b, restart_addr: %b", backend_dut.restart_o, backend_dut.restart_addr_o);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("restart: %b, restart_addr: %b", backend_dut.restart_o, backend_dut.restart_addr_o);
		
		$display("\n Next Instruction BEQ\n");
		
			instruction_data_i = 13'b1010001010110;	
			instruction_addr_i = 12'b000000000000;
			instruction_valid_i = 1;
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("restart: %b, restart_addr: %b", backend_dut.restart_o, backend_dut.restart_addr_o);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("restart: %b, restart_addr: %b", backend_dut.restart_o, backend_dut.restart_addr_o);
		$display("branchlogicer inputs op: %b, alu_zero: %b, label1_i: %b", backend_dut.branchlogicer.operation_i, backend_dut.branchlogicer.alu_zero_i, backend_dut.branchlogicer.label1_i);
		$display("alu inputs: %b, %b", backend_dut.alu1_s, backend_dut.alu2_s);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("restart: %b, restart_addr: %b", backend_dut.restart_o, backend_dut.restart_addr_o);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("restart: %b, restart_addr: %b", backend_dut.restart_o, backend_dut.restart_addr_o);
		
		$display("\n Next Instruction JUMP\n");
		
			instruction_data_i = 13'b1100000000110;	
			instruction_addr_i = 12'b000000000000;
			instruction_valid_i = 1;
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("restart: %b, restart_addr: %b", backend_dut.restart_o, backend_dut.restart_addr_o);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("restart: %b, restart_addr: %b", backend_dut.restart_o, backend_dut.restart_addr_o);
		$display("branchlogicer inputs op: %b, alu_zero: %b, label1_i: %b, label2_i: %b", backend_dut.branchlogicer.operation_i, backend_dut.branchlogicer.alu_zero_i, backend_dut.branchlogicer.label1_i, backend_dut.branchlogicer.label2_i);
		$display("alu inputs: %b, %b", backend_dut.alu1_s, backend_dut.alu2_s);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("restart: %b, restart_addr: %b", backend_dut.restart_o, backend_dut.restart_addr_o);
		
		$display("\n Next Instruction Shift Left\n");
		
			instruction_data_i = 13'b1110010000100;	
			instruction_addr_i = 12'b000000000000;
			instruction_valid_i = 1;
		$display("into register file: rs: %b, rt: %b, rd: %b", backend_dut.rs_s, backend_dut.rt_s, backend_dut.rd_s);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		
		@(negedge clk) $display("\t\tclock edge");
		$display("restart: %b, restart_addr: %b", backend_dut.restart_o, backend_dut.restart_addr_o);
		$display("instruction: %b", backend_dut.controler.instr_i);
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("Shift val_s: %b, rsi: %b", backend_dut.setshiftmuxer.shift_val_s, backend_dut.setshiftmuxer.rs_i);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		
        
		@(negedge clk) $display("\t\tclock edge");
		$display("opcode: %b, current: %s, next: %s", backend_dut.controler.opcode, backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		$display("Shift val_s: %b, rsi: %b", backend_dut.setshiftmuxer.shift_val_s, backend_dut.setshiftmuxer.rs_i);
		$display("states: current: %s, next: %s", backend_dut.controler.substate_r, backend_dut.controler.substate_next);
		       

		@(negedge clk) $display("\t\tclock edge");
		reset_i = 1;
        @(negedge clk) $display("\t\tclock edge");
        reset_i = 0;
		instruction_valid_i = 0;
		@(negedge clk) $display("\t\tclock edge");

    end

endmodule

