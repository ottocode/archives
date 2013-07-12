typedef struct packed {
logic [17-1:0] instr;
logic [10-1:0] addr;
} instr_packet_s;
module test #(parameter A_WIDTH=10, I_WIDTH=17)
(
input clk
,input [A_WIDTH-1:0] addr_i
,input [I_WIDTH-1:0] instr_i
,output [A_WIDTH-1:0] addr_o
,output [I_WIDTH-1:0] instr_o
);
instr_packet_s ip_n, ip_A_r, ip_B_r, ip_C_r;

assign ip_n = '{addr : addr_i
, instr : instr_i };

assign { addr_o, instr_o }
= {ip_C_r.addr, ip_C_r.instr };

always_ff @(posedge clk)
begin
{ ip_A_r, ip_B_r, ip_C_r }
<= { ip_n, ip_A_r, ip_B_r };
end
endmodule
