// vim: set filetype=verilog
module typing(
	input clk,
	input reset,
	inout ps2clk,
	inout ps2data,
	output[3:0] lcdData,
	output lcdRS,
	output lcdE,
	output[7:0] hex0,
	output[7:0] hex1,
	output[7:0] hex2,
	output[7:0] hex3
);
`include "functions.sv"

byte unsigned scancode;
byte unsigned dIn;
bit[3:0] charNum;
bit[3:0] charNumPrev;
bit wLineEn;
bit wLineEnNext;
bit wEn;
bit rx_released_prev;
bit rx_released;
wire min_finish;
byte unsigned rx_ascii;
byte unsigned rx_ascii_prev;
bit[0:7][7:0] target_string;
bit[0:7][7:0] next_string;
wire[3:0] random;

assign dIn = 8'h20;

min_counter MIN (.*, .hex({hex0,hex1,hex2,hex3}));
prng RNG (.*);
LCDDriver4Bit LCD (.clk(clk), .reset(reset),
	.lcdData(lcdData), .lcdRs(lcdRS), .lcdE(lcdE),
	.wLineEn(wLineEn), .wEn(wEn), .charNum(charNumPrev),
	.lineIn(target_string),.nextLineIn(next_string), .dIn(dIn)
	);
ps2_keyboard_interface KBD (.clk(clk), .reset(reset),
	.ps2_clk(ps2clk), .ps2_data(ps2data),
	.rx_scan_code(scancode), .rx_ascii(rx_ascii),
	.rx_released(rx_released));

always@(posedge clk, posedge reset) begin
	if (reset) begin
		next_string <= string_table(random);
		target_string <= string_table(random);
		charNum <= 0;
		wEn <= 0;
		wLineEn <= 0;
		wLineEnNext <= 1;
	end else begin
			
		if(wLineEnNext) begin
			wLineEn <= 1;
			wLineEnNext <= 0;
		end else
			wLineEn <= 0;
			
		if((rx_released_prev || rx_ascii != rx_ascii_prev) &&
		!rx_released && rx_ascii == target_string[charNum])
			if(charNum == 4'h7 ||
				target_string[charNum+4'b1] == 8'h00) begin
				wEn <= 0;
				wLineEnNext <= 1;
				target_string <= next_string;
				next_string <= string_table(random);
				charNum <= 4'h0;
			end else begin
				wEn <= 1;
				charNum <= charNum + 4'b1;
			end
		else
			wEn <= 0;

		charNumPrev <= charNum;
		rx_released_prev <= rx_released;
		rx_ascii_prev <= rx_ascii; 
	end
end
endmodule
