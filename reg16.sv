module reg16 (
	input  logic        clock, resetn, load,
	input  logic [15:0] d,
	output logic [15:0] q
);

always_ff @ (posedge clock or negedge resetn)
begin
	if (~resetn)
		q <= 16'd0;
	else if (load)
		q <= d;
	else
		q <= q;
end

endmodule