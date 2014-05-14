// pulse for one cycle after the rising edge of a signal
module edgedetect (
	input  logic clock, resetn,
	input  logic in,
	output logic out
);

logic prev_in;

always_ff @ (negedge clock or negedge resetn)
begin
	if (~resetn)
	begin
		prev_in <= in;
		out <= 1'b0;
	end
	else
	begin
		prev_in <= in;
		if (~prev_in & in)
			out <= 1'b1;
		else
			out <= 1'b0;
	end
end

endmodule