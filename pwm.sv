module pwm (
	input clock, resetn,
	input enable,
	input [7:0] duty,
	output logic out
);

logic [7:0] count;

assign out = enable ? count < duty : 1'b0;

always_ff @ (posedge clock or negedge resetn)
begin
	if (~resetn)
		count <= 8'd0;
	else
		count <= count + 8'd1;
end

endmodule