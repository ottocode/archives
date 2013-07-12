/* Marc Slaughter msslaughter@sandiego.edu and
	Nick Otto 		nicholasotto@sandiego.edu
	*/
typedef struct packed {
	bit [17-1:0] instr;
	logic [10-1:0] addr;
} instr_packet_s;