module register_file#(parameter D_WIDTH=34, NUM_REG=8, SEL_WIDTH = 3)
							(input clk, wen_i,
						    input [SEL_WIDTH-1:0] wa_i, ra0_i, ra1_i, ra2_i,
						    input [D_WIDTH-1:0] wd_i,
						    output [D_WIDTH-1:0] rd0_o, rd1_o, rd2_o);

logic [D_WIDTH-1:0] rf [NUM_REG-1:0];

assign rd0_o = rf[ra0_i];
assign rd1_o = rf[ra1_i];
assign rd2_o = rf[ra2_i];

always_ff @(posedge clk) //enable SystemVerilog to make always_ff work!
begin
	rf[wa_i] <= (wen_i) ? wd_i : rf[wa_i]; //if wen_i, write data to rf
end

endmodule