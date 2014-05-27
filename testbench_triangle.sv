module testbench_triangle ();

timeunit 10ns;
timeprecision 10ps;

logic clock = 0, resetn = 0;
logic holdn = 0;

logic [7:0] out;

triangle u(.*);

always #1 clock = ~clock;

always #10 holdn = ~holdn;

initial
begin
	resetn = 1'b0;
	//holdn = 1'b1;
	#2 resetn = 1'b1;

	
end

endmodule