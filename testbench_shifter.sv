module testbench_shifter ();

timeunit 100ps;
timeprecision 10ps;

logic [15:0] in, out, expected;
logic [3:0] n;
logic [2:0] mode;

shifter u(.*);

int errcount = 0;

initial
begin
	int r = $random;

	n = r[3:0];
	r = $random;
	in = r[15:0];

	in[15] = 1'b1;
	
	#1 mode = 3'b000;
	expected = in;
	#1 if (out != expected) errcount++;

	#1 mode = 3'b001;
	expected = (in >> n);
	#1 if (out != expected) errcount++;

	#1 mode = 3'b010;
	expected = ($signed(in) >>> n);
	#1 if (out != expected) errcount++;
	
	#1 mode = 3'b011;
	expected = ror(in, n);
	#1 if (out != expected) errcount++;

	#1 mode = 3'b100;
	expected = in;
	#1 if (out != expected) errcount++;

	#1 mode = 3'b101;
	expected = (in << n);
	#1 if (out != expected) errcount++;

	#1 mode = 3'b110;
	expected = (in << n);
	#1 if (out != expected) errcount++;
	
	#1 mode = 3'b111;
	expected = rol(in, n);
	#1 if (out != expected) errcount++;
	
	#2
	$display("Done at time %g", $time);
	$display("Error count %d", errcount);
end

function [15:0] ror (logic [15:0] x, logic [3:0] n);
	return (x >> n) | (x << (16 - n));
endfunction

function [15:0] rol (logic [15:0] x, logic [3:0] n);
	return (x << n) | (x >> (16 - n));
endfunction

endmodule