module ram (
	input logic clock, reset_n,
	input logic reg_load_ub, reg_load_lb, reg_sel,
	input logic read, write,
	
	input logic [15:0] reg_d,
	output logic [15:0] reg_q,
	
	output logic ram_ce_n, ram_oe_n, ram_ub_n, ram_lb_n, ram_we_n,
	output logic [17:0] ram_a,
	inout logic [15:0] ram_d
);

logic load_mar, load_mdr;
logic [15:0] r_d, r_q, mar_q, mdr_q, regmask, masked_d;

// Registers
reg16 mar (.clock, .resetn(reset_n), .load(load_mar), .d(r_d), .q(mar_q));
reg16 mdr (.clock, .resetn(reset_n), .load(load_mdr), .d(r_d), .q(mdr_q));

assign regmask = { {8{reg_load_ub}}, {8{reg_load_lb}} }; 
assign masked_d = (reg_d & regmask) | (reg_q & ~regmask);

assign reg_q = reg_sel ? mar_q : mdr_q;

always_comb
begin
	if (read)
	begin
		load_mar = 1'b0;
		load_mdr = 1'b1;
		r_d = ram_d;
	end
	else
	begin
		load_mar = reg_sel & (reg_load_ub | reg_load_lb);
		load_mdr = ~reg_sel & (reg_load_ub | reg_load_lb);
		r_d = masked_d;
	end
end

// Drive SRAM signals

assign ram_ce_n = 1'b0;
assign ram_oe_n = 1'b0;
assign ram_ub_n = 1'b0;
assign ram_lb_n = 1'b0;
assign ram_we_n = ~write;
assign ram_d = ram_we_n ? 'Z : mdr_q;
assign ram_a = { 2'b00, mar_q };

endmodule
