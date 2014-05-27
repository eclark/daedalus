// Funnel shifter

/*
	Mode
	000 nop
	001 logical right
	010 arithmetic right
	011 rotate right
	100 nop
	101 logical left
	110 arithmetic left
	111 rotate left
*/

module shifter (
	input  logic [15:0] in,
	output logic [15:0] out,
	input  logic [2:0] mode,
	input  logic [3:0] n
);

logic [3:0] k;
logic [30:0] z;

always_comb
begin
	unique case (mode)
		3'b000, 3'b100, 3'b001 : z = { 15'd0, in };
		3'b010 : z = { {15{in[15]}}, in };
		3'b011 : z = { in[14:0], in };
		3'b101, 3'b110 : z = { in, 15'd0 };
		3'b111 : z = { in, in[15:1] };
		default : z = 'X;
	endcase
end

always_comb
begin
	unique case (mode)
		3'b000, 3'b100 : k = 4'd0;
		3'b001, 3'b010, 3'b011 : k = n;
		3'b101, 3'b110, 3'b111 : k = ~n;
		default : k = 'X;
	endcase
end

always_comb
begin
	unique case (k)
		4'h0 : out = z[15:0];
		4'h1 : out = z[16:1];
		4'h2 : out = z[17:2];
		4'h3 : out = z[18:3];
		4'h4 : out = z[19:4];
		4'h5 : out = z[20:5];
		4'h6 : out = z[21:6];
		4'h7 : out = z[22:7];
		4'h8 : out = z[23:8];
		4'h9 : out = z[24:9];
		4'hA : out = z[25:10];
		4'hB : out = z[26:11];
		4'hC : out = z[27:12];
		4'hD : out = z[28:13];
		4'hE : out = z[29:14];
		4'hF : out = z[30:15];
		default : out = 'X;
	endcase
end

endmodule