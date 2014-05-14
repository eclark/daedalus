module testbench_edgedetect ();

timeunit 10ns;
timeprecision 1ns;

logic clock = 0, resetn = 0;
logic in, out;

edgedetect u(.*);

always #1 clock = ~clock;

initial
begin
	resetn = 1'b0;
	in = 1'b0;
	#2 resetn = 1'b1;

	#4 in = 1'b1;
	#1 in = 1'b0;
	
	#4 in = 1'b1;
	#2 in = 1'b0;
	
	
	#4 in = 1'b1;
	#1 in = 1'b0;
	
	#4 in = 1'b1;
	#3 in = 1'b0;
	
	#4 in = 1'b1;
	#3 in = 1'b0;
	
end

endmodule