module triangle (
	input  logic       clock, resetn, holdn,
	output logic [7:0] out
);

logic down;
logic [15:0] prev_count;
wire [15:0] count;

assign out = count;

counter u0 (.clock, .resetn, .holdn, .down, .count);

always_ff @ (posedge clock or negedge resetn)
begin
	if (~resetn)
	begin
		down <= 1'b0;
		prev_count <= 16'd0;
	end
	else
	begin
		prev_count <= count;
		if (holdn && ((count[7:0] == 8'hfe && ~down) || (count[7:0] == 8'h01 && down)))
			down <= ~down;
		else
			down <= down;
	end
end

endmodule