module typing_de0(input CLOCK_50, input[9:0] SW,
	inout PS2_KBCLK, inout PS2_KBDAT, inout[31:0] GPIO_0,
	output[7:0] HEX0, output[7:0] HEX1,
	output[7:0] HEX2, output[7:0] HEX3
);
typing MAIN (.reset(SW[0]),.clk(CLOCK_50),
	.lcdData(GPIO_0[5:2]),.lcdE(GPIO_0[1]),.lcdRS(GPIO_0[0]),
	.ps2clk(PS2_KBCLK),.ps2data(PS2_KBDAT),
	.hex0(HEX0), .hex1(HEX1), .hex2(HEX2), .hex3(HEX3)
);
endmodule
