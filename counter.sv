module counter (
	input         clock, resetn, holdn, down,
	output [15:0] count
);

reg [15:0] val;

assign count = val;

always_ff @ (posedge clock or negedge resetn)
begin
	if (~resetn)
		val <= 16'h0000;
	else if (holdn)
		val <= down ? (val - 16'd1) : (val + 16'd1);
	else
		val <= val;
end

endmodule