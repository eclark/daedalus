`include "defs.sv"


module daedalus(

	//////////// CLOCK //////////
	CLOCK_125_p,
	CLOCK_50_B5B,
	CLOCK_50_B6A,
	CLOCK_50_B7A,
	CLOCK_50_B8A,

	//////////// LED //////////
	LEDG,
	LEDR,

	//////////// KEY //////////
	CPU_RESET_n,
	KEY,

	//////////// SW //////////
	SW,

	//////////// SEG7 //////////
	HEX0,
	HEX1,
	HEX2,
	HEX3,

	//////////// HDMI-TX //////////
	HDMI_TX_CLK,
	HDMI_TX_D,
	HDMI_TX_DE,
	HDMI_TX_HS,
	HDMI_TX_INT,
	HDMI_TX_VS,

	//////////// ADC SPI //////////
	ADC_CONVST,
	ADC_SCK,
	ADC_SDI,
	ADC_SDO,

	//////////// Audio //////////
	AUD_ADCDAT,
	AUD_ADCLRCK,
	AUD_BCLK,
	AUD_DACDAT,
	AUD_DACLRCK,
	AUD_XCK,

	//////////// I2C for Audio/HDMI-TX/Si5338/HSMC //////////
	I2C_SCL,
	I2C_SDA,

	//////////// SDCARD //////////
	SD_CLK,
	SD_CMD,
	SD_DAT,

	//////////// Uart to USB //////////
	UART_RX,
	UART_TX,

`ifdef ENABLE_LPDDR2
	//////////// LPDDR2 //////////
	DDR2LP_CA,
	DDR2LP_CK_n,
	DDR2LP_CK_p,
	DDR2LP_CKE,
	DDR2LP_CS_n,
	DDR2LP_DM,
	DDR2LP_DQ,
	DDR2LP_DQS_n,
	DDR2LP_DQS_p,
	DDR2LP_OCT_RZQ,
`endif

	//////////// SRAM //////////
	SRAM_A,
	SRAM_CE_n,
	SRAM_D,
	SRAM_LB_n,
	SRAM_OE_n,
	SRAM_UB_n,
	SRAM_WE_n
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input 		          		CLOCK_125_p;
input 		          		CLOCK_50_B5B;
input 		          		CLOCK_50_B6A;
input 		          		CLOCK_50_B7A;
input 		          		CLOCK_50_B8A;

//////////// LED //////////
output		     [7:0]		LEDG;
output		     [9:0]		LEDR;

//////////// KEY //////////
input 		          		CPU_RESET_n;
input 		     [3:0]		KEY;

//////////// SW //////////
input 		     [9:0]		SW;

//////////// SEG7 //////////
output		     [6:0]		HEX0;
output		     [6:0]		HEX1;
output		     [6:0]		HEX2;
output		     [6:0]		HEX3;

//////////// HDMI-TX //////////
output		          		HDMI_TX_CLK;
output		    [23:0]		HDMI_TX_D;
output		          		HDMI_TX_DE;
output		          		HDMI_TX_HS;
input 		          		HDMI_TX_INT;
output		          		HDMI_TX_VS;

//////////// ADC SPI //////////
output		          		ADC_CONVST;
output		          		ADC_SCK;
output		          		ADC_SDI;
input 		          		ADC_SDO;

//////////// Audio //////////
input 		          		AUD_ADCDAT;
inout 		          		AUD_ADCLRCK;
inout 		          		AUD_BCLK;
output		          		AUD_DACDAT;
inout 		          		AUD_DACLRCK;
output		          		AUD_XCK;

//////////// I2C for Audio/HDMI-TX/Si5338/HSMC //////////
output		          		I2C_SCL;
inout 		          		I2C_SDA;

//////////// SDCARD //////////
output		          		SD_CLK;
inout 		          		SD_CMD;
inout 		     [3:0]		SD_DAT;

//////////// Uart to USB //////////
input 		          		UART_RX;
output		          		UART_TX;

//////////// SRAM //////////
output		    [17:0]		SRAM_A;
output		          		SRAM_CE_n;
inout 		    [15:0]		SRAM_D;
output		          		SRAM_LB_n;
output		          		SRAM_OE_n;
output		          		SRAM_UB_n;
output		          		SRAM_WE_n;

`ifdef ENABLE_LPDDR2
//////////// LPDDR2 //////////
output		     [9:0]		DDR2LP_CA;
output		          		DDR2LP_CK_n;
output		          		DDR2LP_CK_p;
output		     [1:0]		DDR2LP_CKE;
output		     [1:0]		DDR2LP_CS_n;
output		     [3:0]		DDR2LP_DM;
inout 		    [31:0]		DDR2LP_DQ;
inout 		     [3:0]		DDR2LP_DQS_n;
inout 		     [3:0]		DDR2LP_DQS_p;
input 		          		DDR2LP_OCT_RZQ;
`endif

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire clock, reset_n;
wire [15:0] display;
wire display_enable;

//=======================================================
//  Structural coding
//=======================================================

assign clock = CLOCK_50_B5B;
assign reset_n = CPU_RESET_n;
assign display_enable = 1'b1;

// Hex display
hex_driver hex0 (.enable(display_enable), .in(display[3:0]), .out(HEX0));
hex_driver hex1 (.enable(display_enable), .in(display[7:4]), .out(HEX1));
hex_driver hex2 (.enable(display_enable), .in(display[11:8]), .out(HEX2));
hex_driver hex3 (.enable(display_enable), .in(display[15:12]), .out(HEX3));

ram r0 (
	.clock, .reset_n, .reg_load_ub(~KEY[3] & SW[8]), .reg_load_lb(~KEY[3] & ~SW[8]), .reg_sel(SW[9]),
	.read(~KEY[2]), .write(~KEY[1]), .reg_d({SW[7:0], SW[7:0]}), .reg_q(display),
	.ram_ce_n(SRAM_CE_n), .ram_oe_n(SRAM_OE_n), .ram_ub_n(SRAM_UB_n), .ram_lb_n(SRAM_LB_n),
	.ram_we_n(SRAM_WE_n), .ram_a(SRAM_A), .ram_d(SRAM_D)
);

shifter x(.in(display), .out({ LEDR[7:0], LEDG[7:0] }), .mode(KEY[2:0]), .n(SW[3:0]));

endmodule
