module upcount (
	input clock, resetn, holdn,
	output [15:0] count
);

reg [15:0] val;

assign count = val;

always_ff @ (posedge clock or negedge resetn)
begin
	if (~resetn)
		val <= 16'h0000;
	else if (holdn)
		val <= val + 16'd1;
	else
		val <= val;
end

endmodule