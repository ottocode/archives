/* Marc Slaughter, Nick Otto
msslaughter@sandiego.edu, nicholasotto@sandiego.edu

Control Module


signals:
b                                               --> restart_i           -->
b                                               --> load_store_valid_i  -->
b                                               --> store_en_i          -->
load_store_valid_i, restart_i, fifo_full, p_bit --> sel_mux             -->
store_en_i                                      --> ram_we              -->
fifo_full                                       --> fifo_enqueue        -->
restart                                         --> fifo_clear          -->
Mr. E                                           --> load_data_valid_o   -->
Mr. E                                           --> instruction_valid_o -->
ip_in.instr                                     --> p_bit               -->

*/

module Control#(parameter A_WIDTH=10, I_WIDTH=17)
	(input	clk,
    input   restart_i,
    input   load_store_valid_i,
    input   store_en_i,
    input   fifo_empty,
    input   fifo_full,
    input   p_bit,
	 input	fifo_valid,
	 output	sel_mux[3:0],
	 output 	ram_we,
	 output	fifo_enqueue,
	 output	fifo_clear,
	 output	load_data_valid_o,
	 output	instruction_valid_o);
	 
		logic load_store_valid_r, restart_r, store_en_r, load_data_valid_r, instruction_valid_r, fifo_clear_r;
		logic 	enqueue_restart_w;
		
		   // validate inputs
   // synthesis translate off
   always_comb
     begin
        if (store_en_r & ~load_store_valid_r)
          $display("Warning: store_en_r set but load_store_valid_r not set!\n");
     end
   // synthesis translate on
		
		
		always_ff @(posedge clk)
		begin
			load_store_valid_r <= load_store_valid_i;
			restart_r <= restart_i;
			store_en_r <= store_en_i;
		end
		
		//load_data_valid_o needs to be delayed another cycle
		always_ff @(posedge clk)
		begin
			load_data_valid_r <= load_store_valid_r;
		end
		
		always_ff @(posedge fifo_enqueue)
		begin
			enqueue_restart_w <= ~( ~enqueue_restart_w & restart_r & fifo_enqueue);
		end
		
		always_ff @(posedge clk)
		begin
			fifo_clear_r <= ~(fifo_clear & fifo_empty) | restart_r;
		end
		
		assign instruction_valid_r = fifo_valid;
		
		/*
		always_ff @(posedge clk)
		begin
			instruction_valid_r <= ( fifo_clear | (instruction_valid_r & ~restart_r & ~fifo_empty));
		end
		*/
		
		assign instruction_valid_o = instruction_valid_r;
		assign fifo_clear = fifo_clear_r;
		assign sel_mux[3] = load_store_valid_r;
		assign sel_mux[2] = ~restart_r;
		assign sel_mux[1] = ~fifo_full & fifo_enqueue;
		assign sel_mux[0] = ~p_bit;
		assign ram_we		= store_en_r;
		assign fifo_enqueue = ~fifo_full & enqueue_restart_w & ~load_store_valid_r;
		assign load_data_valid_o = load_data_valid_r;
		
		
		
	 /*
	 assign sel_mux[3] = load_store_valid_r;	//1 if load_store_valid_r
	 assign sel_mux[2] = restart_r;	// 0 if restart, 1 otherwise
	 assign sel_mux[1] = fifo_full;	// 0 if fifo_full or fifo_enqueue = 0, 1 otherwise
	 assign sel_mux[0] = p_bit;		// 0 if p_bit = 1, 1 otherwise
	 output 	ram_we,						// 1 if load_store_valid_i, 0 otherwise
	 output	fifo_enqueue,				// 0 if fifo_full.  0 after restart, 1 when fifo_empty given. load_store_valid delays enqueue by one.
	 output	fifo_clear,				 	// 1 if restart asserted, 0 when fifo_empty given
	 output	load_data_valid_o,    	// Two cycles after load_store_valid_i, assert
	 output	instruction_valid_o); 	// Directly from fifo.valid_o

	 */


endmodule
